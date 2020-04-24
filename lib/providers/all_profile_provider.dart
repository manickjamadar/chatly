import 'package:chatly/helpers/failure.dart';
import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/message_provider.dart';
import 'package:chatly/providers/view_state_provider.dart';
import 'package:chatly/service/database_service.dart';

class AllProfileProvider extends ViewStateProvider {
  DatabaseService _databaseService;
  List<Profile> _activeProfiles;
  List<Profile> _allProfiles;
  Profile _currentProfile;
  Map<String, MessageProvider> _messageProviderList = {};
  MessageProvider getMessageProvider(String profileId) =>
      _messageProviderList[profileId];
  //getters
  List<Profile> get activeProfiles => _activeProfiles;
  List<Profile> get allProfiles => _allProfiles;

  //create
  AllProfileProvider(DatabaseService databaseService, Profile profile)
      : _databaseService = databaseService,
        _activeProfiles = [],
        _allProfiles = [],
        _currentProfile = profile {
    _tryFetchAllProfile();
  }

  List<Profile> _filterActiveProfilesFromAllProfile(Profile currentProfile) {
    if (currentProfile == null || currentProfile.activeChatProfileIds.isEmpty)
      return [];
    return allProfiles
        .where((p) => currentProfile.activeChatProfileIds.indexOf(p.pid) != -1)
        .toList();
  }

  Future<void> _tryFetchAllProfile() async {
    if (_databaseService == null ||
        !_databaseService.isUserAvailable ||
        _currentProfile == null) return;
    try {
      startInitialLoader();
      _allProfiles = await _databaseService.getAllProfile();
      if (_allProfiles.isNotEmpty) {
        _allProfiles.forEach((profile) {
          _messageProviderList[profile.pid] = MessageProvider(
              senderProfile: _currentProfile, receiverProfile: profile)
            ..stopExecuting();
        });
        _activeProfiles = _filterActiveProfilesFromAllProfile(_currentProfile);
        if (_activeProfiles.isNotEmpty) {
          _activeProfiles.forEach((activeProfile) {
            getMessageProvider(activeProfile.pid).fetchExistingMessage();
          });
        }
      }
      stopExecuting();
    } on Failure catch (failure) {
      print(failure);
    }
  }

  @override
  void dispose() {
    _messageProviderList.forEach((id, mp) {
      mp.dispose();
    });
    super.dispose();
  }
}
