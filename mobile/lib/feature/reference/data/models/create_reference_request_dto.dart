import 'package:json_annotation/json_annotation.dart';

part 'create_reference_request_dto.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class CreateReferenceRequestDto {
  const CreateReferenceRequestDto({required this.cip13, this.quantity});

  final String cip13;
  final int? quantity;

  Map<String, dynamic> toJson() => _$CreateReferenceRequestDtoToJson(this);
}
