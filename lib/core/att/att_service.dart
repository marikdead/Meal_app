import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';

/// Сервис для централизованного запроса ATT (App Tracking Transparency) на iOS.
///
/// Вызвается один раз при первом заходе в основную часть приложения.
class AttService {
  AttService._();

  static Future<void> requestIfNeeded(BuildContext context) async {
    // Плагин сам возвращает текущий статус, дополнительно сохранять в SharedPreferences не нужно.
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status != TrackingStatus.notDetermined) {
      // Пользователь уже принял решение – повторный системный диалог не появится.
      return;
    }

    // Можно предварительно показать собственное объяснение (опционально).
    // Здесь оставим минимальное модальное окно, чтобы органично вписать в UX.
    final shouldAsk = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Аналитика приложения'),
          content: const Text(
            'Мы используем данные о ваших действиях в приложении только для анонимной '
            'аналитики и улучшения его работы. Разрешить сбор такой статистики?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Нет'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Разрешить'),
            ),
          ],
        );
      },
    );

    if (shouldAsk != true) {
      return;
    }

    // После собственного диалога – системный запрос ATT.
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
}


