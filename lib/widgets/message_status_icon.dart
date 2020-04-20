import 'package:chatly/models/message.dart';
import "package:flutter/material.dart";

class MessageStatusIcon extends StatelessWidget {
  final MessageStatus status;
  final Color color;
  MessageStatusIcon(this.status, {this.color = Colors.grey});
  @override
  Widget build(BuildContext context) {
    print(status);
    switch (status) {
      case MessageStatus.sent:
        return Icon(Icons.check, color: color);
        break;
      case MessageStatus.delivered:
        return Icon(Icons.done_all, color: color);
      case MessageStatus.seen:
        return Icon(
          Icons.done_all,
          color: Colors.blue,
        );
      default:
        return Icon(Icons.check, color: color);
    }
  }
}
