import 'package:chatly/helpers/failure.dart';
import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/view_state_provider.dart';
import 'package:chatly/service/database_service.dart';

class AllProfileProvider extends ViewStateProvider {
  DatabaseService _databaseService;
  List<Profile> _activeProfiles;
  List<Profile> _nonActiveProfiles;

  //getters
  List<Profile> get activeProfiles => _activeProfiles;
  List<Profile> get nonActiveProfiles => _nonActiveProfiles;

  //create
  AllProfileProvider(DatabaseService databaseService)
      : _databaseService = databaseService {
    tryFetchAllProfile();
  }

  Future<void> tryFetchAllProfile() async {
    startInitialLoader();
    if (_databaseService == null) return;
    try {
      _nonActiveProfiles = await _databaseService.getAllProfile();
      stopExecuting();
    } on Failure catch (failure) {
      print(failure);
    }
  }
}
