// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
  json['name'] as String,
  json['description'] as String,
  json['rarity'] as String,
  (json['cost'] as num).toInt(),
  json['sprite'] as String,
  json['id'] as String,
);

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'rarity': instance.rarity,
  'cost': instance.cost,
  'sprite': instance.sprite,
  'id': instance.id,
};
