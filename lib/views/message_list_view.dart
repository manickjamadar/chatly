import 'package:chatly/models/message.dart';
import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/message_provider.dart';
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
    final MessageProvider messageProvider =
        Provider.of<MessageProvider>(context);
    final List<Message> messagesList = messageProvider.messagesList;
    return !messageProvider.isInitialized
        ? Center(
            child: CircularProgressIndicator(),
          )
        : messagesList.isEmpty
            ? Center(child: Text(""))
            : Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: ListView.builder(
                    reverse: true,
                    itemBuilder: (ctx, index) {
                      final Message message = messagesList[index];
                      return MessageTile(
                        message: message,
                        senderProfile: senderProfile,
                        receiverProfile: receiverProfile,
                      );
                    },
                    itemCount: messagesList.length),
              );
  }
}
