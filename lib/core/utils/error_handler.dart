import 'package:dio/dio.dart';

import 'app_error.dart';

final class ErrorHandler {
  static AppError toAppError(Object err) {
    if (err is AppError) return err;
    if (err is DioException) {
      final statusCode = err.response?.statusCode;
      final msg = _dioMessage(err);
      if (statusCode != null) {
        return ApiError(msg, statusCode: statusCode, cause: err);
      }
      return NetworkError(msg, cause: err);
    }
    return NetworkError('Неизвестная ошибка', cause: err);
  }

  static String _dioMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Таймаут сети';
      case DioExceptionType.badCertificate:
        return 'Проблема сертификата';
      case DioExceptionType.connectionError:
        return 'Ошибка соединения';
      case DioExceptionType.cancel:
        return 'Запрос отменён';
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        return 'Ошибка API${code != null ? ' ($code)' : ''}';
      case DioExceptionType.unknown:
        return 'Неизвестная сетевая ошибка';
    }
  }
}

