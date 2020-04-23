import 'package:chatly/providers/all_profile_provider.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class SelectProfileScreen extends StatelessWidget {
  static const String routeName = "/select-profile-screen";
  @override
  Widget build(BuildContext context) {
    final AllProfileProvider allProfileProvider =
        Provider.of<AllProfileProvider>(context);
    print(allProfileProvider.nonActiveProfiles);
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Contact"),
      ),
      body: allProfileProvider.isInitialized
          ? Center(
              child: Text("contacts"),
            )
          : Center(child: Text("Loading Contacts...")),
    );
  }
}
