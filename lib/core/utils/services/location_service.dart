import 'dart:developer';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<bool> isLocationMocked() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      return position.isMocked;
    } catch (e) {
      log('Error checking if location is mocked: $e');
      rethrow;
    }
  }

  static Future<Position> getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      return Position(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      log('Error get current position: $e');
      rethrow;
    }
  }

  static Future<void> checkAndEnableGeolocatorService() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    } catch (e) {
      log('Error checking or requesting Geolocator service: $e');
      rethrow;
    }
  }
}

class Position {
  final double? latitude;
  final double? longitude;

  Position({required this.latitude, required this.longitude});
}
