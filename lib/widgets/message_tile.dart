import 'package:chatly/helpers/message_date_formatter.dart';
import 'package:chatly/models/message.dart';
import 'package:chatly/models/profile.dart';
import 'package:chatly/widgets/message_status_icon.dart';
import "package:flutter/material.dart";

class MessageTile extends StatelessWidget {
  final Message message;
  final Profile senderProfile;
  final Profile receiverProfile;
  MessageTile(
      {@required this.message,
      @required this.senderProfile,
      @required this.receiverProfile});
  @override
  Widget build(BuildContext context) {
    bool isSenderMessage = senderProfile.pid == message.senderId;
    return Align(
        alignment:
            isSenderMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                  color: isSenderMessage
                      ? Theme.of(context).primaryColor
                      : Colors.grey[100],
                  child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        message.content,
                        style: TextStyle(
                            color: isSenderMessage
                                ? Colors.white
                                : Colors.grey[800]),
                      ))),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (isSenderMessage)
                    MessageStatusIcon(message.messageStatus, size: 16),
                  SizedBox(
                    width: 4,
                  ),
                  Text(messsageTimeFormatter(message.createdDate),
                      style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              )
            ],
          ),
        ));
  }
}
