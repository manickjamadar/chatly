import 'package:chatly/models/profile.dart';
import "package:flutter/material.dart";

class ProfileAvatar extends StatelessWidget {
  final Profile profile;
  final double radius;
  ProfileAvatar(this.profile, {this.radius = 40});
  Widget get avatarPlaceHolder => Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.all(Radius.circular(radius))),
      child: Center(child: Icon(Icons.person, color: Colors.white)));
  @override
  Widget build(BuildContext context) {
    bool isAvatarUrlAvailable =
        profile.avatarUrl != null && profile.avatarUrl.isNotEmpty;
    return Stack(
      children: <Widget>[
        avatarPlaceHolder,
        if (isAvatarUrlAvailable)
          SizedBox(
            width: radius,
            height: radius,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Image.network(
                  profile.avatarUrl,
                )),
          ),
      ],
    );
  }
}
