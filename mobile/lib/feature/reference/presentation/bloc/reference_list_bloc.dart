import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/reference.dart';
import '../../domain/usecases/list_references_usecase.dart';

part 'reference_list_event.dart';
part 'reference_list_state.dart';

class ReferenceListBloc
    extends Bloc<ReferenceListEvent, ReferenceListState> {
  ReferenceListBloc({required ListReferencesUseCase listReferencesUseCase})
      : _listReferences = listReferencesUseCase,
        super(const ReferenceListState()) {
    on<ReferenceListFiltersChanged>(_onFiltersChanged);
    on<ReferenceListLoadMoreRequested>(_onLoadMoreRequested);
    on<ReferenceListRefreshRequested>(_onRefreshRequested);
    on<ReferenceCreated>(_onReferenceCreated);
    on<ReferenceQuantityUpdated>(_onReferenceQuantityUpdated);
  }

  static const int _pageSize = 20;
  static const int _lowStockThreshold = 20;

  final ListReferencesUseCase _listReferences;

  Future<void> _onFiltersChanged(
    ReferenceListFiltersChanged event,
    Emitter<ReferenceListState> emit,
  ) async {
    final search = event.search?.trim();
    emit(state.copyWith(
      status: ReferenceListStatus.loading,
      items: const [],
      page: 0,
      total: 0,
      hasMore: true,
      isLoadingMore: false,
      search: (search == null || search.isEmpty) ? null : search,
      clearSearch: search == null || search.isEmpty,
      lowStockOnly: event.lowStockOnly,
      clearErrorMessage: true,
    ));
    await _fetchPage(emit, page: 1);
  }

  Future<void> _onLoadMoreRequested(
    ReferenceListLoadMoreRequested event,
    Emitter<ReferenceListState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore ||
        state.status == ReferenceListStatus.loading) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    await _fetchPage(emit, page: state.page + 1);
  }

  Future<void> _onRefreshRequested(
    ReferenceListRefreshRequested event,
    Emitter<ReferenceListState> emit,
  ) async {
    await _fetchPage(emit, page: 1, replace: true);
  }

  Future<void> _fetchPage(
    Emitter<ReferenceListState> emit, {
    required int page,
    bool replace = false,
  }) async {
    final result = await _listReferences(ListReferencesParams(
      page: page,
      limit: _pageSize,
      maxQuantity: state.lowStockOnly ? _lowStockThreshold : null,
      search: state.search,
    ));

    switch (result) {
      case DataSuccess(:final data):
        final combined = (replace || page == 1)
            ? data.items
            : [...state.items, ...data.items];
        emit(state.copyWith(
          status: ReferenceListStatus.success,
          items: combined,
          page: data.page,
          total: data.total,
          hasMore: data.hasMore,
          isLoadingMore: false,
          clearErrorMessage: true,
        ));
      case DataFailed(:final failure):
        emit(state.copyWith(
          status: state.items.isEmpty
              ? ReferenceListStatus.failure
              : state.status,
          isLoadingMore: false,
          errorMessage:
              failure.message ?? 'Impossible de charger les médicaments',
        ));
    }
  }

  void _onReferenceCreated(
    ReferenceCreated event,
    Emitter<ReferenceListState> emit,
  ) {
    emit(state.copyWith(
      items: [event.reference, ...state.items],
      total: state.total + 1,
      clearErrorMessage: true,
    ));
  }

  void _onReferenceQuantityUpdated(
    ReferenceQuantityUpdated event,
    Emitter<ReferenceListState> emit,
  ) {
    final updated = state.items
        .map((r) => r.cip13 == event.reference.cip13 ? event.reference : r)
        .toList(growable: false);
    emit(state.copyWith(items: updated, clearErrorMessage: true));
  }
}
