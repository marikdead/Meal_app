import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/gemini_service.dart';
import '../constants/api_constants.dart';
import '../network/dio_client.dart';
import '../storage/local_db.dart';

final dioProvider = Provider<Dio>((ref) {
  final client = DioClient.create(baseUrl: ApiConstants.geminiBaseUrl);
  return client.dio;
});

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService(ref.watch(dioProvider));
});

final localDbProvider = Provider<LocalDb>((ref) {
  throw UnimplementedError('localDbProvider must be overridden in main()');
});

