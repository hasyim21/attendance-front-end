import 'package:equatable/equatable.dart';

class Company extends Equatable {
  final String name;
  final String email;
  final String address;
  final String latitude;
  final String longitude;
  final String radiusKm;
  final String timeIn;
  final String timeOut;

  const Company({
    required this.name,
    required this.email,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
    required this.timeIn,
    required this.timeOut,
  });

  @override
  List<Object> get props {
    return [
      name,
      email,
      address,
      latitude,
      longitude,
      radiusKm,
      timeIn,
      timeOut,
    ];
  }
}
