import 'dart:convert';

import '../../domain/entities/attendance.dart';

class AttendanceModel extends Attendance {
  const AttendanceModel({
    required super.id,
    required super.userId,
    required super.date,
    required super.timeIn,
    required super.timeOut,
    required super.latlonIn,
    required super.latlonOut,
  });

  factory AttendanceModel.fromJson(String str) =>
      AttendanceModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AttendanceModel.fromMap(Map<String, dynamic> json) {
    final attendance = json["attendance"];
    return AttendanceModel(
      id: attendance["id"],
      userId: attendance["user_id"],
      date: attendance["date"] ?? "-",
      timeIn: attendance["time_in"] ?? "-",
      timeOut: attendance["time_out"] ?? "-",
      latlonIn: attendance["latlon_in"] ?? "-",
      latlonOut: attendance["latlon_out"] ?? "-",
    );
  }

  Map<String, dynamic> toMap() => {
        "attendance": {
          "id": id,
          "user_id": userId,
          "date": date,
          "time_in": timeIn,
          "time_out": timeOut,
          "latlon_in": latlonIn,
          "latlon_out": latlonOut,
        },
      };

  @override
  List<Object> get props {
    return [
      id,
      userId,
      date,
      timeIn,
      timeOut,
      latlonIn,
      latlonOut,
    ];
  }

  @override
  String toString() {
    return 'AttendanceModel(id: $id, userId: $userId, date: $date, timeIn: $timeIn, timeOut: $timeOut, latlonIn: $latlonIn, latlonOut: $latlonOut)';
  }
}
