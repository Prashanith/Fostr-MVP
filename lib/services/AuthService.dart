import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/models/UserModel/User.dart' as UserModel;
import 'package:fostr/services/UserService.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserService _userService = UserService();

  String verificationId = "";

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateStream => _auth.authStateChanges();

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<UserModel.User?> signInWithEmailPassword(
      String email, String password, UserType userType) async {
    print("Logging in with EP");
    try {
      var res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      var firebaseUser = res.user!;
      verifyUser(firebaseUser);
      var user = await _userService.getUserById(firebaseUser.uid);
      print("Vmoas");

      if (user != null) {
        print("Vmoas");
        var updatedUser = updateLastLogin(user);
        return updatedUser;
      } else {
        throw "invalid-email";
      }
    } on FirebaseAuthException catch (e) {
      throw e.code;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel.User?> signInWithGoogle(UserType userType) async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final credential = await _auth.signInWithCredential(authCredential);

        if (!credential.additionalUserInfo!.isNewUser) {
          var user = await _userService.getUserById(credential.user!.uid);
          if (user != null) {
            var updatedUser = updateLastLogin(user);
            return updatedUser;
          }
        } else {
          var user = await createUser(credential.user!, userType);
          return user;
        }
      }
    } on FirebaseAuthException catch (e) {
      throw e.code.toString();
    } catch (e) {
      throw e;
    }
  }

  Future<void> verifyPhone(BuildContext context, String number) async {
    await _auth.signOut();
    final PhoneCodeSent smsOTPSent = (String verId, int? forceResendingToken) {
      verificationId = verId;
    };

    try {
      await _auth
          .verifyPhoneNumber(
              phoneNumber: number.trim(),
              codeAutoRetrievalTimeout: (String verId) {
                verificationId = verId;
              },
              codeSent: smsOTPSent,
              timeout: const Duration(seconds: 20),
              verificationCompleted: (AuthCredential phoneAuthCredential) {},
              verificationFailed: (FirebaseAuthException exception) {
                print('${exception.code} + something is wrong');
              })
          .catchError((e) {
        throw e;
      });
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel.User?> verifyOTP(
      BuildContext context, String otp, UserType userType) async {
    try {
      var user = await signInWithPhone(context, otp, userType);
      print(user);
      return user;
    } on FirebaseAuthException catch (e) {
      throw e.code.toString();
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel.User?> signInWithPhone(
      BuildContext context, String smsCode, UserType userType) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      verifyUser(userCredential.user!);
      if (userCredential.additionalUserInfo!.isNewUser) {
        var user = await createUser(userCredential.user!, userType);
        return user;
      } else {
        var user = await _userService.getUserById(userCredential.user!.uid);
        if (user != null) {
          var updatedUser = updateLastLogin(user);
          return updatedUser;
        }
      }
    } on FirebaseAuthException catch (e) {
      throw e.code.toString();
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel.User?> signUpWithEmailPassword(
      String email, String password, UserType userType) async {
    try {
      var res = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      verifyUser(res.user!);
      verifyEmail(res.user!);
      var user = await createUser(res.user!, userType);
      return user;
    } on FirebaseAuthException catch (e) {
      throw e.code.toString();
    } catch (e) {
      throw e;
    }
  }

  void verifyUser(User user) {
    assert(user.uid == _auth.currentUser?.uid);
  }

  void verifyEmail(User user) async {
    try {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {}
  }

  Future<UserModel.User?> createUser(User user, UserType userType) async {
    try {
      var time = DateTime.now();
      var notificationToken = await FirebaseMessaging.instance.getToken();
      var newUser = UserModel.User(
          id: user.uid,
          userName: "",
          invites: 10,
          createdOn: time,
          lastLogin: time,
          userType: userType);
      newUser.name = user.displayName ?? "";
      newUser.notificationToken = notificationToken;
      await _userService.createUser(newUser);
      return newUser;
    } catch (e) {}
  }

  Future<void> updateUser(UserModel.User user) async {
    try {
      await _userService.updateUser(user);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updatePassword(String password) async {
    try {
      await _auth.currentUser!.updatePassword(password);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> addUsername(UserModel.User user) async {
    try {
      await _userService.addUsername(user);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  UserModel.User updateLastLogin(UserModel.User user) {
    try {
      var json = user.toJson();
      json['lastLogin'] = DateTime.now().toString();
      var updatedUser = UserModel.User.fromJson(json);
      _userService.updateUser(updatedUser);
      return updatedUser;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
