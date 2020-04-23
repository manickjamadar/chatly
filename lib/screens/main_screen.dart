import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/profile_provider.dart';
import 'package:chatly/providers/view_state_provider.dart';
import 'package:chatly/screens/select_profile_screen.dart';
import 'package:chatly/views/active_chat_view.dart';
import 'package:chatly/widgets/profile_avatart.dart';
import 'package:chatly/widgets/profile_name.dart';
import 'package:chatly/views/profile_option_popup_button.dart';
import 'package:chatly/widgets/profile_viewer.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  static const String mainScreen = "/main-screen";
  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    final Profile profile = profileProvider.profile;
    return DefaultTabController(
      length: 3,
      child: profileProvider.state == ViewState.initialLoading
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: Center(
                    child: Row(
                  children: <Widget>[
                    ProfileViewer(
                        profile: profile, child: ProfileAvatar(profile)),
                    SizedBox(
                      width: 8,
                    ),
                    ProfileName(profile)
                  ],
                )),
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      text: "Chats",
                    ),
                    Tab(
                      text: "Status",
                    ),
                    Tab(
                      text: "Calls",
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                  ProfileOptionPopUpButton()
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.person),
                onPressed: () {
                  Navigator.pushNamed(context, SelectProfileScreen.routeName);
                },
              ),
              body: TabBarView(
                children: <Widget>[
                  ActiveChatView(),
                  Center(
                    child: Text("Status Coming Soon"),
                  ),
                  Center(
                    child: Text("Calls Feature Coming Soon"),
                  ),
                ],
              )),
    );
  }
}
