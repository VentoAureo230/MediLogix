# Retrofit Generator

## What is Retrofit?

[Retrofit](https://pub.dev/packages/retrofit) is a type-safe HTTP client generator for Dart, built on top of [Dio](https://pub.dev/packages/dio). Instead of writing boilerplate code to make HTTP requests, parse responses, and handle errors, you describe your API as an abstract Dart class with annotations, and Retrofit generates the implementation for you.

### Why use it?

- **Less boilerplate**: no manual `dio.get(...)` calls, no manual JSON parsing.
- **Type safety**: requests and responses are strongly typed with your models.
- **Readable**: each endpoint becomes a one-line method declaration.
- **Centralized**: all the routes for a feature live in a single file.

## How to write an `xxx_api_service.dart` file

Each feature exposes its remote endpoints through an abstract class annotated with `@RestApi`. The generator produces a `xxx_api_service.g.dart` file that contains the concrete implementation.

### Minimal example

```dart
import 'package:dio/dio.dart';
import 'package:noctuacare/feature/owl/data/models/owl.dart';
import 'package:retrofit/retrofit.dart';

part 'owl_api_service.g.dart';

@RestApi()
abstract class OwlApiService {
  factory OwlApiService(Dio dio, {String? baseUrl}) = _OwlApiService;

  @GET("/api/v1/owl/random")
  Future<HttpResponse<OwlModel>> getRandomOwl();
}
```

### Anatomy of the file

1. **Imports** — `dio`, `retrofit`, and your model classes.
2. **`part` directive** — points to the file the generator will create. The name must match your file: `part 'xxx_api_service.g.dart';`.
3. **`@RestApi()` annotation** — marks the class as a Retrofit API.
4. **Abstract class** — naming convention is `XxxApiService`.
5. **Factory constructor** — `factory XxxApiService(Dio dio, {String? baseUrl}) = _XxxApiService;` wires the generated implementation.
6. **Endpoints** — one method per route, annotated with the HTTP verb.

### Common annotations

```dart
@GET("/api/v1/users/{id}")
Future<HttpResponse<UserModel>> getUser(@Path("id") String id);

@POST("/api/v1/users")
Future<HttpResponse<UserModel>> createUser(@Body() CreateUserDto dto);

@PUT("/api/v1/users/{id}")
Future<HttpResponse<UserModel>> updateUser(
  @Path("id") String id,
  @Body() UpdateUserDto dto,
);

@DELETE("/api/v1/users/{id}")
Future<HttpResponse<void>> deleteUser(@Path("id") String id);

@GET("/api/v1/items")
Future<HttpResponse<List<ItemModel>>> listItems(
  @Query("page") int page,
  @Query("limit") int limit,
);
```

- `@Path` — substitutes a URL path segment.
- `@Query` — adds a query string parameter.
- `@Body` — sends the object as JSON in the request body.
- `@Header` — adds a custom header.

Returning `HttpResponse<T>` gives you access to the raw response (status code, headers) along with the parsed model. If you don't need that, you can return `Future<T>` directly.

### Models

Models passed to `@Body` or returned from a method should be JSON-serializable (typically using `json_serializable` with `fromJson` / `toJson`). Retrofit will call `toJson()` on bodies and `fromJson()` on responses automatically.

## Generating the implementation

Whenever you create or modify an `xxx_api_service.dart` file, regenerate the `.g.dart` companion with:

```bash
dart pub run build_runner build --delete-conflicting-outputs
```

Run this from the `mobile/` directory. The `--delete-conflicting-outputs` flag clears any stale generated files so the build doesn't fail on conflicts.

After it completes, the `xxx_api_service.g.dart` file is (re)created next to your service and your endpoints are ready to call.
