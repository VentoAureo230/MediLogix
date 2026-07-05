import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/usecases/add_to_stock_usecase.dart';
import '../../domain/usecases/create_reference_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import '../bloc/reference_list_bloc.dart';
import '../widget/add_stock_bottom_sheet.dart';
import '../widget/create_reference_dialog.dart';
import '../widget/reference_search_bar.dart';
import '../widget/reference_tile.dart';

class ReferenceListPage extends StatelessWidget {
  const ReferenceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<ReferenceListBloc>()
        ..add(const ReferenceListFiltersChanged()),
      child: const _ReferenceListView(),
    );
  }
}

class _ReferenceListView extends StatefulWidget {
  const _ReferenceListView();

  @override
  State<_ReferenceListView> createState() => _ReferenceListViewState();
}

class _ReferenceListViewState extends State<_ReferenceListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_maybeLoadMore);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_maybeLoadMore);
    _scrollController.dispose();
    super.dispose();
  }

  void _maybeLoadMore() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      context
          .read<ReferenceListBloc>()
          .add(const ReferenceListLoadMoreRequested());
    }
  }

  Future<void> _openAddStock(BuildContext context, cip13, reference) async {
    final delta = await AddStockBottomSheet.show(context, reference);
    if (delta == null || !context.mounted) return;
    final bloc = context.read<ReferenceListBloc>();
    final result = await GetIt.instance<AddToStockUseCase>().call(
      AddToStockParams(cip13: cip13, additionalQuantity: delta),
    );
    if (!context.mounted) return;
    switch (result) {
      case DataSuccess(:final data):
        bloc.add(ReferenceQuantityUpdated(data));
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('+$delta ajouté à ${data.name}'),
          ));
      case DataFailed(:final failure):
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(failure.message ?? 'Mise à jour impossible'),
          ));
    }
  }

  Future<void> _openCreate(BuildContext context) async {
    final result = await CreateReferenceDialog.show(context);
    if (result == null || !context.mounted) return;
    final bloc = context.read<ReferenceListBloc>();
    final outcome = await GetIt.instance<CreateReferenceUseCase>().call(
      CreateReferenceParams(
        cip13: result.cip13,
        startingQuantity: result.quantity,
      ),
    );
    if (!context.mounted) return;
    switch (outcome) {
      case DataSuccess(:final data):
        bloc.add(ReferenceCreated(data));
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('${data.name} ajouté')));
      case DataFailed(:final failure):
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(failure.message ?? 'Création impossible'),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReferenceListBloc, ReferenceListState>(
      builder: (context, state) {
        final bloc = context.read<ReferenceListBloc>();
        return Scaffold(
          body: Column(
            children: [
              ReferenceSearchBar(
                initialValue: state.search,
                onChanged: (value) => bloc.add(
                  ReferenceListFiltersChanged(
                    search: value,
                    lowStockOnly: state.lowStockOnly,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    FilterChip(
                      selected: state.lowStockOnly,
                      onSelected: (selected) => bloc.add(
                        ReferenceListFiltersChanged(
                          search: state.search,
                          lowStockOnly: selected,
                        ),
                      ),
                      avatar: const Icon(Icons.warning_amber_rounded, size: 18),
                      label: const Text('Stock faible'),
                    ),
                    const Spacer(),
                    Text(
                      '${state.items.length} / ${state.total}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(child: _buildBody(context, state)),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openCreate(context),
            icon: const Icon(Icons.add),
            label: const Text('Ajouter'),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ReferenceListState state) {
    if (state.status == ReferenceListStatus.loading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == ReferenceListStatus.failure && state.items.isEmpty) {
      return _ErrorRetry(
        message: state.errorMessage ?? 'Erreur inconnue',
        onRetry: () => context
            .read<ReferenceListBloc>()
            .add(const ReferenceListRefreshRequested()),
      );
    }
    if (state.items.isEmpty) {
      return const _EmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        final bloc = context.read<ReferenceListBloc>();
        bloc.add(const ReferenceListRefreshRequested());
        await bloc.stream.firstWhere(
          (s) => s.status != ReferenceListStatus.loading,
        );
      },
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.items.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index >= state.items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
          final reference = state.items[index];
          return ReferenceTile(
            reference: reference,
            onTap: () => _openAddStock(context, reference.cip13, reference),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.medication_outlined, size: 48),
            const SizedBox(height: 12),
            Text(
              'Aucun médicament ne correspond aux filtres',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
