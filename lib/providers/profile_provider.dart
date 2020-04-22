import 'package:chatly/helpers/failure.dart';
import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/view_state_provider.dart';
import 'package:chatly/service/database_service.dart';

class ProfileProvider extends ViewStateProvider {
  //database service can be null
  DatabaseService _databaseService;
  Profile _profile;
  Profile get profile => _profile;
  bool get isProfileAvailable => profile != null;
  bool get isProfileCompleted =>
      isProfileAvailable && profile.name != null && profile.avatarUrl != null;

  ProfileProvider(DatabaseService databaseService)
      : _databaseService = databaseService {
    if (databaseService == null) return;
    _tryFetchingProfile();
  }

  Future<void> _tryFetchingProfile() async {
    if (_databaseService == null || isProfileAvailable) return;
    try {
      startInitialLoader();
      _profile = await _databaseService.getUserProfile();
      stopExecuting();
    } on Failure catch (failure) {
      print(failure);
    }
  }
}
