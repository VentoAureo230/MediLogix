import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/order_reference_ref.dart';

part 'order_reference_ref_dto.g.dart';

@JsonSerializable(createToJson: false)
class OrderReferenceRefDto {
  const OrderReferenceRefDto({
    required this.id,
    required this.name,
    required this.cip13,
  });

  final int id;
  final String name;
  final String cip13;

  factory OrderReferenceRefDto.fromJson(Map<String, dynamic> json) =>
      _$OrderReferenceRefDtoFromJson(json);

  OrderReferenceRef toDomain() =>
      OrderReferenceRef(id: id, name: name, cip13: cip13);
}
