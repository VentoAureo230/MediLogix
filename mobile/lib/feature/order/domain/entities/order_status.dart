/// The four states an order can be in, matching the backend `enum_order_status`.
///
/// Postgres declaration order is `New < Ongoing < Ready < Cancelled`, which
/// the API relies on when sorting — keep the enum order aligned.
enum OrderStatus {
  newOrder('New', 'Nouvelle'),
  ongoing('Ongoing', 'En cours'),
  ready('Ready', 'Prête'),
  cancelled('Cancelled', 'Annulée');

  const OrderStatus(this.apiValue, this.label);

  /// Value sent to / received from the REST API.
  final String apiValue;

  /// Human-readable French label.
  final String label;

  static OrderStatus fromApi(String value) {
    return OrderStatus.values.firstWhere(
      (s) => s.apiValue == value,
      orElse: () =>
          throw ArgumentError('Unknown OrderStatus from API: $value'),
    );
  }

  /// Statuses this one can transition to, per the workflow:
  /// New → Ongoing → Ready, plus Cancel from any live state.
  List<OrderStatus> get nextAllowed {
    switch (this) {
      case OrderStatus.newOrder:
        return const [OrderStatus.ongoing, OrderStatus.cancelled];
      case OrderStatus.ongoing:
        return const [OrderStatus.ready, OrderStatus.cancelled];
      case OrderStatus.ready:
      case OrderStatus.cancelled:
        return const [];
    }
  }
}
