part of 'reference_list_bloc.dart';

sealed class ReferenceListEvent extends Equatable {
  const ReferenceListEvent();

  @override
  List<Object?> get props => const [];
}

/// Applies a new search/filter combo and resets the pagination back to page 1.
class ReferenceListFiltersChanged extends ReferenceListEvent {
  const ReferenceListFiltersChanged({this.search, this.lowStockOnly = false});

  final String? search;
  final bool lowStockOnly;

  @override
  List<Object?> get props => [search, lowStockOnly];
}

/// Loads the next page of references (infinite scroll trigger).
class ReferenceListLoadMoreRequested extends ReferenceListEvent {
  const ReferenceListLoadMoreRequested();
}

/// Reloads the first page while keeping the current filters (pull-to-refresh).
class ReferenceListRefreshRequested extends ReferenceListEvent {
  const ReferenceListRefreshRequested();
}

/// Fired after `POST /reference` succeeds — inserts the freshly created row
/// at the top of the current list without a full refetch.
class ReferenceCreated extends ReferenceListEvent {
  const ReferenceCreated(this.reference);

  final Reference reference;

  @override
  List<Object?> get props => [reference];
}

/// Fired after `PATCH /reference/:cip13` succeeds — replaces the matching
/// row in-place.
class ReferenceQuantityUpdated extends ReferenceListEvent {
  const ReferenceQuantityUpdated(this.reference);

  final Reference reference;

  @override
  List<Object?> get props => [reference];
}
