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

  Future<void> updateUserField(Map<String, dynamic> json) async {
    try {
      await _userCollection.doc(json['id']).update(json);
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

  Future<List<Map<String, dynamic>>> searchUser(String query) async {
    try {
      var rawRes = await _userCollection
          .where("userName", isGreaterThanOrEqualTo: query)
          .where("userName", isLessThan: query + 'z')
          .get();
      var res = rawRes.docs.map(
        (e) {
          print(e);
          return e.data();
        },
      ).toList();
      return res;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<User> followUser(User currentUser, User userToFollow) async {
    try {
      User user = currentUser;
      var newFollowings = currentUser.followings ?? [];
      if (!newFollowings.contains(userToFollow.id)) {
        newFollowings.add(userToFollow.id);
        var json = currentUser.toJson();
        json['followings'] = newFollowings;
        user = User.fromJson(json);
        print(json);
        await updateUserField(json);
        print("object");
      }

      var newjson = userToFollow.toJson();
      var followers = newjson['followers'] ?? [];
      if (!followers.contains(currentUser.id)) {
        followers.add(currentUser.id);
        newjson['followers'] = followers;
        await updateUserField(newjson);
      }
      return user;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<User> unfollowUser(User currentUser, User userToUnfollow) async {
    try {
      User user = currentUser;
      var followings = currentUser.followings ?? [];
      if (followings.remove(userToUnfollow.id)) {
        var json = currentUser.toJson();
        json['followings'] = followings;
        user = User.fromJson(json);
        print(json);
        await updateUserField(json);
        print("object");
      }
      var followers = userToUnfollow.followers ?? [];
      if (followers.remove(currentUser.id)) {
        var json = userToUnfollow.toJson();
        json['followers'] = followers;
        await updateUserField(json);
      }

      return user;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
