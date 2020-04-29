import 'package:chatly/helpers/failure.dart';
import 'package:chatly/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MessagesService {
  Firestore _firestore = Firestore.instance;
  final String messageCollectionName = "messages";
  CollectionReference _getMessageCollection() {
    return _firestore.collection(messageCollectionName);
  }

  DocumentReference _getMessageDocument(Message message) {
    return _getMessageCollection().document(message.mid);
  }

  String getNewMessageId() {
    return _getMessageCollection().document().documentID;
  }

  Future<void> sendMessageToServer(Message message) async {
    try {
      await _getMessageDocument(message).setData(message.toMap(), merge: true);
    } catch (error) {
      throw Failure.public("Message sent failed");
    }
  }

  Future<List<Message>> fetchAllMessage(
      {@required senderId, @required receiverId}) async {
    try {
      final QuerySnapshot querySnapshot = await _getMessageCollection()
          .orderBy(Message.CREATEDDATE, descending: true)
          .where(Message.QUERY_ID,
              isEqualTo: Message.generateQueryId(
                  senderId: senderId, receiverId: receiverId))
          .getDocuments();
      final List<Message> result = [];
      querySnapshot.documents.forEach((docSnapshot) {
        if (docSnapshot.exists) {
          result.add(Message.fromMap(docSnapshot.data));
        }
      });
      return result;
    } catch (error) {
      throw Failure.public("Fetching all message error");
    }
  }

  Stream<Message> getLatestMessage(
          {@required senderId, @required receiverId}) =>
      _getMessageCollection()
          .orderBy(Message.CREATEDDATE, descending: true)
          .where(Message.QUERY_ID,
              isEqualTo: Message.generateQueryId(
                  senderId: senderId, receiverId: receiverId))
          .where(Message.SENDERID, isEqualTo: receiverId)
          .where(Message.MESSAGESTATUS, isEqualTo: MessageStatus.sent.index)
          .limit(1)
          .snapshots()
          .map<Message>((querySnapshot) {
        final List<DocumentSnapshot> docSnapshots = querySnapshot.documents;
        if (docSnapshots.isEmpty) return null;
        final firstDoc = docSnapshots.first;
        if (!firstDoc.exists) return null;
        return Message.fromMap(firstDoc.data);
      });
}
