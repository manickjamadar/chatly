import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/profile_provider.dart';
import 'package:chatly/providers/view_state_provider.dart';
import 'package:chatly/widgets/profile_name.dart';
import 'package:chatly/views/profile_option_popup_button.dart';
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
                    Container(
                      width: 40,
                      height: 40,
                      child:
                          profile.avatarUrl == null || profile.avatarUrl.isEmpty
                              ? Icon(Icons.person)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Image.network(profile.avatarUrl)),
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                    ),
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
                onPressed: () {},
              ),
              body: TabBarView(
                children: <Widget>[
                  Center(
                    child: Text("No User Available"),
                  ),
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
