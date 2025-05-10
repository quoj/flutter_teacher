// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'students.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      dob: json['dob'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      classId: (json['classId'] as num).toInt(),
      attendanceStatus: $enumDecodeNullable(
          _$AttendanceStatusEnumMap, json['attendanceStatus']),
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dob': instance.dob,
      'gender': _$GenderEnumMap[instance.gender]!,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'classId': instance.classId,
      'attendanceStatus': _$AttendanceStatusEnumMap[instance.attendanceStatus],
    };

const _$GenderEnumMap = {
  Gender.Nam: 'Nam',
  Gender.Nu: 'Nu',
  Gender.Khac: 'Khac',
};

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'present',
  AttendanceStatus.absent: 'absent',
};
