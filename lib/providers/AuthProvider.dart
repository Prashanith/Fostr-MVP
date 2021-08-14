import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/services/AuthService.dart';
import 'package:fostr/services/LocalStorage.dart';
import 'package:fostr/services/UserService.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final LocalStorage _localStorage = LocalStorage();
  final UserService _userService = UserService();
  User? _user;
  Status _status = Status.Uninitialized;
  UserType? _userType;
  String? _email;
  bool _isLoading = true;

  AuthProvider.init() {
    initAuth();
  }

  User? get user => _user;
  Status get status => _status;
  bool get isLoading => _isLoading;
  bool get firstOpen => _localStorage.firstOpen;
  bool get logedIn => _localStorage.loggedIn;
  UserType? get userType => _userType;
  String? get email => _email;
  Stream<auth.User?> get authStateStream => _authService.authStateStream;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setUserType(UserType userType) {
    _userType = userType;
    notifyListeners();
  }

  Future<void> initAuth() async {
    await _localStorage.readPrefs();
    if (!logedIn) {
      _status = Status.Unauthenticated;
    } else if (_authService.currentUser != null) {
      _user = await _userService.getUserById(_authService.currentUser!.uid);
      _status = Status.Authenticated;
    }
    _setFree();
  }

  Future<void> signInWithPhone(BuildContext context, String number) async {
    try {
      _setBusy();
      await _authService.verifyPhone(context, number);
      _setFree();
    } catch (e) {
      _setFree();
      print("from auth provider");
      print(e);
      throw e;
    }
  }

  Future<User?> verifyOtp(
      BuildContext context, String otp, UserType userType) async {
    try {
      _setBusy();
      _user = await _authService.verifyOTP(context, otp, userType);
      _localStorage.setLoggedIn();
      _setFree();
      return _user;
    } catch (e) {
      _setFree();
      throw e;
    }
  }

  Future<User?> signInWithEmailPassword(
      String email, String password, UserType userType) async {
    try {
      _setBusy();
      _user =
          await _authService.signInWithEmailPassword(email, password, userType);
      _localStorage.setLoggedIn();
      _setFree();
      return _user;
    } catch (e) {
      _setFree();
      print("from auth provider");
      print(e);
      throw e;
    }
  }

  Future<User?> signInWithGoogle(UserType userType) async {
    try {
      _setBusy();
      _user = await _authService.signInWithGoogle(userType);
      _localStorage.setLoggedIn();
      _setFree();
      return _user;
    } catch (e) {
      _setFree();
      print("from auth provider" + e.toString());
      print(e);
      throw e;
    }
  }

  Future<void> signupWithEmailPassword(
      String email, String password, UserType userType) async {
    try {
      _setBusy();
      await _authService.signOut();
      _user =
          await _authService.signUpWithEmailPassword(email, password, userType);
      _localStorage.setLoggedIn();
      _setFree();
    } catch (e) {
      _setFree();
      print("from auth provider");
      print(e);
      throw e;
    }
  }

  Future<void> addUserDetails(User user) async {
    try {
      _setBusy();
      await _authService.updateUser(user);
      await _userService.addUsername(user);
      _user = user;
      _setFree();
    } catch (e) {
      _setFree();
      print(e);
      throw e;
    }
  }

  _setBusy() {
    _isLoading = true;
    notifyListeners();
  }

  _setFree() {
    _isLoading = false;
    notifyListeners();
  }

  signOut() async {
    await _authService.signOut();
    _setFree();
    notifyListeners();
  }

  void refreshUser(User user) {
    _user = user;
    notifyListeners();
  }
}
