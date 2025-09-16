/// Custom exceptions for the application.
///
/// This file defines custom exception classes used throughout the app
/// for better error handling and debugging.

/// Exception thrown when there's a cache-related error
class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Cache error occurred'});

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when there's a server-related error
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({this.message = 'Server error occurred', this.statusCode});

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Exception thrown when there's a network-related error
class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'Network error occurred'});

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when data format is invalid
class DataFormatException implements Exception {
  final String message;

  const DataFormatException({this.message = 'Invalid data format'});

  @override
  String toString() => 'DataFormatException: $message';
}

/// Exception thrown when authentication fails
class AuthException implements Exception {
  final String message;

  const AuthException({this.message = 'Authentication failed'});

  @override
  String toString() => 'AuthException: $message';
}
