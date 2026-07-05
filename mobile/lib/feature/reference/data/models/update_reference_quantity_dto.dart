import 'package:json_annotation/json_annotation.dart';

part 'update_reference_quantity_dto.g.dart';

/// Body of `PATCH /reference/:cip13`.
///
/// Server-side, [quantity] is **added** to the current stock (increment, not
/// replace). Must be > 0 (`class-validator` `@Min(1)`).
@JsonSerializable(createFactory: false)
class UpdateReferenceQuantityDto {
  const UpdateReferenceQuantityDto({required this.quantity});

  final int quantity;

  Map<String, dynamic> toJson() => _$UpdateReferenceQuantityDtoToJson(this);
}
