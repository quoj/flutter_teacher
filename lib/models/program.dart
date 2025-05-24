import 'package:json_annotation/json_annotation.dart';

part 'program.g.dart'; // Tạo tệp .g.dart tự động từ build_runner

@JsonSerializable()
class Program {
  final int? id;
  final String programName;
  final String? programDescription;
  final int? totalSessions;
  final double? tuition;
  final String? imageBase64;

  Program({
    this.id,
    required this.programName,
    this.programDescription,
    this.totalSessions,
    this.tuition,
    this.imageBase64,
  });

  // Tạo đối tượng từ JSON
  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'],
      programName: json['programName'],
      programDescription: json['programDescription'],
      totalSessions: json['totalSessions'],
      tuition: json['tuition'] != null ? (json['tuition'] as num).toDouble() : null,
      imageBase64: json['imageBase64'],
    );
  }

  // Chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'programName': programName,
      if (programDescription != null) 'programDescription': programDescription,
      if (totalSessions != null) 'totalSessions': totalSessions,
      if (tuition != null) 'tuition': tuition,
      if (imageBase64 != null) 'imageBase64': imageBase64,
    };
  }
}
