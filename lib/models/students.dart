import 'package:json_annotation/json_annotation.dart';

part 'students.g.dart';

enum Gender { Nam, Nu, Khac }

enum AttendanceStatus { present, absent }

@JsonSerializable()
class Student {
  final int id;
  final String name;
  final String dob;
  final Gender gender;
  final String address;
  final String phone;
  final String email;
  final int classId;
  final AttendanceStatus? attendanceStatus; // 👈 Thêm trường mới (nullable nếu không có)

  Student({
    required this.id,
    required this.name,
    required this.dob,
    required this.gender,
    required this.address,
    required this.phone,
    required this.email,
    required this.classId,
    this.attendanceStatus, // 👈 thêm vào constructor
  });

  factory Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);
}
