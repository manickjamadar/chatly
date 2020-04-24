import 'package:chatly/models/message.dart';
import "package:flutter/material.dart";

class MessageStatusIcon extends StatelessWidget {
  final MessageStatus status;
  final Color color;
  final double size;
  MessageStatusIcon(this.status, {this.color = Colors.grey, this.size = 15});
  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageStatus.sent:
        return Icon(Icons.check, color: color, size: size);
        break;
      case MessageStatus.delivered:
        return Icon(Icons.done_all, color: color, size: size);
      case MessageStatus.seen:
        return Icon(
          Icons.done_all,
          size: size,
          color: Colors.blue,
        );
      default:
        return Icon(Icons.check, color: color, size: size);
    }
  }
}
