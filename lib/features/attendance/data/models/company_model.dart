import 'dart:convert';

import '../../domain/entities/company.dart';

class CompanyModel extends Company {
  const CompanyModel({
    required super.name,
    required super.email,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.radiusKm,
    required super.lateTolerance,
  });

  factory CompanyModel.fromJson(String str) =>
      CompanyModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CompanyModel.fromMap(Map<String, dynamic> json) {
    final company = json["company"];
    return CompanyModel(
      name: company["name"],
      email: company["email"],
      address: company["address"],
      latitude: company["latitude"],
      longitude: company["longitude"],
      radiusKm: company["radius_km"],
      lateTolerance: company["late_tolerance"],
    );
  }

  Map<String, dynamic> toMap() => {
        "company": {
          "name": name,
          "email": email,
          "address": address,
          "latitude": latitude,
          "longitude": longitude,
          "radius_km": radiusKm,
          "late_tolerance": lateTolerance,
        },
      };

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
    return 'CompanyModel(name: $name, email: $email, address: $address, latitude: $latitude, longitude: $longitude, radiusKm: $radiusKm, lateTolerance: $lateTolerance)';
  }
}
