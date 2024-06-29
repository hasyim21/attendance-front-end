import 'package:equatable/equatable.dart';

class Company extends Equatable {
  final String name;
  final String email;
  final String address;
  final String latitude;
  final String longitude;
  final String radiusKm;
  final int lateTolerance;

  const Company({
    required this.name,
    required this.email,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
    required this.lateTolerance,
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
      lateTolerance,
    ];
  }

  @override
  String toString() {
    return 'Company(name: $name, email: $email, address: $address, latitude: $latitude, longitude: $longitude, radiusKm: $radiusKm, lateTolerance: $lateTolerance)';
  }
}
