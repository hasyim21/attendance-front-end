import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String position;
  final String department;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.position,
    required this.department,
  });

  @override
  List<Object> get props {
    return [
      id,
      name,
      email,
      phone,
      role,
      position,
      department,
    ];
  }
}
