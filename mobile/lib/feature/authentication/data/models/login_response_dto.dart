import 'package:json_annotation/json_annotation.dart';

part 'login_response_dto.g.dart';

/// Shape of the successful `POST /authentication/login` response.
///
/// The backend returns `{ token: '...' }`. On invalid credentials it returns
/// HTTP 400; on unknown email it returns HTTP 201 with `{ message: 'User not
/// found' }` (see `authentication.service.ts`). We treat that as an error at
/// the data source level.
@JsonSerializable(createToJson: false)
class LoginResponseDto {
  const LoginResponseDto({required this.token});

  final String token;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);
}
