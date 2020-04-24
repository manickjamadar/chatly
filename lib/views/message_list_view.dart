import 'package:chatly/models/message.dart';
import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/profile_provider.dart';
import 'package:chatly/widgets/message_tile.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class MessageListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    final Profile senderProfile = profileProvider.profile;
    final Profile receiverProfile = Provider.of<Profile>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: ListView(
        reverse: true,
        children: List.generate(
            20,
            (i) => MessageTile(
                  senderProfile: senderProfile,
                  receiverProfile: receiverProfile,
                  message: Message(
                      mid: "asfa",
                      messageStatus: i % 3 == 0
                          ? MessageStatus.seen
                          : (i % 2 == 0
                              ? MessageStatus.sent
                              : MessageStatus.delivered),
                      content: i % 3 == 0
                          ? "My name is manick"
                          : "My name is manick and i am developer so don't try do anything else",
                      senderId:
                          i % 2 == 0 ? receiverProfile.pid : senderProfile.pid,
                      receiverId:
                          i % 2 == 0 ? senderProfile.pid : receiverProfile.pid),
                )),
      ),
    );
  }
}
