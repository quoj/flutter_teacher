// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'students.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
      dad: json['dad'] as String?,
      mom: json['mom'] as String?,
      phoneDad: json['phone_dad'] as String?,
      phoneMom: json['phone_mom'] as String?,
      classId: (json['class_id'] as num?)?.toInt(),
      attendents: (json['attendents'] as List<dynamic>?)
          ?.map((e) => Attendance.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gender': instance.gender,
      'address': instance.address,
      'email': instance.email,
      'dob': instance.dob?.toIso8601String(),
      'dad': instance.dad,
      'mom': instance.mom,
      'phone_dad': instance.phoneDad,
      'phone_mom': instance.phoneMom,
      'class_id': instance.classId,
      'attendents': instance.attendents?.map((e) => e.toJson()).toList(),
    };
