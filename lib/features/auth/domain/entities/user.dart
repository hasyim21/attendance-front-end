import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String position;
  final String department;
  final String faceEmbedding;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.position,
    required this.department,
    required this.faceEmbedding,
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
      faceEmbedding,
    ];
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phone: $phone, role: $role, position: $position, department: $department, faceEmbedding: $faceEmbedding)';
  }
}
