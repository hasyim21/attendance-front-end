import 'package:equatable/equatable.dart';

class Attendance extends Equatable {
  final int id;
  final int userId;
  final String date;
  final String timeIn;
  final String timeOut;
  final String latlonIn;
  final String latlonOut;

  const Attendance({
    required this.id,
    required this.userId,
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.latlonIn,
    required this.latlonOut,
  });

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
}