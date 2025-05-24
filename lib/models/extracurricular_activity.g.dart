// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extracurricular_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtracurricularActivity _$ExtracurricularActivityFromJson(
        Map<String, dynamic> json) =>
    ExtracurricularActivity(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      date: json['date'] as String,
      location: json['location'] as String?,
      classId: (json['class_id'] as num?)?.toInt(),
      teacherId: (json['teacher_id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      tuition: (json['tuition'] as num?)?.toInt(),
      imageUrl: json['image_url'] as String?,
      maxStudents: (json['max_students'] as num?)?.toInt(),
      totalHours: (json['total_hours'] as num?)?.toInt(),
      totalSessions: (json['total_sessions'] as num?)?.toInt(),
      imagePath: json['image_path'] as String?,
    );

Map<String, dynamic> _$ExtracurricularActivityToJson(
        ExtracurricularActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'date': instance.date,
      'location': instance.location,
      'class_id': instance.classId,
      'teacher_id': instance.teacherId,
      'created_at': instance.createdAt,
      'tuition': instance.tuition,
      'image_url': instance.imageUrl,
      'max_students': instance.maxStudents,
      'total_hours': instance.totalHours,
      'total_sessions': instance.totalSessions,
      'image_path': instance.imagePath,
    };
