import 'package:chatly/models/profile.dart';
import "package:flutter/material.dart";

class ProfileAvatar extends StatelessWidget {
  final Profile profile;
  final double radius;
  ProfileAvatar(this.profile, {this.radius = 40});
  @override
  Widget build(BuildContext context) {
    bool isAvatarUrlAvailable =
        profile.avatarUrl != null && profile.avatarUrl.isNotEmpty;
    return Container(
      width: radius,
      height: radius,
      child: !isAvatarUrlAvailable
          ? Icon(Icons.person, color: Colors.white)
          : ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Hero(
                  tag: profile.avatarUrl,
                  child: Image.network(profile.avatarUrl))),
      decoration: BoxDecoration(
          color: isAvatarUrlAvailable ? Colors.transparent : Colors.redAccent,
          borderRadius: BorderRadius.all(Radius.circular(radius))),
    );
  }
}
