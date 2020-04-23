import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/profile_provider.dart';
import 'package:chatly/widgets/profile_name.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = "/chat-screen";
  final Profile receiverProifle;
  ChatScreen(this.receiverProifle);
  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    final Profile senderProfile = profileProvider.profile;
    return Scaffold(
        appBar: AppBar(
          title: ProfileName(receiverProifle),
        ),
        body: profileProvider.isInitialized
            ? Center(
                child: Text("chat body"),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
