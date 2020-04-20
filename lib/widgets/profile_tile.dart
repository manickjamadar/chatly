import 'package:chatly/helpers/message_date_formatter.dart';
import 'package:chatly/helpers/string_methods.dart';
import 'package:chatly/models/message.dart';
import 'package:chatly/models/profile.dart';
import 'package:chatly/widgets/message_status_icon.dart';
import "package:flutter/material.dart";

class ProfileTile extends StatelessWidget {
  final Profile profile;
  final Message lastMessage;
  const ProfileTile(this.profile, {this.lastMessage});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.redAccent,
          backgroundImage: profile.avatarUrl == null
              ? null
              : NetworkImage(profile.avatarUrl),
          child: profile.avatarUrl == null
              ? Container(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
        title: Text(
          profile.name == null ? profile.number : capitalize(profile.name),
          style: TextStyle(fontWeight: FontWeight.bold),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: lastMessage == null
            ? null
            : Row(
                children: <Widget>[
                  if (profile.pid != lastMessage.senderId)
                    MessageStatusIcon(lastMessage.messageStatus),
                  SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      lastMessage.content,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
        trailing: lastMessage == null
            ? null
            : Text(messageDateFormatter(lastMessage.createdDate)),
      ),
    );
  }
}
