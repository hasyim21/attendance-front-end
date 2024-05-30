import 'dart:convert';

import '../../domain/entities/attendance_status.dart';

class AttendanceStatusModel extends AttendanceStatus {
  const AttendanceStatusModel({
    required super.checkedin,
    required super.checkedout,
  });

  factory AttendanceStatusModel.fromJson(String str) =>
      AttendanceStatusModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AttendanceStatusModel.fromMap(Map<String, dynamic> json) =>
      AttendanceStatusModel(
        checkedin: json["checkedin"],
        checkedout: json["checkedout"],
      );

  Map<String, dynamic> toMap() => {
        "checkedin": checkedin,
        "checkedout": checkedout,
      };

  @override
  List<Object> get props => [checkedin, checkedout];

  @override
  String toString() {
    return 'AttendanceStatusModel(checkedin: $checkedin, checkedout: $checkedout)';
  }
}
