// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferenceDto _$ReferenceDtoFromJson(Map<String, dynamic> json) => ReferenceDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  cip7: json['cip7'] as String,
  cip13: json['cip13'] as String,
  quantity: (json['quantity'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);
