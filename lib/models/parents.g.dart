// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parents.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Parent _$ParentFromJson(Map<String, dynamic> json) => Parent(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String,
      relationship: json['relationship'] as String,
      studentId: (json['student_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ParentToJson(Parent instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'relationship': instance.relationship,
      'student_id': instance.studentId,
    };
