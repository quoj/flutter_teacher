import 'package:json_annotation/json_annotation.dart';

part 'attendance.g.dart'; // Chạy build_runner để tạo file này

@JsonSerializable()
class Attendance  {
  final int id;
  final int studentId;
  final int classId;

  @JsonKey(name: 'studentName')
  final String studentName;

  final String status;
  final DateTime date;
  final String? note;

  Attendance({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.studentName,
    required this.status,
    required this.date,
    this.note,
  });

  Attendance copyWith({
    String? status,
  }) {
    return Attendance(
      id: id,
      studentId: studentId,
      classId: classId,
      studentName: studentName,
      status: status ?? this.status,
      date: date,
      note: note,
    );
  }

  factory Attendance.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceToJson(this);
}


