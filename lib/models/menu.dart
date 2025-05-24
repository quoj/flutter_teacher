import 'package:json_annotation/json_annotation.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu {
  final int? id;

  /// Giữ nguyên camelCase vì API trả về `dayOfWeek`
  final String? dayOfWeek;

  @JsonKey(name: 'breakfast')
  final String? breakfast;

  @JsonKey(name: 'second_breakfast')
  final String? secondBreakfast;

  @JsonKey(name: 'lunch')
  final String? lunch;

  @JsonKey(name: 'dinner')
  final String? dinner;

  @JsonKey(name: 'second_dinner')
  final String? secondDinner;

  /// API trả ISO-8601: "2025-05-23", json_serializable tự parse DateTime
  final DateTime? date;

  @JsonKey(name: 'createdAt')               // ↔ API camelCase
  final DateTime? createdAt;

  Menu({
    this.id,
    this.dayOfWeek,
    this.breakfast,
    this.secondBreakfast,
    this.lunch,
    this.dinner,
    this.secondDinner,
    this.date,
    this.createdAt,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);
  Map<String, dynamic> toJson() => _$MenuToJson(this);
}
