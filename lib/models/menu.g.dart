// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu(
      dayOfWeek: json['dayOfWeek'] as String?,
      breakfast: json['breakfast'] as String?,
      secondBreakfast: json['secondBreakfast'] as String?,
      lunch: json['lunch'] as String?,
      dinner: json['dinner'] as String?,
      secondDinner: json['secondDinner'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      'dayOfWeek': instance.dayOfWeek,
      'breakfast': instance.breakfast,
      'secondBreakfast': instance.secondBreakfast,
      'lunch': instance.lunch,
      'dinner': instance.dinner,
      'secondDinner': instance.secondDinner,
      'date': instance.date?.toIso8601String(),
    };
