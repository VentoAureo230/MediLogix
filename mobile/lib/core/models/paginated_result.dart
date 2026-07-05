import 'package:equatable/equatable.dart';

/// Generic paginated response used across features when the backend returns
/// `{ data: [...], total, page, limit }`.
class PaginatedResult<T> extends Equatable {
  const PaginatedResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  final List<T> items;
  final int total;
  final int page;
  final int limit;

  /// True when there is at least one more page to fetch.
  bool get hasMore => page * limit < total;

  @override
  List<Object?> get props => [items, total, page, limit];
}
