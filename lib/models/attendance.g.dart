// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attendance _$AttendanceFromJson(Map<String, dynamic> json) => Attendance(
      id: (json['id'] as num).toInt(),
      studentId: (json['studentId'] as num).toInt(),
      classId: (json['classId'] as num).toInt(),
      studentName: json['studentName'] as String,
      status: json['status'] as String,
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$AttendanceToJson(Attendance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'classId': instance.classId,
      'studentName': instance.studentName,
      'status': instance.status,
      'date': instance.date.toIso8601String(),
      'note': instance.note,
    };
