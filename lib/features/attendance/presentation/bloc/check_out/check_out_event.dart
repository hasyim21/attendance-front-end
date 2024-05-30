part of 'check_out_bloc.dart';

class CheckOutEvent extends Equatable {
  final String latitude;
  final String longitude;

  const CheckOutEvent({required this.latitude, required this.longitude});

  @override
  List<Object> get props => [latitude, longitude];
}
