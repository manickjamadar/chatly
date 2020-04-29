import 'package:chatly/helpers/string_methods.dart';
import 'package:chatly/models/profile.dart';
import "package:flutter/material.dart";

class ProfileViewer extends StatelessWidget {
  final Widget child;
  final Profile profile;
  ProfileViewer({@required this.child, @required this.profile});
  Dialog profileDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          profile.avatarUrl == null || profile.avatarUrl.isEmpty
              ? Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Center(
                      child: Icon(
                    Icons.person,
                    color: Colors.white,
                  )))
              : ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Hero(
                      tag: profile.avatarUrl,
                      child:
                          Image.network(profile.avatarUrl, fit: BoxFit.cover))),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                if (profile.name != null) ...[
                  Text(
                    capitalize(profile.name),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
                Text(profile.number)
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onTap: () {
        showDialog(context: context, child: profileDialog());
      },
    );
  }
}
