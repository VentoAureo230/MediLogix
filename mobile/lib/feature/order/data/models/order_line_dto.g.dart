// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_line_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderLineDto _$OrderLineDtoFromJson(Map<String, dynamic> json) => OrderLineDto(
      quantity: (json['quantity'] as num).toInt(),
      reference: OrderReferenceRefDto.fromJson(
          json['reference'] as Map<String, dynamic>),
    );
