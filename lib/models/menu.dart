import 'package:json_annotation/json_annotation.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu {
  final String? dayOfWeek; // Tên ngày trong tuần
  final String? breakfast;
  final String? secondBreakfast;
  final String? lunch;
  final String? dinner;
  final String? secondDinner;
  final DateTime? date; // Ngày thực đơn

  Menu({
    this.dayOfWeek,
    this.breakfast,
    this.secondBreakfast,
    this.lunch,
    this.dinner,
    this.secondDinner,
    this.date,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      dayOfWeek: json['dayOfWeek'], // ✅ sửa chỗ này
      breakfast: json['breakfast'],
      secondBreakfast: json['second_breakfast'],
      lunch: json['lunch'],
      dinner: json['dinner'],
      secondDinner: json['second_dinner'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}