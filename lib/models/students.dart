import 'package:json_annotation/json_annotation.dart';
import 'attendance.dart';      // ✅ đã có model Attendance
// Nếu bạn muốn hiển thị phụ huynh (User) thì import thêm user.dart ở đây

part 'students.g.dart';

/// Enum giới tính – gắn @JsonValue để map đúng chuỗi từ API (`nam`, `nu`, `khac`)
enum Gender {
  @JsonValue('nam')
  Nam,
  @JsonValue('nu')
  Nu,
  @JsonValue('khac')
  Khac,
}

/// Enum trạng thái điểm danh (nếu cần dùng tới)
enum AttendanceStatus { present, absent, excused, unmarked }

@JsonSerializable(explicitToJson: true)
class Student {
  final int id;
  final String? name;
  final String? gender;          // ❗ Hoặc dùng `Gender? gender` nếu API trả enum
  final String? address;
  final String? email;

  final DateTime? dob;           // ISO-8601 sẽ tự parse
  final String? dad;
  final String? mom;

  @JsonKey(name: 'phone_dad')
  final String? phoneDad;

  @JsonKey(name: 'phone_mom')
  final String? phoneMom;

  @JsonKey(name: 'class_id')
  final int? classId;

  /// Danh sách điểm danh liên kết
  @JsonKey(name: 'attendents')
  final List<Attendance>? attendents;

  Student({
    required this.id,
    this.name,
    this.gender,
    this.address,
    this.email,
    this.dob,
    this.dad,
    this.mom,
    this.phoneDad,
    this.phoneMom,
    this.classId,
    this.attendents,
  });

  /// ---- json_serializable ----
  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);
}
