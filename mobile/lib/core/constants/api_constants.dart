/// Backend REST endpoints.
///
/// Base URL is resolved at runtime from `.env` (see [DioClient]).
/// Only path suffixes live here.
class ApiConstants {
  const ApiConstants._();

  // Authentication
  static const String login = '/authentication/login';

  // Orders
  static const String orders = '/order';
  static String orderById(int id) => '/order/$id';

  // References (medications)
  static const String references = '/reference';
  static String referenceByCip13(String cip13) => '/reference/$cip13';
}
