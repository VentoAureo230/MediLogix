import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/reference.dart';

part 'reference_dto.g.dart';

@JsonSerializable(createToJson: false)
class ReferenceDto {
  const ReferenceDto({
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

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  factory ReferenceDto.fromJson(Map<String, dynamic> json) =>
      _$ReferenceDtoFromJson(json);

  Reference toDomain() => Reference(
        id: id,
        name: name,
        cip7: cip7,
        cip13: cip13,
        quantity: quantity,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
