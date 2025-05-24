// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'students.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      address: json['address'] as String?,
      dad: json['dad'] as String?,
      mom: json['mom'] as String?,
      phoneDad: json['phoneDad'] as String?,
      phoneMom: json['phoneMom'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      classId: (json['classId'] as num?)?.toInt(),
      attendanceStatus: $enumDecodeNullable(
          _$AttendanceStatusEnumMap, json['attendanceStatus']),
      qrCode: json['qrCode'] as String?,
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dob': instance.dob?.toIso8601String(),
      'gender': _$GenderEnumMap[instance.gender],
      'address': instance.address,
      'dad': instance.dad,
      'mom': instance.mom,
      'phoneDad': instance.phoneDad,
      'phoneMom': instance.phoneMom,
      'phone': instance.phone,
      'email': instance.email,
      'classId': instance.classId,
      'attendanceStatus': _$AttendanceStatusEnumMap[instance.attendanceStatus],
      'qrCode': instance.qrCode,
    };

const _$GenderEnumMap = {
  Gender.Nam: 'Nam',
  Gender.Nu: 'Nu',
  Gender.Khac: 'Khac',
};

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'present',
  AttendanceStatus.absent: 'absent',
  AttendanceStatus.excused: 'excused',
  AttendanceStatus.unmarked: 'unmarked',
};
