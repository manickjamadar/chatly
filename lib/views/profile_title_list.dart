import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/profile_provider.dart';
import 'package:chatly/views/profile_tile.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ProfileTileList extends StatelessWidget {
  final isActiveProfileList;
  ProfileTileList({this.isActiveProfileList = false});
  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    final List<Profile> profileList = isActiveProfileList
        ? profileProvider.getActiveProfiles()
        : profileProvider.allProfiles;
    return profileList.isEmpty
        ? Center(child: Text("No Profile available"))
        : ListView.builder(
            itemBuilder: (ctx, index) {
              final Profile profile = profileList[index];
              return MultiProvider(
                providers: [
                  Provider.value(value: profile),
                  ChangeNotifierProvider.value(
                      value: profileProvider.getMessageProvider(profile.pid))
                ],
                child: ProfileTile(
                  isActiveProfile: isActiveProfileList,
                ),
              );
            },
            itemCount: profileList.length,
          );
  }
}
