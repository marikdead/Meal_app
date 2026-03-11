import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import 'api_interceptor.dart';

final class DioClient {
  final Dio dio;

  DioClient._(this.dio);

  factory DioClient.create({required String baseUrl}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: AppConstants.requestTimeout,
        receiveTimeout: AppConstants.requestTimeout,
        sendTimeout: AppConstants.requestTimeout,
      ),
    );
    dio.interceptors.add(ApiInterceptor());
    return DioClient._(dio);
  }
}

