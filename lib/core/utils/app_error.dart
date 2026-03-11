sealed class AppError implements Exception {
  final String message;
  final Object? cause;

  const AppError(this.message, {this.cause});

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkError extends AppError {
  const NetworkError(super.message, {super.cause});
}

final class ApiError extends AppError {
  final int? statusCode;
  const ApiError(super.message, {this.statusCode, super.cause});
}

final class JsonFormatError extends AppError {
  const JsonFormatError(super.message, {super.cause});
}

final class EmptyResponseError extends AppError {
  const EmptyResponseError(super.message, {super.cause});
}

