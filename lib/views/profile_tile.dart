import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/message_provider.dart';
import 'package:chatly/screens/chat_screen.dart';
import 'package:chatly/widgets/profile_avatart.dart';
import 'package:chatly/widgets/profile_name.dart';
import 'package:chatly/widgets/profile_viewer.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ProfileTile extends StatelessWidget {
  final bool isActiveProfile;
  const ProfileTile({this.isActiveProfile = false});
  @override
  Widget build(BuildContext context) {
    final Profile profile = Provider.of<Profile>(context);
    final MessageProvider messageProvider =
        Provider.of<MessageProvider>(context);
    return ListTile(
      onTap: () {
        final chatPageRoute = MaterialPageRoute(
            builder: (ctx) => MultiProvider(
                  providers: [
                    Provider.value(value: profile),
                    ChangeNotifierProvider.value(value: messageProvider)
                  ],
                  child: ChatScreen(),
                ));
        if (isActiveProfile) {
          Navigator.push(context, chatPageRoute);
        } else {
          Navigator.pushReplacement(context, chatPageRoute);
        }
      },
      contentPadding: const EdgeInsets.all(10),
      leading: ProfileViewer(
        profile: profile,
        child: ProfileAvatar(
          profile,
          radius: 50,
        ),
      ),
      title:
          ProfileName(profile, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
