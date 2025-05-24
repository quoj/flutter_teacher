import 'package:json_annotation/json_annotation.dart';

part 'extracurricular_activity.g.dart';

@JsonSerializable()
class ExtracurricularActivity {
  final int? id;
  final String title;
  final String? description;
  final String date;
  final String? location;
  @JsonKey(name: 'class_id')
  final int? classId;
  @JsonKey(name: 'teacher_id')
  final int? teacherId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final int? tuition;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'max_students')
  final int? maxStudents;
  @JsonKey(name: 'total_hours')
  final int? totalHours;
  @JsonKey(name: 'total_sessions')
  final int? totalSessions;
  @JsonKey(name: 'image_path')
  final String? imagePath;

  ExtracurricularActivity({
    this.id,
    required this.title,
    this.description,
    required this.date,
    this.location,
    this.classId,
    this.teacherId,
    this.createdAt,
    this.tuition,
    this.imageUrl,
    this.maxStudents,
    this.totalHours,
    this.totalSessions,
    this.imagePath,
  });

  factory ExtracurricularActivity.fromJson(Map<String, dynamic> json) =>
      _$ExtracurricularActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ExtracurricularActivityToJson(this);
}
