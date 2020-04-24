import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/all_profile_provider.dart';
import 'package:chatly/views/profile_tile.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ProfileTileList extends StatelessWidget {
  final isActiveProfileList;
  ProfileTileList({this.isActiveProfileList = false});
  @override
  Widget build(BuildContext context) {
    final AllProfileProvider allProfileProvider =
        Provider.of<AllProfileProvider>(context);
    final List<Profile> profileList = allProfileProvider.allProfiles;
    return profileList.isEmpty
        ? Center(child: Text("No Profile available"))
        : ListView.builder(
            itemBuilder: (ctx, index) {
              final Profile profile = profileList[index];
              return MultiProvider(
                providers: [
                  Provider.value(value: profile),
                  ChangeNotifierProvider.value(
                      value: allProfileProvider.getMessageProvider(profile.pid))
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
