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

  factory User.fromJson(Map<String,dynamic>json)=> _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}
