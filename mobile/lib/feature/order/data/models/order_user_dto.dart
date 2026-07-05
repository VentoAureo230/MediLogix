import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/order_user.dart';

part 'order_user_dto.g.dart';

@JsonSerializable(createToJson: false)
class OrderUserDto {
  const OrderUserDto({
    required this.id,
    required this.email,
    required this.role,
  });

  final int id;
  final String email;
  final String role;

  factory OrderUserDto.fromJson(Map<String, dynamic> json) =>
      _$OrderUserDtoFromJson(json);

  OrderUser toDomain() => OrderUser(id: id, email: email, role: role);
}
