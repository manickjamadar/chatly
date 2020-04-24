import 'package:chatly/helpers/failure.dart';
import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/message_provider.dart';
import 'package:chatly/providers/view_state_provider.dart';
import 'package:chatly/service/database_service.dart';

class AllProfileProvider extends ViewStateProvider {
  DatabaseService _databaseService;
  List<Profile> _allProfiles;
  Map<String, MessageProvider> _messageProviderList = {};
  MessageProvider getMessageProvider(String profileId) =>
      _messageProviderList[profileId];
  //getters
  List<Profile> get allProfiles => _allProfiles;

  //create
  AllProfileProvider(DatabaseService databaseService)
      : _databaseService = databaseService,
        _allProfiles = [] {
    _tryFetchAllProfile();
  }
  Future<void> _tryFetchAllProfile() async {
    if (_allProfiles.isNotEmpty) return;
    if (_databaseService == null || !_databaseService.isUserAvailable) return;
    try {
      startInitialLoader();
      _allProfiles = await _databaseService.getAllProfile();
      if (_allProfiles.isNotEmpty) {
        _allProfiles.forEach((profile) {
          _messageProviderList[profile.pid] =
              MessageProvider(receiverProfile: profile)..fetchExistingMessage();
        });
      }
      stopExecuting();
    } on Failure catch (failure) {
      print(failure);
    }
  }
}
