import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tryon/core/api/api_service.dart';

 

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio dio;
  late ApiService apiService; // <-- Add this

  factory ApiClient() => _instance;

  ApiClient._internal() {
    final baseUrl = 'https://tryon-h5qg.onrender.com'; // Your base URL

    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: false,
      compact: true,
      maxWidth: 120,
    ));

    // --- Initialize the ApiService ---
    apiService = ApiService(dio, baseUrl: baseUrl);
  }
}