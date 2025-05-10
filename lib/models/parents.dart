import 'package:json_annotation/json_annotation.dart';

part 'parents.g.dart';

@JsonSerializable()
class Parent {
  final int? id;
  final String name;
  final String? phone;
  final String email;
  final String relationship;
  @JsonKey(name: 'student_id')
  final int? studentId;

  Parent({
    this.id,
    required this.name,
    this.phone,
    required this.email,
    required this.relationship,
    this.studentId,
  });

  factory Parent.fromJson(Map<String, dynamic> json) => _$ParentFromJson(json);

  Map<String, dynamic> toJson() => _$ParentToJson(this);
}
