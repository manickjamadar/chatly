import 'package:ansicolor/ansicolor.dart';
import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/message_provider.dart';
import 'package:chatly/providers/profile_provider.dart';
import 'package:chatly/views/message_list_view.dart';
import 'package:chatly/widgets/profile_avatart.dart';
import 'package:chatly/widgets/profile_name.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = "/chat-screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  TextEditingController _messageContentController;
  Widget sendButton(BuildContext context) {
    final MessageProvider messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final Profile receiverProfile =
        Provider.of<Profile>(context, listen: false);
    return ClipOval(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: IconButton(
          icon: Icon(
            Icons.send,
            color: Colors.white,
          ),
          onPressed: () {
            final String messageContent = _messageContentController.text;
            if (messageContent.isEmpty) return;
            _messageContentController.clear();
            if (messageProvider.messagesList.isEmpty) {
              profileProvider.addActiveChatProfileId(receiverProfile.pid);
            }
            messageProvider.sendMessage(content: messageContent);
          },
        ),
      ),
    );
  }

  Widget messageSender(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextField(
            controller: _messageContentController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.sentiment_satisfied),
                contentPadding:
                    EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
                hintText: "Enter your message",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30))),
          )),
          SizedBox(
            width: 4,
          ),
          sendButton(context)
        ],
      ),
    );
  }

  void _backPressed() {
    final MessageProvider messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    messageProvider.deactivate();
  }

  @override
  void initState() {
    _messageContentController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _messageContentController = TextEditingController();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final MessageProvider messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    if (state == AppLifecycleState.resumed) {
      messageProvider.activate();
    } else {
      messageProvider.deactivate();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    final Profile receiverProfile = Provider.of<Profile>(context);
    return WillPopScope(
      onWillPop: () {
        _backPressed();
        return Future(() => true);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                if (ModalRoute.of(context).canPop) {
                  _backPressed();
                  Navigator.pop(context);
                }
              },
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.arrow_back,
                    size: 20,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  ProfileAvatar(
                    receiverProfile,
                    radius: 30,
                  )
                ],
              ),
            ),
            title: ProfileName(receiverProfile),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
              IconButton(icon: Icon(Icons.call), onPressed: () {}),
              IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
          body: profileProvider.isInitialized
              ? Column(
                  children: <Widget>[
                    Expanded(child: MessageListView()),
                    messageSender(context)
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
