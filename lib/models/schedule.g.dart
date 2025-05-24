// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      id: (json['id'] as num).toInt(),
      subjectId: json['subjectId'] as String,
      teacherId: (json['teacherId'] as num?)?.toInt(),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'id': instance.id,
      'subjectId': instance.subjectId,
      'teacherId': instance.teacherId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };
