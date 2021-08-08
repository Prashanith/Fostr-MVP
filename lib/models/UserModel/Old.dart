import 'package:cloud_firestore/cloud_firestore.dart';

class OldUser {
  final String name;
  final String username;
  String profileImage = 'assets/images/profile.png';
  String google = "";
  String instagram = "";
  String twitter = "";
  String linkedin = "";
  String bio = "";

  OldUser({
    required this.name,
    required this.username,
    required this.profileImage,
  });

  factory OldUser.fromJson(json) {
    return OldUser(
      name: json['name'],
      username: json['username'],
      profileImage: json['profileImage'],
    );
  }

  factory OldUser.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return OldUser.fromJson(data);
  }
}
