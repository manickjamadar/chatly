import 'package:chatly/helpers/failure.dart';
import 'package:chatly/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MessagesService {
  Firestore _firestore = Firestore.instance;
  CollectionReference _getMessageCollection(
      {@required String senderId, @required String receiverId}) {
    String messageCollectionName;
    final int idComparedResult = senderId.compareTo(receiverId);
    if (idComparedResult == 0 || idComparedResult == 1) {
      messageCollectionName = senderId + receiverId;
    } else {
      messageCollectionName = receiverId + senderId;
    }
    return _firestore.collection(messageCollectionName);
  }

  DocumentReference _getMessageDocument(Message message) {
    return _getMessageCollection(
            senderId: message.senderId, receiverId: message.receiverId)
        .document(message.mid);
  }

  String getNewMessageId(
      {@required String senderId, @required String receiverId}) {
    return _getMessageCollection(senderId: senderId, receiverId: receiverId)
        .document()
        .documentID;
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
      final QuerySnapshot querySnapshot = await _getMessageCollection(
              senderId: senderId, receiverId: receiverId)
          .orderBy(Message.CREATEDDATE, descending: true)
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
      _getMessageCollection(senderId: senderId, receiverId: receiverId)
          .orderBy(Message.CREATEDDATE, descending: true)
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
