// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  (json['points'] as num).toInt(),
  json['username'] as String,
  json['email'] as String,
  (json['coin'] as num).toInt(),
  json['id'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'points': instance.points,
  'username': instance.username,
  'email': instance.email,
  'coin': instance.coin,
  'id': instance.id,
};
