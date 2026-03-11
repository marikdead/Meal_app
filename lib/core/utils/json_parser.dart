import 'dart:convert';

import 'app_error.dart';

final class JsonParser {
  /// Достаёт первый валидный JSON-объект/массив из текста (на случай ```json ...```).
  static Map<String, dynamic> parseJsonObjectFromText(String text) {
    final extracted = _extractFirstJson(text);
    if (extracted == null) {
      throw const JsonFormatError('AI вернул не-JSON ответ');
    }
    final decoded = jsonDecode(extracted);
    if (decoded is Map<String, dynamic>) return decoded;
    throw const JsonFormatError('Ожидался JSON-объект');
  }

  static String? _extractFirstJson(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    // 1) Быстрый путь: весь текст — JSON
    if (_looksLikeJson(trimmed)) {
      try {
        jsonDecode(trimmed);
        return trimmed;
      } catch (_) {}
    }

    // 2) Удаляем code fences
    final withoutFences = trimmed
        .replaceAll(RegExp(r'^```(?:json)?', multiLine: true), '')
        .replaceAll(RegExp(r'```$', multiLine: true), '')
        .trim();
    if (_looksLikeJson(withoutFences)) {
      try {
        jsonDecode(withoutFences);
        return withoutFences;
      } catch (_) {}
    }

    // 3) Сканируем на первый { ... } или [ ... ] и проверяем валидность
    for (final open in const ['{', '[']) {
      final close = open == '{' ? '}' : ']';
      final start = trimmed.indexOf(open);
      if (start < 0) continue;
      int depth = 0;
      for (int i = start; i < trimmed.length; i++) {
        final c = trimmed[i];
        if (c == open) depth++;
        if (c == close) depth--;
        if (depth == 0) {
          final candidate = trimmed.substring(start, i + 1).trim();
          try {
            jsonDecode(candidate);
            return candidate;
          } catch (_) {
            break;
          }
        }
      }
    }
    return null;
  }

  static bool _looksLikeJson(String s) =>
      (s.startsWith('{') && s.endsWith('}')) || (s.startsWith('[') && s.endsWith(']'));
}

