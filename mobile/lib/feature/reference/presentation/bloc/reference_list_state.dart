part of 'reference_list_bloc.dart';

enum ReferenceListStatus { initial, loading, success, failure }

class ReferenceListState extends Equatable {
  const ReferenceListState({
    this.status = ReferenceListStatus.initial,
    this.items = const [],
    this.page = 0,
    this.total = 0,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.search,
    this.lowStockOnly = false,
    this.errorMessage,
  });

  final ReferenceListStatus status;
  final List<Reference> items;
  final int page;
  final int total;
  final bool isLoadingMore;
  final bool hasMore;
  final String? search;
  final bool lowStockOnly;
  final String? errorMessage;

  ReferenceListState copyWith({
    ReferenceListStatus? status,
    List<Reference>? items,
    int? page,
    int? total,
    bool? isLoadingMore,
    bool? hasMore,
    String? search,
    bool clearSearch = false,
    bool? lowStockOnly,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ReferenceListState(
      status: status ?? this.status,
      items: items ?? this.items,
      page: page ?? this.page,
      total: total ?? this.total,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      search: clearSearch ? null : (search ?? this.search),
      lowStockOnly: lowStockOnly ?? this.lowStockOnly,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        page,
        total,
        isLoadingMore,
        hasMore,
        search,
        lowStockOnly,
        errorMessage,
      ];
}
