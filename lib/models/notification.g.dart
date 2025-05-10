// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      classId: (json['classId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'dateCreated': instance.dateCreated.toIso8601String(),
      'classId': instance.classId,
    };
