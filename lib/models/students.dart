import 'package:json_annotation/json_annotation.dart';

part 'students.g.dart';

enum Gender { Nam, Nu, Khac }

enum AttendanceStatus { present, absent, excused, unmarked }

@JsonSerializable()
class Student {
  final int id;
  final String? name;
  final DateTime? dob;
  final Gender? gender;
  final String? address;
  final String? dad;
  final String? mom;
  final String? phoneDad;
  final String? phoneMom;
  final String? phone;
  final String? email;
  final int? classId;
  final AttendanceStatus? attendanceStatus;
  final String? qrCode;

  Student({
    required this.id,
    this.name,
    this.dob,
    this.gender,
    this.address,
    this.dad,
    this.mom,
    this.phoneDad,
    this.phoneMom,
    this.phone,
    this.email,
    this.classId,
    this.attendanceStatus,
    this.qrCode,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      name: json['name'] as String?,
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      gender: _genderFromString(json['gender'] as String?),
      address: json['address'] as String?,
      dad: json['dad'] as String?,
      mom: json['mom'] as String?,
      phoneDad: json['phoneDad'] as String?,
      phoneMom: json['phoneMom'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      classId: json['class_id'] != null
          ? int.tryParse(json['class_id'].toString())
          : null,
      attendanceStatus:
      _attendanceStatusFromString(json['attendance_status'] as String?),
      qrCode: json['qr_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dob': dob?.toIso8601String(),
    'gender': gender?.name,
    'address': address,
    'dad': dad,
    'mom': mom,
    'phone_dad': phoneDad,
    'phone_mom': phoneMom,
    'phone': phone,
    'email': email,
    'class_id': classId,
    'attendance_status': attendanceStatus?.name,
    'qr_code': qrCode,
  };

  static Gender? _genderFromString(String? genderStr) {
    switch (genderStr?.toLowerCase()) {
      case 'nam':
        return Gender.Nam;
      case 'nu':
        return Gender.Nu;
      case 'khac':
        return Gender.Khac;
      default:
        return null;
    }
  }

  static AttendanceStatus? _attendanceStatusFromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'present':
        return AttendanceStatus.present;
      case 'absent':
        return AttendanceStatus.absent;
      case 'excused':
        return AttendanceStatus.excused;
      case 'unmarked':
        return AttendanceStatus.unmarked;
      default:
        return null;
    }
  }
}
