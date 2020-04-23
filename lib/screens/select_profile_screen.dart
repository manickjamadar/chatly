import 'package:chatly/providers/all_profile_provider.dart';
import 'package:chatly/widgets/profile_title_list.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class SelectProfileScreen extends StatelessWidget {
  static const String routeName = "/select-profile-screen";
  @override
  Widget build(BuildContext context) {
    final AllProfileProvider allProfileProvider =
        Provider.of<AllProfileProvider>(context);
    final allProfile = allProfileProvider.allProfiles;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Select Contact"),
            Text("${allProfile?.length ?? 0} contacts",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal))
          ],
        ),
      ),
      body: allProfileProvider.isInitialized
          ? Center(
              child: ProfileTileList(
                allProfile,
                isReplaceScreenToChat: true,
              ),
            )
          : Center(child: Text("Loading Contacts...")),
    );
  }
}
