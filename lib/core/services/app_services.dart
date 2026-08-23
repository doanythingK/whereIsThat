import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../config/app_config.dart';
import '../data/app_repository.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // A missing platform Firebase configuration should not crash a local build.
  }
}

class AppServices {
  AppServices._({required this.firebaseReady, required this.adsEnabled});

  static AppServices current = AppServices._(
    firebaseReady: false,
    adsEnabled: false,
  );

  final bool firebaseReady;
  final bool adsEnabled;

  static Future<AppServices> initialize(AppConfig config) async {
    var firebaseReady = false;
    if (config.firebaseEnabled) {
      try {
        await Firebase.initializeApp();
        firebaseReady = true;
        FirebaseMessaging.onBackgroundMessage(
          firebaseMessagingBackgroundHandler,
        );
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          unawaited(
            FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
          );
          return true;
        };
      } catch (error, stack) {
        debugPrint('Firebase is disabled: $error');
        debugPrintStack(stackTrace: stack);
      }
    }

    if (config.adsEnabled) {
      try {
        await MobileAds.instance.initialize();
      } catch (error) {
        debugPrint('AdMob is disabled: $error');
      }
    }

    final services = AppServices._(
      firebaseReady: firebaseReady,
      adsEnabled: config.adsEnabled,
    );
    AppServices.current = services;
    return services;
  }

  Future<void> syncDevice(AppRepository repository) async {
    if (!firebaseReady || kIsWeb) return;
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;
      await repository.registerDevice(
        platform: Platform.isIOS ? 'ios' : 'android',
        token: token,
      );
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        unawaited(
          repository.registerDevice(
            platform: Platform.isIOS ? 'ios' : 'android',
            token: newToken,
          ),
        );
      });
    } catch (error, stack) {
      await recordError(error, stack);
    }
  }

  Future<void> track(String name, {Map<String, Object>? parameters}) async {
    if (!firebaseReady) return;
    const allowedEvents = {
      'space_created',
      'item_created',
      'item_searched',
      'floor_plan_opened',
      'shopping_item_added',
      'checklist_completed',
    };
    if (!allowedEvents.contains(name)) return;
    final safeParameters = <String, Object>{};
    parameters?.forEach((key, value) {
      if (value is String || value is num || value is bool) {
        safeParameters[key] = value;
      }
    });
    await FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: safeParameters.isEmpty ? null : safeParameters,
    );
  }

  Future<void> recordError(Object error, StackTrace stack) async {
    if (!firebaseReady) return;
    await FirebaseCrashlytics.instance.recordError(error, stack);
  }
}

class AdPolicyService {
  AdPolicyService({this.enabled = false});

  final bool enabled;
  DateTime? _lastInterstitialAt;

  bool canShowInterstitial() {
    if (!enabled) return false;
    final last = _lastInterstitialAt;
    return last == null ||
        DateTime.now().difference(last) >= const Duration(minutes: 10);
  }

  void markInterstitialShown() {
    _lastInterstitialAt = DateTime.now();
  }
}
