import 'package:chatly/models/profile.dart';
import 'package:chatly/widgets/profile_tile.dart';
import "package:flutter/material.dart";

class ProfileTileList extends StatelessWidget {
  final List<Profile> profileList;
  final isReplaceScreenToChat;
  ProfileTileList(this.profileList, {this.isReplaceScreenToChat = false});
  @override
  Widget build(BuildContext context) {
    return profileList.isEmpty
        ? Center(child: Text("No Profile available"))
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return ProfileTile(
                profileList[index],
                isReplaceScreenToChat: isReplaceScreenToChat,
              );
            },
            itemCount: profileList.length,
          );
  }
}
