import 'package:equatable/equatable.dart';

/// Domain model for a pharmacy reference (medication).
class Reference extends Equatable {
  const Reference({
    required this.id,
    required this.name,
    required this.cip7,
    required this.cip13,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final String cip7;
  final String cip13;
  final int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  Reference copyWith({int? quantity, DateTime? updatedAt}) {
    return Reference(
      id: id,
      name: name,
      cip7: cip7,
      cip13: cip13,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, cip7, cip13, quantity, createdAt, updatedAt];
}
