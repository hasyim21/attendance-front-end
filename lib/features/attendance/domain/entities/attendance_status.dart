import 'package:equatable/equatable.dart';

class AttendanceStatus extends Equatable {
  final bool checkedin;
  final bool checkedout;

  const AttendanceStatus({
    required this.checkedin,
    required this.checkedout,
  });

  @override
  List<Object> get props => [checkedin, checkedout];

  @override
  String toString() =>
      'AttendanceStatus(checkedin: $checkedin, checkedout: $checkedout)';
}
