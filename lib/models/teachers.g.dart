// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teachers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Teacher _$TeacherFromJson(Map<String, dynamic> json) => Teacher(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String,
      subjectId: (json['subjectId'] as num?)?.toInt(),
      department: json['department'] as String?,
    );

Map<String, dynamic> _$TeacherToJson(Teacher instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'subjectId': instance.subjectId,
      'department': instance.department,
    };
