import 'package:json_annotation/json_annotation.dart';

part 'teachers.g.dart';

@JsonSerializable()
class Teacher {
  final int id;
  final String name;
  final String? phone;
  final String email;
  final int? subjectId;
  final String? department;

  Teacher({
    required this.id,
    required this.name,
    this.phone,
    required this.email,
    this.subjectId,
    this.department,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) =>
      _$TeacherFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherToJson(this);
}
