import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../utils/app_error.dart';

final class GeminiService {
  final Dio _dio;

  GeminiService(this._dio);

  static const _systemPrompt = '''
You are a nutrition planning assistant.
Always return ONLY valid JSON.
Do not include explanations.
''';

  Future<String> generateJsonText({required String userPrompt}) async {
    final path =
        '/v1beta/models/${ApiConstants.geminiModel}:generateContent?key=${ApiConstants.geminiApiKey}';

    final body = {
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': '$_systemPrompt\n\n$userPrompt'},
          ],
        }
      ],
      'generationConfig': {
        'temperature': AppConstants.aiTemperature,
        'responseMimeType': 'application/json',
      },
    };

    final Response<dynamic> res;
    try {
      res = await _dio.post(path, data: body);
    } catch (e) {
      rethrow;
    }

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw const EmptyResponseError('Пустой/некорректный ответ Gemini');
    }

    final candidates = data['candidates'];
    if (candidates is! List || candidates.isEmpty) {
      throw const EmptyResponseError('Gemini не вернул candidates');
    }
    final c0 = candidates.first;
    if (c0 is! Map<String, dynamic>) {
      throw const EmptyResponseError('Некорректный формат candidates[0]');
    }
    final content = c0['content'];
    if (content is! Map<String, dynamic>) {
      throw const EmptyResponseError('Gemini не вернул content');
    }
    final parts = content['parts'];
    if (parts is! List || parts.isEmpty) {
      throw const EmptyResponseError('Gemini не вернул parts');
    }
    final p0 = parts.first;
    if (p0 is! Map<String, dynamic>) {
      throw const EmptyResponseError('Некорректный формат parts[0]');
    }
    final text = p0['text'];
    if (text is! String || text.trim().isEmpty) {
      throw const EmptyResponseError('Gemini не вернул text');
    }
    return text;
  }
}

