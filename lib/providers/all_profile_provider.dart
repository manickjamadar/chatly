import 'package:chatly/helpers/failure.dart';
import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/view_state_provider.dart';
import 'package:chatly/service/database_service.dart';

class AllProfileProvider extends ViewStateProvider {
  DatabaseService _databaseService;
  List<Profile> _activeProfiles;
  List<Profile> _allProfiles;
  Profile _currentProfile;
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

  List<Profile> _filterActiveProfile(Profile profile) {
    if (profile == null || profile.activeChatProfileIds.isEmpty) return [];
    return allProfiles
        .where((p) => profile.activeChatProfileIds.indexOf(p.pid) != -1)
        .toList();
  }

  Future<void> _tryFetchAllProfile() async {
    startInitialLoader();
    if (_databaseService == null || _currentProfile == null) return;
    try {
      _allProfiles = await _databaseService.getAllProfile();
      _activeProfiles = _filterActiveProfile(_currentProfile);
      stopExecuting();
    } on Failure catch (failure) {
      print(failure);
    }
  }
}
