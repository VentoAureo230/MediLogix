import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/order_list_bloc.dart';
import '../widget/order_card.dart';
import '../widget/order_status_filter_bar.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<OrderListBloc>()
        ..add(const OrderListRequested()),
      child: const _OrderListView(),
    );
  }
}

class _OrderListView extends StatelessWidget {
  const _OrderListView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderListBloc, OrderListState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      },
      builder: (context, state) {
        return Column(
          children: [
            OrderStatusFilterBar(
              selected: state.filter,
              onSelected: (status) => context
                  .read<OrderListBloc>()
                  .add(OrderListRequested(statusFilter: status)),
            ),
            Expanded(child: _buildBody(context, state)),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, OrderListState state) {
    if (state.status == OrderListStatus.loading && state.orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == OrderListStatus.failure && state.orders.isEmpty) {
      return _ErrorRetry(
        message: state.errorMessage ?? 'Erreur inconnue',
        onRetry: () => context
            .read<OrderListBloc>()
            .add(OrderListRequested(statusFilter: state.filter)),
      );
    }
    if (state.orders.isEmpty) {
      return const _EmptyState();
    }
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<OrderListBloc>()
            .add(const OrderListRefreshRequested());
        await context
            .read<OrderListBloc>()
            .stream
            .firstWhere((s) => s.status != OrderListStatus.loading);
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 4, bottom: 24),
        itemCount: state.orders.length,
        itemBuilder: (context, index) {
          final order = state.orders[index];
          return OrderCard(
            order: order,
            isUpdating: state.updatingIds.contains(order.id),
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
            const Icon(Icons.inbox_outlined, size: 48),
            const SizedBox(height: 12),
            Text(
              'Aucune commande à afficher',
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
