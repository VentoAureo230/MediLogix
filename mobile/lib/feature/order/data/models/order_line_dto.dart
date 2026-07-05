import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/order_line.dart';
import 'order_reference_ref_dto.dart';

part 'order_line_dto.g.dart';

@JsonSerializable(createToJson: false)
class OrderLineDto {
  const OrderLineDto({required this.quantity, required this.reference});

  final int quantity;
  final OrderReferenceRefDto reference;

  factory OrderLineDto.fromJson(Map<String, dynamic> json) =>
      _$OrderLineDtoFromJson(json);

  OrderLine toDomain() => OrderLine(
        quantity: quantity,
        reference: reference.toDomain(),
      );
}
