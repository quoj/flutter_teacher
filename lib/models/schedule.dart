import 'package:json_annotation/json_annotation.dart';
part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  final int id;

  @JsonKey(name: 'subjectId')
  final String subjectId;

  @JsonKey(name: 'teacherId')
  final int? teacherId;

  @JsonKey(name: 'startTime')
  final String startTime;

  @JsonKey(name: 'endTime')
  final String endTime;

  Schedule({
    required this.id,
    required this.subjectId,
    this.teacherId,
    required this.startTime,
    required this.endTime,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}
