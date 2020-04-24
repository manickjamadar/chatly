import 'package:chatly/providers/all_profile_provider.dart';
import 'package:chatly/views/profile_title_list.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ActiveChatProfileList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AllProfileProvider allProfileProvider =
        Provider.of<AllProfileProvider>(context);
    return allProfileProvider.isInitialized
        ? Center(
            child: ProfileTileList(
              isActiveProfileList: true,
            ),
          )
        : Center(child: Text("Loading Contacts..."));
  }
}
