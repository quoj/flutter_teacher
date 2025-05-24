// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_diaries.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassDiary _$ClassDiaryFromJson(Map<String, dynamic> json) => ClassDiary(
      id: (json['id'] as num).toInt(),
      classId: (json['classId'] as num).toInt(),
      date: json['date'] as String,
      activities: json['activities'] as String,
      mood: json['mood'] as String,
      healthStatus: json['healthStatus'] as String,
      teacherNote: json['teacherNote'] as String,
      imagePath: json['imagePath'] as String?,
      createdAt: json['createdAt'] as String,
      students: (json['students'] as List<dynamic>?)
          ?.map((e) => Student.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ClassDiaryToJson(ClassDiary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'classId': instance.classId,
      'date': instance.date,
      'activities': instance.activities,
      'mood': instance.mood,
      'healthStatus': instance.healthStatus,
      'teacherNote': instance.teacherNote,
      'imagePath': instance.imagePath,
      'createdAt': instance.createdAt,
      'students': instance.students,
    };
