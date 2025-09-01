// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  (json['completionTime'] as num).toInt(),
  json['title'] as String,
  json['body'] as String,
  json['urgent'] as bool,
  json['color'] as String,
  json['id'] as String,
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  'completionTime': instance.completionTime,
  'title': instance.title,
  'body': instance.body,
  'urgent': instance.urgent,
  'color': instance.color,
  'id': instance.id,
};
