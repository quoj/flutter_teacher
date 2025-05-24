import 'package:json_annotation/json_annotation.dart';
import 'students.dart'; // Import lớp Student

part 'class_diaries.g.dart';

@JsonSerializable()
class ClassDiary {
  final int id;
  final int classId;
  final String date;
  final String activities;
  final String mood;
  final String healthStatus;
  final String teacherNote;
  final String? imagePath;
  final String createdAt;
  final List<Student>? students; // Thêm trường này

  ClassDiary({
    required this.id,
    required this.classId,
    required this.date,
    required this.activities,
    required this.mood,
    required this.healthStatus,
    required this.teacherNote,
    this.imagePath,
    required this.createdAt,
    this.students,
  });

  factory ClassDiary.fromJson(Map<String, dynamic> json) => _$ClassDiaryFromJson(json);

  Map<String, dynamic> toJson() => _$ClassDiaryToJson(this);
}