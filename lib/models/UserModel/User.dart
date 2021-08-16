import 'package:fostr/core/constants.dart';
import 'package:json_annotation/json_annotation.dart';

import 'UserProfile.dart';

part 'User.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String id;
  String userName;
  String name = "";
  String? bookClubName = "";
  String? notificationToken;
  UserType userType;
  DateTime createdOn;
  DateTime lastLogin;
  int invites;
  UserProfile? userProfile = UserProfile.empty();
  List<String>? followers = [];
  List<String>? followings = [];

  User(
      {required this.id,
      required this.userName,
      required this.userType,
      required this.createdOn,
      required this.lastLogin,
      this.invites = 10,
      this.userProfile});

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromUser(User user) {
    var json = user.toJson();
    return User.fromJson(json);
  }
}
