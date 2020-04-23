import 'package:chatly/providers/auth_user_providers.dart';
import 'package:chatly/screens/edit_profile_screen.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

enum ProfileOptions { editProfile, logOut }

class ProfileOptionPopUpButton extends StatelessWidget {
  void _logOut(BuildContext context) async {
    final AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context, listen: false);
    authUserProvider.signOutUser();
  }

  void _editProfile(BuildContext context) {
    Navigator.pushNamed(context, EditProfileScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ProfileOptions>(
      onSelected: (result) {
        switch (result) {
          case ProfileOptions.editProfile:
            _editProfile(context);
            break;
          case ProfileOptions.logOut:
            _logOut(context);
            break;
        }
      },
      itemBuilder: (ctx) => [
        PopupMenuItem(
          value: ProfileOptions.editProfile,
          child: Text("Edit Profile"),
        ),
        PopupMenuItem(
          value: ProfileOptions.logOut,
          child: Text("Log Out"),
        ),
      ],
    );
  }
}
