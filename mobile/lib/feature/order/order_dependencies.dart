import 'package:get_it/get_it.dart';

import 'data/data_sources/remote/order_api_service.dart';
import 'data/repository/order_repository_impl.dart';
import 'domain/repository/order_repository.dart';
import 'domain/usecases/get_orders_usecase.dart';
import 'domain/usecases/update_order_status_usecase.dart';
import 'presentation/bloc/order_list_bloc.dart';

/// Wires every dependency owned by the Order feature into the service
/// locator. Called from `injection_container.dart`.
void registerOrderFeature(GetIt sl) {
  // Data source
  sl.registerLazySingleton<OrderApiService>(
    () => OrderApiService(sl()),
  );

  // Repository
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(sl<OrderApiService>()),
  );

  // Use cases
  sl.registerLazySingleton(
    () => GetOrdersUseCase(sl<OrderRepository>()),
  );
  sl.registerLazySingleton(
    () => UpdateOrderStatusUseCase(sl<OrderRepository>()),
  );

  // Bloc — factory: a fresh instance every time the OrderListPage mounts.
  sl.registerFactory<OrderListBloc>(
    () => OrderListBloc(
      getOrdersUseCase: sl<GetOrdersUseCase>(),
      updateOrderStatusUseCase: sl<UpdateOrderStatusUseCase>(),
    ),
  );
}
