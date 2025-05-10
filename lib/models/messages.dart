import 'package:json_annotation/json_annotation.dart';

part 'messages.g.dart';

@JsonSerializable()
class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final int studentId;
  final String content;
  final String? imagePath;
  final String status;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.studentId,
    required this.content,
    this.imagePath,
    required this.status,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  // ✅ Bổ sung copyWith để cập nhật trạng thái
  Message copyWith({
    int? id,
    int? senderId,
    int? receiverId,
    int? studentId,
    String? content,
    String? imagePath,
    String? status,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      studentId: studentId ?? this.studentId,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
