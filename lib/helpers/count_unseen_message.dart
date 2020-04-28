import 'package:chatly/models/message.dart';
import 'package:chatly/models/profile.dart';
import 'package:flutter/foundation.dart';

class UnseenMessageCount {
  final bool isEmpty;
  final bool isNotEmpty;
  final int count;

  UnseenMessageCount(this.count)
      : isEmpty = count == 0,
        isNotEmpty = count != 0;

  factory UnseenMessageCount.fromMessageList(
      {@required List<Message> messageList,
      @required Profile receiverProfile}) {
    int resultCount = 0;
    for (int i = 0; i < messageList.length; i++) {
      final message = messageList[i];
      final bool isIncomingMessage = message.senderId == receiverProfile.pid;
      if (!isIncomingMessage || message.messageStatus == MessageStatus.seen)
        return UnseenMessageCount(resultCount);
      resultCount++;
    }
    return UnseenMessageCount(resultCount);
  }

  @override
  String toString() {
    if (count < 0) return "0";
    if (count > 99) return "99+";
    return "$count";
  }
}
