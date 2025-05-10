import 'package:json_annotation/json_annotation.dart';

part 'class_diaries.g.dart'; // Tạo ra mã tự động cho các phương thức fromJson, toJson

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

  // Constructor
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
  });

  // Phương thức được tạo tự động từ json_serializable
  factory ClassDiary.fromJson(Map<String, dynamic> json) => _$ClassDiaryFromJson(json);

  // Phương thức chuyển đối tượng ClassDiary thành Map
  Map<String, dynamic> toJson() => _$ClassDiaryToJson(this);
}
