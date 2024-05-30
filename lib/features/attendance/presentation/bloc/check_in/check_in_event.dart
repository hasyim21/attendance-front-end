part of 'check_in_bloc.dart';

class CheckInEvent extends Equatable {
  final String latitude;
  final String longitude;

  const CheckInEvent({required this.latitude, required this.longitude});

  @override
  List<Object> get props => [latitude, longitude];
}
