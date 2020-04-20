import 'package:flutter/foundation.dart';

class Profile {
  final String pid;
  final DateTime createdDate;
  final String number;
  DateTime _updatedDate;
  //nullable properties
  String _name;
  String _avatarUrl;
  DateTime _lastSeen;

  //getters
  String get name => _name;
  String get avatarUrl => _avatarUrl;
  DateTime get updatedDate => _updatedDate;
  DateTime get lastSeen => _lastSeen;

  Profile(
      {@required this.pid,
      @required this.number,
      String name,
      String avatarUrl,
      DateTime lastSeen})
      : _name = name,
        _avatarUrl = avatarUrl,
        _lastSeen = lastSeen,
        createdDate = DateTime.now(),
        _updatedDate = DateTime.now();
  Profile.fromMap(Map<String, dynamic> profileMap)
      : pid = profileMap['pid'],
        _name = profileMap['name'],
        number = profileMap['number'],
        _avatarUrl = profileMap['avatarUrl'],
        _lastSeen = profileMap['lastSeen'],
        createdDate = profileMap['createdDate'],
        _updatedDate = profileMap['updatedDate'];
  Map<String, dynamic> toMap() => ({
        "pid": pid,
        "name": _name,
        "number": number,
        "avatarUrl": _avatarUrl,
        "lastSeen": _lastSeen,
        "createdDate": createdDate,
        "updatedDate": _updatedDate
      });
  void update(
      {String name, String avatarUrl, String lastSeen, DateTime updatedDate}) {
    _name = name ?? _name;
    _avatarUrl = avatarUrl ?? _avatarUrl;
    _lastSeen = lastSeen ?? _lastSeen;
    _updatedDate = updatedDate ?? DateTime.now();
  }
}
