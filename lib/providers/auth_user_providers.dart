import 'package:chatly/helpers/failure.dart';
import 'package:chatly/helpers/view_response.dart';
import 'package:chatly/providers/view_state_provider.dart';
import 'package:chatly/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthUserProvider extends ViewStateProvider {
  AuthService _authService;
  FirebaseUser _authUser;
  String _verificationId;
  //getters
  AuthService get service => _authService;
  bool get isAuthenticated => _authUser != null;
  FirebaseUser get authUser => _authUser;
  //create
  AuthUserProvider(AuthService authService) : this._authService = authService {
    if (authService == null) return;
    _tryAutoFetchUser();
  }

  //private methods
  Future<void> _tryAutoFetchUser() async {
    if (authUser != null) return;
    try {
      startInitialLoader();
      _authUser = await _authService.currentUser();
      stopExecuting();
    } on Failure catch (failure) {
      print(failure);
    }
  }

  Future<void> _signInUser(AuthCredential credential) async {
    try {
      startExecuting();
      final FirebaseUser user =
          await _authService.signInWithCredintial(credential);
      _authUser = user;
      stopExecuting();
    } on Failure catch (failure) {
      throw failure;
    }
  }

  void _reset() {
    _authUser = null;
    _verificationId = null;
  }

  //public methods
  Future<ViewResponse<void>> sentOtp(String phoneNumber,
      {@required void Function() onAutoVerificationStart,
      @required void Function(FailureViewResponse) onVerificationFailed,
      @required void Function() onCodeTimeout}) async {
    try {
      startExecuting();
      await _authService.sentOtp(
          phoneNumber: phoneNumber,
          onVerificationCompleted: (AuthCredential credential) async {
            onAutoVerificationStart();
            try {
              await _signInUser(credential);
            } on Failure catch (failure) {
              onVerificationFailed(FailureViewResponse(failure));
            }
          },
          onCodeSent: (id, [token]) {
            _verificationId = id;
          },
          onVerificationFailed: (AuthException e) {
            onVerificationFailed(
                FailureViewResponse(Failure.internal(e.message)));
          },
          onCodeTimeout: (id) {
            _verificationId = id;
            onCodeTimeout();
          });
      stopExecuting();
      return ViewResponse("Otp succesfully sent");
    } on Failure catch (failure) {
      return FailureViewResponse(failure);
    }
  }

  Future<ViewResponse> verifyOtp(String otp) async {
    try {
      if (_verificationId == null)
        return FailureViewResponse(
            Failure.internal("verificaiton id is null during verify otp"));
      await _signInUser(_authService.getPhoneCredintial(
          verificationId: _verificationId, smsCode: otp));
      return ViewResponse("Otp successfully verified");
    } on Failure catch (failure) {
      return FailureViewResponse(failure);
    }
  }

  Future<ViewResponse> signOutUser() async {
    try {
      startExecuting();
      await _authService.signOutUser();
      _reset();
      stopExecuting();
      return ViewResponse("Sign out user successful");
    } on Failure catch (failure) {
      return FailureViewResponse(failure);
    }
  }
}
