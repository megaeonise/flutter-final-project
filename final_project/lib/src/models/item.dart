import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  Item(
    this.name,
    this.description,
    this.rarity,
    this.cost,
    this.sprite,
    this.id,
  );

  String name;
  String description;
  String rarity;
  int cost;
  String sprite;
  String id;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
