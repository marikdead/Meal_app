import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'core/providers/core_providers.dart';
import 'core/storage/local_db.dart';
import 'shared/router/app_router.dart';
import 'firebase_options.dart';

final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;

final AppsFlyerOptions _appsFlyerOptions = AppsFlyerOptions(
  afDevKey: 'GAgckFyN4yETigBtP4qtRG',
  appId: '6749377146',
  showDebug: true,
  // Дадим AppsFlyer время дождаться ответа ATT на iOS.
  timeToWaitForATTUserAuthorization: 60,
);

final AppsflyerSdk appsflyerSdk = AppsflyerSdk(_appsFlyerOptions);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // AppMetrica
  const appMetricaConfig = AppMetricaConfig(
    'a77cab8e-58b0-44dc-8791-4fcc75e540c9',
    logs: true,
  );
  AppMetrica.activate(appMetricaConfig);

  // AppsFlyer
  await appsflyerSdk.initSdk(
    registerConversionDataCallback: true,
    registerOnAppOpenAttributionCallback: true,
    registerOnDeepLinkingCallback: true,
  );

  // AdMob (Google Mobile Ads)
  await MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: ['898970D5D8AA33DDE7EF0779E26D0598'], // твой ID из лога
    ),
  );
  await MobileAds.instance.initialize();

  final db = await LocalDb.create();
  runApp(
    ProviderScope(
      overrides: [
        localDbProvider.overrideWithValue(db),
      ],
      child: const AiMealPlannerApp(),
    ),
  );
}

class AiMealPlannerApp extends StatelessWidget {
  const AiMealPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ru', 'RU'),
      supportedLocales: const [Locale('ru', 'RU')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Планировщик питания',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      routes: AppRouter.routes,
    );
  }
}
