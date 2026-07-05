import 'package:equatable/equatable.dart';

/// Slim user projection returned inside an order (id, email, role).
class OrderUser extends Equatable {
  const OrderUser({
    required this.id,
    required this.email,
    required this.role,
  });

  final int id;
  final String email;
  final String role;

  @override
  List<Object?> get props => [id, email, role];
}
