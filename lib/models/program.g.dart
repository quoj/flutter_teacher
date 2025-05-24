// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Program _$ProgramFromJson(Map<String, dynamic> json) => Program(
      id: (json['id'] as num?)?.toInt(),
      programName: json['programName'] as String,
      programDescription: json['programDescription'] as String?,
      totalSessions: (json['totalSessions'] as num?)?.toInt(),
      tuition: (json['tuition'] as num?)?.toDouble(),
      imageBase64: json['imageBase64'] as String?,
    );

Map<String, dynamic> _$ProgramToJson(Program instance) => <String, dynamic>{
      'id': instance.id,
      'programName': instance.programName,
      'programDescription': instance.programDescription,
      'totalSessions': instance.totalSessions,
      'tuition': instance.tuition,
      'imageBase64': instance.imageBase64,
    };
