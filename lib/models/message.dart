import 'package:chatly/helpers/timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum MessageStatus { sent, delivered, seen }

class Message {
  static const String MID = 'mid';
  static const String SENDERID = 'senderId';
  static const String RECEIVERID = 'receiverId';
  static const String CONTENT = 'content';
  static const String CREATEDDATE = 'createdDate';
  static const String MESSAGESTATUS = 'messageStatus';
  static const String STATUSUPDATEDDATE = 'statusUpdatedDate';
  static const String QUERY_ID = "query_id";
  static String generateQueryId(
      {@required String senderId, @required String receiverId}) {
    final int comparedResult = senderId.compareTo(receiverId);
    if (comparedResult == 0 || comparedResult == 1) {
      return senderId + receiverId;
    } else {
      return receiverId + senderId;
    }
  }

  final String mid;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime createdDate;
  final String queryId;
  MessageStatus _messageStatus;
  DateTime _statusUpdatedDate;
  MessageStatus get messageStatus => _messageStatus;
  DateTime get statusUpdatedDate => _statusUpdatedDate;

  Message(
      {@required this.mid,
      @required this.senderId,
      @required this.receiverId,
      @required this.content,
      MessageStatus messageStatus = MessageStatus.sent})
      : _messageStatus = messageStatus,
        queryId = generateQueryId(senderId: senderId, receiverId: receiverId),
        createdDate = DateTime.now(),
        _statusUpdatedDate = DateTime.now();
  Message.fromMap(Map<String, dynamic> messageMap)
      : mid = messageMap[MID],
        senderId = messageMap[SENDERID],
        receiverId = messageMap[RECEIVERID],
        content = messageMap[CONTENT],
        queryId = messageMap[Message.QUERY_ID],
        createdDate = timestampToDateTime(messageMap[CREATEDDATE]),
        _messageStatus = MessageStatus.values[messageMap[MESSAGESTATUS]],
        _statusUpdatedDate =
            timestampToDateTime(messageMap[STATUSUPDATEDDATE] as Timestamp);
  Map<String, dynamic> toMap() => ({
        MID: mid,
        SENDERID: senderId,
        RECEIVERID: receiverId,
        CONTENT: content,
        QUERY_ID: queryId,
        CREATEDDATE: createdDate,
        MESSAGESTATUS: _messageStatus.index,
        STATUSUPDATEDDATE: _statusUpdatedDate
      });
  void updateStatus(MessageStatus status, DateTime updatedDate) {
    _messageStatus = status;
    _statusUpdatedDate = updatedDate ?? DateTime.now();
  }
}
