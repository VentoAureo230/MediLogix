import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

/// A singleton class that initializes the Dio client and API URL.
class ApiSingleton {
  /// Returns the singleton instance of the class. Cannot be instantiated more than once.
  static final ApiSingleton _singleton = ApiSingleton._internal();

  Dio? client;
  String? apiUrl;

  factory ApiSingleton() {
    return _singleton;
  }

  ApiSingleton._internal() {
    init();
  }

  /// Load env variables and initialize the Dio client
  Future<void> init() async {
    if (client != null) {
      return;
    }
    // Load the environment variables
    await dotenv.load(fileName: kReleaseMode ? ".env.prod" : ".env");

    // Set the API URL based on the platform
    apiUrl = Platform.isIOS
        ? dotenv.env['API_URL_IOS']
        : dotenv.env['API_URL_ANDROID'];

    client = Dio(BaseOptions(baseUrl: apiUrl!));
  }
}