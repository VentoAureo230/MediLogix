import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import 'order_line_dto.dart';
import 'order_user_dto.dart';

part 'order_dto.g.dart';

/// Wire representation of an order.
///
/// The `PATCH /order/:id` endpoint returns a slimmer payload without `user`
/// and `references` — those fields are marked as nullable and defaulted so a
/// single DTO covers both list and update responses.
@JsonSerializable(createToJson: false)
class OrderDto {
  const OrderDto({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.references,
  });

  final int id;
  final String status;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  final OrderUserDto? user;
  final List<OrderLineDto>? references;

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);

  /// Merges [user] and [lines] coming from a previous full fetch when the
  /// current DTO (typically from `PATCH`) doesn't include them.
  Order toDomain({OrderUserDto? fallbackUser, List<OrderLineDto>? fallbackLines}) {
    final u = user ?? fallbackUser;
    final l = references ?? fallbackLines;
    if (u == null || l == null) {
      throw StateError(
        'OrderDto is missing user/references and no fallback was provided.',
      );
    }
    return Order(
      id: id,
      status: OrderStatus.fromApi(status),
      createdAt: createdAt,
      updatedAt: updatedAt,
      user: u.toDomain(),
      lines: l.map((line) => line.toDomain()).toList(growable: false),
    );
  }
}
