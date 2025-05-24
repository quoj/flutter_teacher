// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attendance _$AttendanceFromJson(Map<String, dynamic> json) => Attendance(
      id: (json['id'] as num).toInt(),
      date: Attendance._fromJsonDate(json['date'] as String),
      status: Attendance._statusFromJson(json['status'] as String),
      time: json['time'] as String,
      studentId: (json['studentId'] as num).toInt(),
    );

Map<String, dynamic> _$AttendanceToJson(Attendance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': Attendance._toJsonDate(instance.date),
      'status': Attendance._statusToJson(instance.status),
      'time': instance.time,
      'studentId': instance.studentId,
    };
