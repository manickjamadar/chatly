import 'package:chatly/helpers/string_methods.dart';
import 'package:chatly/models/profile.dart';
import "package:flutter/material.dart";

class ProfileName extends StatelessWidget {
  final Profile profile;
  final TextStyle style;
  ProfileName(this.profile, {this.style});
  @override
  Widget build(BuildContext context) {
    return Text(
      profile.name == null ? profile.number : capitalize(profile.name),
      style: style,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }
}
