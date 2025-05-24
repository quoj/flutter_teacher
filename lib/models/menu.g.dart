// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu(
      id: (json['id'] as num?)?.toInt(),
      dayOfWeek: json['dayOfWeek'] as String?,
      breakfast: json['breakfast'] as String?,
      secondBreakfast: json['second_breakfast'] as String?,
      lunch: json['lunch'] as String?,
      dinner: json['dinner'] as String?,
      secondDinner: json['second_dinner'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      'id': instance.id,
      'dayOfWeek': instance.dayOfWeek,
      'breakfast': instance.breakfast,
      'second_breakfast': instance.secondBreakfast,
      'lunch': instance.lunch,
      'dinner': instance.dinner,
      'second_dinner': instance.secondDinner,
      'date': instance.date?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
