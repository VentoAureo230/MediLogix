// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDto _$OrderDtoFromJson(Map<String, dynamic> json) => OrderDto(
      id: (json['id'] as num).toInt(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: json['user'] == null
          ? null
          : OrderUserDto.fromJson(json['user'] as Map<String, dynamic>),
      references: (json['references'] as List<dynamic>?)
          ?.map((e) => OrderLineDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
