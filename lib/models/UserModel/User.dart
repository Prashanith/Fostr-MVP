import 'package:fostr/core/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String userName;
  final UserType userType;
  final DateTime createdOn;
  final DateTime lastLogin;
  final int invites;

  User({
    required this.id,
    required this.name,
    required this.userName,
    required this.userType,
    required this.createdOn,
    required this.lastLogin,
    required this.invites,
  });

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromUser(User user) {
    var json = user.toJson();
    return User.fromJson(json);
  }
}
