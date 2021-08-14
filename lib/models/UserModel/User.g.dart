// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as String,
    name: json['name'] as String,
    userName: json['userName'] as String,
    userType: _$enumDecode(_$UserTypeEnumMap, json['userType']),
    createdOn: DateTime.parse(json['createdOn'] as String),
    lastLogin: DateTime.parse(json['lastLogin'] as String),
    invites: json['invites'] as int,
    userProfile: json['userProfile'] == null
        ? null
        : UserProfile.fromJson(json['userProfile'] as Map<String, dynamic>),
  )
    ..notificationToken = json['notificationToked'] as String?
    ..followers =
        (json['followers'] as List<dynamic>?)?.map((e) => e as String).toList()
    ..followings = (json['followings'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList();
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'userName': instance.userName,
      'notificationToked': instance.notificationToken,
      'userType': _$UserTypeEnumMap[instance.userType],
      'createdOn': instance.createdOn.toIso8601String(),
      'lastLogin': instance.lastLogin.toIso8601String(),
      'invites': instance.invites,
      'userProfile': instance.userProfile?.toJson(),
      'followers': instance.followers,
      'followings': instance.followings,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$UserTypeEnumMap = {
  UserType.USER: 'USER',
  UserType.CLUBOWNER: 'CLUBOWNER',
};
