import 'package:json_annotation/json_annotation.dart';

part 'update_order_status_dto.g.dart';

@JsonSerializable(createFactory: false)
class UpdateOrderStatusDto {
  const UpdateOrderStatusDto({required this.status});

  final String status;

  Map<String, dynamic> toJson() => _$UpdateOrderStatusDtoToJson(this);
}
