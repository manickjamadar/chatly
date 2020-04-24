import 'package:chatly/helpers/failure.dart';
import 'package:chatly/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  FirebaseUser _firebaseUser;
  Firestore _firestore = Firestore.instance;
  static const String profileCollectionName = 'profiles';
  //getter
  String get userId => _firebaseUser.uid;
  bool get isUserAvailable => _firebaseUser != null;
  //private methods
  CollectionReference _getProfileCollection() =>
      _firestore.collection(profileCollectionName);
  DocumentReference _getProfileDocument() =>
      _getProfileCollection().document(userId);
  //create
  DatabaseService(FirebaseUser firebaseUser) : _firebaseUser = firebaseUser;
  //read

  //get user profile may be return null profile
  Future<Profile> getUserProfile() async {
    if (!isUserAvailable)
      throw Failure.internal(
          "Firebase user is not available during getting user profile");
    try {
      final DocumentSnapshot snapshot = await _getProfileDocument().get();
      //snapshot can be null;
      if (!snapshot.exists) {
        final Profile profile = Profile(
            pid: userId,
            number: _firebaseUser.phoneNumber,
            lastSeen: DateTime.now());
        await _getProfileDocument().setData(profile.toMap(), merge: true);
        return profile;
      }
      return Profile.fromMap(snapshot.data);
    } catch (error) {
      throw Failure.public("User is not available");
    }
  }

  Future<Profile> updateUserProfile(
      {String name, String avatarUrl, DateTime lastSeen}) async {
    if (!isUserAvailable) {
      throw Failure.internal(
          "Firebase user is not available during update user profile");
    }
    try {
      final Profile profile = await getUserProfile();
      profile.update(
          name: name ?? profile.name,
          avatarUrl: avatarUrl ?? profile.avatarUrl,
          lastSeen: lastSeen ?? profile.lastSeen);
      await _getProfileDocument().setData(profile.toMap(), merge: true);
      return profile;
    } catch (error) {
      throw Failure.public("Creating or Updating user profile failed");
    }
  }

  Future<void> addActiveChatProfileId(String profileId) async {
    if (!isUserAvailable) return;
    try {
      await _getProfileDocument().setData({
        Profile.ACTIVE_CHAT_PROFILE_IDS: FieldValue.arrayUnion([profileId])
      }, merge: true);
    } catch (error) {
      throw Failure.public("Adding active chat profile id failed");
    }
  }

  Future<List<Profile>> getAllProfile({includeCurrentProfile = false}) async {
    try {
      final QuerySnapshot querySnapshot =
          await _getProfileCollection().getDocuments();
      final List<Profile> result = [];
      querySnapshot.documents.forEach((docSnapshot) {
        if (docSnapshot.exists) {
          final profile = Profile.fromMap(docSnapshot.data);
          if (!includeCurrentProfile) {
            if (profile.pid == userId) {
              return;
            }
          }
          result.add(profile);
        }
      });
      return result;
    } catch (error) {
      throw Failure.public("Getting all profiles failed");
    }
  }
}
