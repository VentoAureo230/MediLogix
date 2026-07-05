import 'package:json_annotation/json_annotation.dart';

import 'reference_dto.dart';

part 'paginated_reference_response_dto.g.dart';

/// Response shape of `GET /reference`.
@JsonSerializable(createToJson: false)
class PaginatedReferenceResponseDto {
  const PaginatedReferenceResponseDto({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  final List<ReferenceDto> data;
  final int total;
  final int page;
  final int limit;

  factory PaginatedReferenceResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PaginatedReferenceResponseDtoFromJson(json);
}
