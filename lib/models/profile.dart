import 'package:chatly/helpers/timestamp_converter.dart';
import 'package:flutter/foundation.dart';

class Profile {
  static const String ACTIVE_CHAT_PROFILE_IDS = "activeChatProfileIds";
  final String pid;
  final DateTime createdDate;
  final String number;
  DateTime _updatedDate;
  final List<String> activeChatProfileIds;
  //nullable properties
  String _name;
  String _avatarUrl;
  DateTime _lastSeen;
  String _pushToken;

  //getters
  String get name => _name;
  String get pushToken => _pushToken;
  String get avatarUrl => _avatarUrl;
  DateTime get updatedDate => _updatedDate;
  DateTime get lastSeen => _lastSeen;

  Profile(
      {@required this.pid,
      @required this.number,
      String name,
      String avatarUrl,
      DateTime lastSeen,
      String pushToken,
      List<String> activeChatProfileIds})
      : _name = name,
        _avatarUrl = avatarUrl,
        _lastSeen = lastSeen,
        this.activeChatProfileIds = activeChatProfileIds ?? [],
        createdDate = DateTime.now(),
        _updatedDate = DateTime.now();
  Profile.fromMap(Map<String, dynamic> profileMap)
      : pid = profileMap['pid'],
        _name = profileMap['name'],
        number = profileMap['number'],
        _avatarUrl = profileMap['avatarUrl'],
        _pushToken = profileMap['pushToken'],
        _lastSeen = timestampToDateTime(profileMap['lastSeen']),
        activeChatProfileIds = profileMap['activeChatProfileIds'] == null
            ? []
            : profileMap['activeChatProfileIds']
                .map<String>((i) => i.toString())
                .toList(),
        createdDate = timestampToDateTime(profileMap['createdDate']),
        _updatedDate = timestampToDateTime(profileMap['updatedDate']);
  Map<String, dynamic> toMap() => ({
        "pid": pid,
        "name": _name,
        "number": number,
        "avatarUrl": _avatarUrl,
        "lastSeen": _lastSeen,
        "pushToken": _pushToken,
        "activeChatProfileIds": activeChatProfileIds ?? [],
        "createdDate": createdDate,
        "updatedDate": _updatedDate
      });
  void addActiveChatUser(String userId) {
    activeChatProfileIds.add(userId);
    _updatedDate = DateTime.now();
  }

  void removeActiveChatUser(int index) {
    activeChatProfileIds.removeAt(index);
    _updatedDate = DateTime.now();
  }

  void removedRecentAddedActiveChatUserId() {
    removeActiveChatUser(activeChatProfileIds.length - 1);
  }

  bool isActiveChatIdAvailable(String id) =>
      activeChatProfileIds.indexOf(id) != -1;

  void update(
      {String name,
      String avatarUrl,
      DateTime lastSeen,
      String pushToken,
      DateTime updatedDate}) {
    _name = name ?? _name;
    _avatarUrl = avatarUrl ?? _avatarUrl;
    _lastSeen = lastSeen ?? _lastSeen;
    _pushToken = pushToken ?? _pushToken;
    _updatedDate = updatedDate ?? DateTime.now();
  }
}
