import 'package:dio/dio.dart';
import 'package:grocery_planner_app/core/error/exceptions.dart';

/// API client for making HTTP requests to remote services using Dio
class ApiClient {
  final Dio dio;
  final String baseUrl;

  /// Creates a new ApiClient
  ApiClient({
    required this.dio,
    required this.baseUrl,
  }) {
    dio.options.baseUrl = baseUrl;
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  /// Performs a GET request to the specified endpoint
  Future<dynamic> get(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(
          message: 'Failed to connect to server: ${e.toString()}');
    }
  }

  /// Performs a POST request to the specified endpoint
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await dio.post(
        endpoint,
        data: body,
      );

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(
          message: 'Failed to connect to server: ${e.toString()}');
    }
  }

  /// Performs a PUT request to the specified endpoint
  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await dio.put(
        endpoint,
        data: body,
      );

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(
          message: 'Failed to connect to server: ${e.toString()}');
    }
  }

  /// Performs a DELETE request to the specified endpoint
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await dio.delete(endpoint);
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(
          message: 'Failed to connect to server: ${e.toString()}');
    }
  }

  /// Process Dio response and extract data or throw appropriate exceptions
  dynamic _processResponse(Response response) {
    final statusCode = response.statusCode;

    if (statusCode! >= 200 && statusCode < 300) {
      // Success status codes
      return response.data;
    } else if (statusCode == 400) {
      throw ServerException(
          message: 'Bad request: ${response.data}', code: statusCode);
    } else if (statusCode == 401) {
      throw ServerException(
          message: 'Unauthorized: ${response.data}', code: statusCode);
    } else if (statusCode == 403) {
      throw ServerException(
          message: 'Forbidden: ${response.data}', code: statusCode);
    } else if (statusCode == 404) {
      throw ServerException(
          message: 'Not found: ${response.data}', code: statusCode);
    } else if (statusCode >= 500) {
      throw ServerException(
          message: 'Server error: ${response.data}', code: statusCode);
    } else {
      throw ServerException(
          message: 'HTTP status code: $statusCode', code: statusCode);
    }
  }

  /// Handle Dio-specific errors
  ServerException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerException(message: 'Connection timeout');
      case DioExceptionType.sendTimeout:
        return const ServerException(message: 'Send timeout');
      case DioExceptionType.receiveTimeout:
        return const ServerException(message: 'Receive timeout');
      case DioExceptionType.badCertificate:
        return const ServerException(message: 'Bad certificate');
      case DioExceptionType.badResponse:
        return ServerException(
            message: 'Bad response: ${error.response?.statusCode}');
      case DioExceptionType.cancel:
        return const ServerException(message: 'Request canceled');
      case DioExceptionType.connectionError:
        return const ServerException(message: 'Connection error');
      case DioExceptionType.unknown:
        return ServerException(message: 'Unknown error: ${error.message}');
    }
  }
}
