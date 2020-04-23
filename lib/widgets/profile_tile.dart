import 'package:chatly/helpers/message_date_formatter.dart';
import 'package:chatly/models/message.dart';
import 'package:chatly/models/profile.dart';
import 'package:chatly/screens/chat_screen.dart';
import 'package:chatly/widgets/message_status_icon.dart';
import 'package:chatly/widgets/profile_avatart.dart';
import 'package:chatly/widgets/profile_name.dart';
import 'package:chatly/widgets/profile_viewer.dart';
import "package:flutter/material.dart";

class ProfileTile extends StatelessWidget {
  final Profile profile;
  final Message lastMessage;
  final bool isReplaceScreenToChat;
  const ProfileTile(this.profile,
      {this.lastMessage, this.isReplaceScreenToChat = false});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final chatPageRoute =
            MaterialPageRoute(builder: (ctx) => ChatScreen(profile));
        if (isReplaceScreenToChat) {
          Navigator.pushReplacement(context, chatPageRoute);
        } else {
          Navigator.push(context, chatPageRoute);
        }
      },
      contentPadding: const EdgeInsets.all(10),
      leading: ProfileViewer(
        profile: profile,
        child: ProfileAvatar(
          profile,
          radius: 50,
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
