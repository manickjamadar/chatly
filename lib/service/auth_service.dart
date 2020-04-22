import 'package:chatly/helpers/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> currentUser() async {
    try {
      return await _auth.currentUser();
    } catch (error) {
      throw Failure.internal('fetching current user failed');
    }
  }

  AuthCredential getPhoneCredintial(
      {@required String verificationId, @required String smsCode}) {
    return PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
  }

  Future<FirebaseUser> signInWithCredintial(AuthCredential credential) async {
    try {
      final authResult = await _auth.signInWithCredential(credential);
      return authResult.user;
    } catch (error) {
      throw Failure.public("Sign in user failed");
    }
  }

  Future<void> sentOtp(
      {@required
          String phoneNumber,
      @required
          void Function(AuthCredential credential) onVerificationCompleted,
      @required
          void Function(String verificationId, [int resetToken]) onCodeSent,
      @required
          void Function(AuthException) onVerificationFailed,
      @required
          void Function(String verificationId) onCodeTimeout}) async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: Duration(minutes: 1),
          verificationCompleted: onVerificationCompleted,
          verificationFailed: onVerificationFailed,
          codeSent: onCodeSent,
          codeAutoRetrievalTimeout: onCodeTimeout);
    } catch (error) {
      throw Failure.public("Sending otp failed");
    }
  }

  Future<void> signOutUser() async {
    try {
      await _auth.signOut();
    } catch (error) {
      throw Failure.public("Sign out user failed");
    }
  }
}
