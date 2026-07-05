import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/login_request_dto.dart';
import '../../models/login_response_dto.dart';

part 'authentication_api_service.g.dart';

/// Retrofit-generated client for the authentication endpoints.
///
/// See `mobile/lib/documentation/RETROFIT_GENERATOR.md` for the pattern.
@RestApi()
abstract class AuthenticationApiService {
  factory AuthenticationApiService(Dio dio, {String? baseUrl}) =
      _AuthenticationApiService;

  @POST(ApiConstants.login)
  Future<LoginResponseDto> login(@Body() LoginRequestDto body);
}
