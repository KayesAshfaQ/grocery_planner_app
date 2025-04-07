import 'package:equatable/equatable.dart';

/// Base class for all exceptions in the application
class AppException extends Equatable implements Exception {
  final String message;
  final int? code;

  const AppException({required this.message, this.code});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (code: $code)' : ''}';

  @override
  List<Object?> get props => [message, code];
}

/// Represents an exception that occurs due to server-side issues
class ServerException extends AppException {
  const ServerException({required String message, int? code})
      : super(message: message, code: code);
}

/// Represents an exception that occurs due to local cache issues
class CacheException extends AppException {
  const CacheException({required String message, int? code})
      : super(message: message, code: code);
}

/// Represents an exception that occurs due to network connectivity issues
class NetworkException extends AppException {
  const NetworkException({required String message, int? code})
      : super(message: message, code: code);
}

/// Represents an exception that occurs due to validation issues
class ValidationException extends AppException {
  const ValidationException({required String message, int? code})
      : super(message: message, code: code);
}
