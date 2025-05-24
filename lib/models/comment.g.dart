// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: (json['id'] as num).toInt(),
      announcementId: (json['announcementId'] as num).toInt(),
      studentId: (json['studentId'] as num).toInt(),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'announcementId': instance.announcementId,
      'studentId': instance.studentId,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
    };
