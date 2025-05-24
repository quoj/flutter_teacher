import 'package:json_annotation/json_annotation.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  final int id;
  final int classId;
  final String subjectId; // Tên môn học
  final int teacherId; // ID giáo viên
  final String dayOfWeek; // Giữ lại kiểu String
  final DateTime startTime;
  final DateTime endTime;

  Schedule({
    required this.id,
    required this.classId,
    required this.subjectId,
    required this.teacherId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      classId: json['class_id'], // Đúng với tên cột trong DB
      subjectId: json['subject_id'], // Đúng với tên cột trong DB
      teacherId: json['teacher_id'], // Đúng với tên cột trong DB
      dayOfWeek: json['day_of_week'], // Lấy trực tiếp từ DB
      startTime: DateTime.parse(json['start_time']), // Đúng với tên cột trong DB
      endTime: DateTime.parse(json['end_time']), // Đúng với tên cột trong DB
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "class_id": classId, // Đúng với tên cột trong DB
    "subject_id": subjectId, // Đúng với tên cột trong DB
    "teacher_id": teacherId, // Đúng với tên cột trong DB
    "day_of_week": dayOfWeek, // Giữ lại kiểu String
    "start_time": startTime.toIso8601String(), // Đúng với tên cột trong DB
    "end_time": endTime.toIso8601String(), // Đúng với tên cột trong DB
  };
}