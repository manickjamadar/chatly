import 'package:chatly/models/message.dart';
import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/profile_provider.dart';
import 'package:chatly/providers/view_state_provider.dart';
import 'package:chatly/screens/select_profile_screen.dart';
import 'package:chatly/views/active_chat_profile_list.dart';
import 'package:chatly/views/profile_search.dart';
import 'package:chatly/widgets/profile_avatart.dart';
import 'package:chatly/widgets/profile_name.dart';
import 'package:chatly/views/profile_option_popup_button.dart';
import 'package:chatly/widgets/profile_viewer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static const String mainScreen = "/main-screen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> fcm) async {
      // final Map<String, dynamic> data = fcm['data'];
      // final bool isMessageAvailable = data['isMessageAvailable'];
      // if (isMessageAvailable == null || !isMessageAvailable) return;
      // final Message message = Message.fromMap(data['data']);
      //do something with message;
      print("\n\n\n\n\n\n\n\n\n\n\n\n");
      print("On Message:");
      // print("Message Instance: ${message.toMap()}");
    }, onResume: (Map<String, dynamic> data) async {
      // final Message message = Message.fromMap(data['data']);
      //do something with resume
      print("\n\n\n\n\n\n\n\n\n\n\n\n");
      print("On Resume:");
      // print("Message Instance: ${message.toMap()}");
    }, onLaunch: (Map<String, dynamic> data) async {
      // final Message message = Message.fromMap(data['data']);
      //do something with launch
      print("\n\n\n\n\n\n\n\n\n\n\n\n");
      print("On Launch:");
      print(data);
      // print("Message Instance: ${message.toMap()}");
    });
  }

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
                    onPressed: () {
                      showSearch(context: context, delegate: ProfileSearch());
                    },
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
                  ActiveChatProfileList(),
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
