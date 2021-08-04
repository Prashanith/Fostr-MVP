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
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'userName': instance.userName,
      'userType': _$UserTypeEnumMap[instance.userType],
      'createdOn': instance.createdOn.toIso8601String(),
      'lastLogin': instance.lastLogin.toIso8601String(),
      'invites': instance.invites,
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
