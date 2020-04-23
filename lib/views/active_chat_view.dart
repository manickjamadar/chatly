import 'package:chatly/providers/all_profile_provider.dart';
import 'package:chatly/widgets/profile_title_list.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ActiveChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AllProfileProvider allProfileProvider =
        Provider.of<AllProfileProvider>(context);
    final activeProfiles = allProfileProvider.activeProfiles;
    return allProfileProvider.isInitialized
        ? ProfileTileList(activeProfiles)
        : Center(child: CircularProgressIndicator());
  }
}
