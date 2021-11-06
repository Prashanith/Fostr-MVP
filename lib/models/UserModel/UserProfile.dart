import 'package:json_annotation/json_annotation.dart';

part 'UserProfile.g.dart';

@JsonSerializable()
class UserProfile {
  String? bio;
  String? instagram;
  String? facebook;
  String? linkedIn;
  String? google;
  String? twitter;
  String? profileImage;
  String? phoneNumber;
  // List<String>? favouriteBooks = ["", "", "", "", ""];
  List<Map<String,dynamic>> ? topRead;

  UserProfile.empty() {
    bio = "";
    instagram = "";
    facebook = "";
    linkedIn = "";
    google = "";
    twitter = "";
    profileImage = "";
    phoneNumber = "";
    topRead = [];
  }

  UserProfile(
      {this.bio,
      this.facebook,
      this.google,
      this.instagram,
      this.linkedIn,
      this.phoneNumber,
      this.profileImage,
      this.twitter});

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  factory UserProfile.fromUser(UserProfile userProfile) {
    var json = userProfile.toJson();
    return UserProfile.fromJson(json);
  }
}
