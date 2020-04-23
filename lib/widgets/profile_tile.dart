import 'package:chatly/helpers/message_date_formatter.dart';
import 'package:chatly/helpers/string_methods.dart';
import 'package:chatly/models/message.dart';
import 'package:chatly/models/profile.dart';
import 'package:chatly/widgets/message_status_icon.dart';
import 'package:chatly/widgets/profile_name.dart';
import 'package:chatly/widgets/profile_viewer.dart';
import "package:flutter/material.dart";

class ProfileTile extends StatelessWidget {
  final Profile profile;
  final Message lastMessage;
  const ProfileTile(this.profile, {this.lastMessage});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(10),
      leading: ProfileViewer(
        profile: profile,
        child: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.redAccent,
          backgroundImage:
              profile.avatarUrl == null || profile.avatarUrl.isEmpty
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
      ),
      title:
          ProfileName(profile, style: TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }
}
