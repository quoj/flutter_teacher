import 'package:json_annotation/json_annotation.dart';

part 'attendance.g.dart';

@JsonSerializable()
class Attendance {
  final int id;

  @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
  final DateTime date;

  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  final String status;

  final String time;

  final int studentId;


  Attendance({
    required this.id,
    required this.date,
    required this.status,
    required this.time,
    required this.studentId
  });

  factory Attendance.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceToJson(this);

  // Chuyển chuỗi ngày về DateTime
  static DateTime _fromJsonDate(String date) => DateTime.parse(date);

  // Chuyển DateTime sang String yyyy-MM-dd
  static String _toJsonDate(DateTime date) =>
      date.toIso8601String().split('T').first;

  // Chuyển status API sang chữ thường
  static String _statusFromJson(String status) => status.toLowerCase();

  // Chuyển status sang chữ hoa khi gửi đi (nếu cần)
  static String _statusToJson(String status) => status.toUpperCase();
}
