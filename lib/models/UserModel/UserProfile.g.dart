// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserProfile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return UserProfile(
    bio: json['bio'] as String?,
    facebook: json['facebook'] as String?,
    google: json['google'] as String?,
    instagram: json['instagram'] as String?,
    linkedIn: json['linkedIn'] as String?,
    phoneNumber: json['phoneNumber'] as String?,
    profileImage: json['profileImage'] as String?,
    twitter: json['twitter'] as String?,
  )..favouriteBooks = (json['favouriteBooks'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList();
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'bio': instance.bio,
      'instagram': instance.instagram,
      'facebook': instance.facebook,
      'linkedIn': instance.linkedIn,
      'google': instance.google,
      'twitter': instance.twitter,
      'profileImage': instance.profileImage,
      'phoneNumber': instance.phoneNumber,
      'favouriteBooks': instance.favouriteBooks,
    };
