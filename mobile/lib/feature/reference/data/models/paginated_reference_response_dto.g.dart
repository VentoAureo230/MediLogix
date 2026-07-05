// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_reference_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedReferenceResponseDto _$PaginatedReferenceResponseDtoFromJson(
  Map<String, dynamic> json,
) => PaginatedReferenceResponseDto(
  data: (json['data'] as List<dynamic>)
      .map((e) => ReferenceDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);
