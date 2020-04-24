import 'package:chatly/providers/profile_provider.dart';
import 'package:chatly/views/profile_title_list.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class SelectProfileScreen extends StatelessWidget {
  static const String routeName = "/select-profile-screen";
  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    final allProfile = profileProvider.allProfiles;
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
      body: profileProvider.isInitialized
          ? Center(
              child: ProfileTileList(),
            )
          : Center(child: Text("Loading Contacts...")),
    );
  }
}
