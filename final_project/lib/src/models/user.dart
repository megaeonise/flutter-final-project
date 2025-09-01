import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'user.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class User {
  User(
    this.points,
    // this.inventory,
    this.username,
    this.email,
    // this.verified,
    // this.verificationToken,
    this.coin,
    // this.friends,
    // this.tasks,
    // this.createdAt,
    // this.updatedAt,
    this.id,
  );

  int points;
  // List inventory;
  String username;
  String email;
  // bool verified;
  // String verificationToken;
  int coin;
  // List friends;
  // List tasks;
  // String createdAt;
  // String updatedAt;
  String id;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
