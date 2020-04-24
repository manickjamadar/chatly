import 'dart:io';

import 'package:chatly/helpers/failure.dart';
import 'package:chatly/helpers/view_response.dart';
import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/message_provider.dart';
import 'package:chatly/providers/view_state_provider.dart';
import 'package:chatly/service/database_service.dart';
import 'package:chatly/service/stroage_service.dart';
import 'package:flutter/foundation.dart';

class ProfileProvider extends ViewStateProvider {
  //database service can be null
  DatabaseService _databaseService;
  Profile _profile;
  Profile get profile => _profile;
  bool get isProfileAvailable => profile != null;
  bool get isProfileCompleted =>
      isProfileAvailable && profile.name != null && profile.avatarUrl != null;
  List<Profile> _allProfiles = [];
  List<Profile> get allProfiles => _allProfiles;
  Map<String, MessageProvider> _messageProviderList = {};
  MessageProvider getMessageProvider(String profileId) =>
      _messageProviderList[profileId];

  ProfileProvider(DatabaseService databaseService)
      : _databaseService = databaseService {
    if (databaseService == null) return;
    _tryFetchingProfile();
  }
  Future<void> _fetchAllProfile() async {
    try {
      _allProfiles = await _databaseService.getAllProfile();
      if (_allProfiles.isNotEmpty) {
        _allProfiles.forEach((otherProfile) {
          _messageProviderList[otherProfile.pid] = MessageProvider(
              senderProfile: profile, receiverProfile: otherProfile)
            ..fetchExistingMessage(
                byPass:
                    profile.activeChatProfileIds.indexOf(otherProfile.pid) ==
                        -1);
        });
      }
    } on Failure catch (failure) {
      throw failure;
    }
  }

  Future<void> _tryFetchingProfile() async {
    if (_databaseService == null ||
        !_databaseService.isUserAvailable ||
        isProfileAvailable) return;
    try {
      startInitialLoader();
      _profile = await _databaseService.getUserProfile();
      await _fetchAllProfile();
      stopExecuting();
    } on Failure catch (failure) {
      print(failure);
    }
  }

  Future<ViewResponse<void>> updateUserProfile(
      {@required String name, @required File avatarFile}) async {
    if (_databaseService == null || !isProfileAvailable)
      return FailureViewResponse(
          Failure.internal("Database service or profile is not available"));
    try {
      startExecuting();
      String avatarUrl;
      if (avatarFile != null) {
        final String profileAvatarPath = "profile-avatar-${profile.pid}";
        avatarUrl =
            await StorageService.uploadImage(profileAvatarPath, avatarFile);
      }
      _profile = await _databaseService.updateUserProfile(
          name: name, avatarUrl: avatarUrl, lastSeen: DateTime.now());
      stopExecuting();
      return ViewResponse("User Profile updated succesfully");
    } on Failure catch (failure) {
      return FailureViewResponse(failure);
    }
  }

  List<Profile> getActiveProfiles() {
    if (profile.activeChatProfileIds.isEmpty || _allProfiles.isEmpty) return [];
    return _allProfiles.where((otherProfile) {
      return profile.activeChatProfileIds.indexOf(otherProfile.pid) != -1;
    }).toList();
  }

  Future<ViewResponse<void>> addActiveChatProfileId(String profileId) async {
    try {
      _profile.addActiveChatUser(profileId);
      startExecuting();
      await _databaseService.addActiveChatProfileId(profileId);
      stopExecuting();
      return ViewResponse("Adding new active profile successful");
    } on Failure catch (failure) {
      _profile.removedRecentAddedActiveChatUserId();
      stopExecuting();
      return FailureViewResponse(failure);
    }
  }
}
