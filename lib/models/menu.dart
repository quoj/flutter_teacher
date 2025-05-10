import 'package:json_annotation/json_annotation.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu {
  final int id;
  final DateTime date;
  final String? breakfast;
  final String? lunch;
  final String? dinner;
  final String? snack;
  final DateTime createdAt;  // Add this field

  Menu({
    required this.id,
    required this.date,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.snack,
    required this.createdAt,  // Add this field to the constructor
  });

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);
}
