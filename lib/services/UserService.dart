import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fostr/models/UserModel/User.dart';

class UserService {
  final _userCollection = FirebaseFirestore.instance.collection("users");
  final _userNames = FirebaseFirestore.instance.collection("usernames");

  Future<void> createUser(User user) async {
    try {
      await _userCollection.doc(user.id).set(user.toJson());
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _userCollection.doc(user.id).update(user.toJson());
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _userCollection.doc(id).delete();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<User?> getUserById(String id) async {
    try {
      var rawUser = await _userCollection.doc(id).get();
      if (rawUser.exists) {
        return User.fromJson(rawUser.data()!);
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<User?> getUserByField(String field, String value,
      {int limit = 1}) async {
    try {
      var rawUser = await _userCollection
          .where(field, isEqualTo: value)
          .limit(limit)
          .get();
      var userData = rawUser.docs[0];
      if (userData.exists) {
        return User.fromJson(userData.data());
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> checkUserName(String username) async {
    try {
      var res = await _userNames.doc(username).get();
      return res.exists;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> addUsername(User user) async {
    try {
      await _userNames.doc(user.userName).set({"id": user.id});
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
