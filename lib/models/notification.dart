import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart'; // Thêm phần này

@JsonSerializable()
class Notification {
  final int? id;
  final String title;
  final String content;
  final DateTime dateCreated;
  final int? classId;

  Notification({
    this.id,
    required this.title,
    required this.content,
    required this.dateCreated,
    this.classId,
  });

  // Hàm tạo Notification từ JSON
  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

  // Chuyển đối tượng Notification thành JSON
  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  @override
  String toString() {
    return 'Notification{id: $id, title: $title, content: $content, dateCreated: $dateCreated, classId: $classId}';
  }
}
