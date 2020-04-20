import 'package:flutter/foundation.dart';

class Profile {
  final String pid;
  final DateTime createdDate;
  final String number;
  DateTime _updatedDate;
  //nullable properties
  String _name;
  String _profileUrl;
  DateTime _lastSeen;

  //getters
  String get name => _name;
  String get profileUrl => _profileUrl;
  DateTime get updatedDate => _updatedDate;
  DateTime get lastSeen => _lastSeen;

  Profile(
      {@required this.pid,
      @required this.number,
      String name,
      String profileUrl,
      DateTime lastSeen})
      : _name = name,
        _profileUrl = profileUrl,
        _lastSeen = lastSeen,
        createdDate = DateTime.now(),
        _updatedDate = DateTime.now();
  Profile.fromMap(Map<String, dynamic> profileMap)
      : pid = profileMap['pid'],
        _name = profileMap['name'],
        number = profileMap['number'],
        _profileUrl = profileMap['profileUrl'],
        _lastSeen = profileMap['lastSeen'],
        createdDate = profileMap['createdDate'],
        _updatedDate = profileMap['updatedDate'];
  Map<String, dynamic> toMap() => ({
        "pid": pid,
        "name": _name,
        "number": number,
        "profileUrl": _profileUrl,
        "lastSeen": _lastSeen,
        "createdDate": createdDate,
        "updatedDate": _updatedDate
      });
  void update(
      {String name, String profileUrl, String lastSeen, DateTime updatedDate}) {
    _name = name ?? _name;
    _profileUrl = profileUrl ?? _profileUrl;
    _lastSeen = lastSeen ?? _lastSeen;
    _updatedDate = updatedDate ?? DateTime.now();
  }
}
