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
  AppServices._({
    required this.firebaseReady,
    required this.adsEnabled,
    required this.adPolicy,
  });

  static AppServices current = AppServices._(
    firebaseReady: false,
    adsEnabled: false,
    adPolicy: AdPolicyService(),
  );

  final bool firebaseReady;
  final bool adsEnabled;
  final AdPolicyService adPolicy;
  StreamSubscription<String>? _tokenRefreshSubscription;
  Future<void>? _deviceSyncInFlight;

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
      adPolicy: AdPolicyService(enabled: config.adsEnabled),
    );
    AppServices.current = services;
    return services;
  }

  Future<void> syncDevice(AppRepository repository) {
    if (!firebaseReady || kIsWeb) return Future<void>.value();
    final pending = _deviceSyncInFlight;
    if (pending != null) return pending;
    final operation = _syncDevice(repository);
    _deviceSyncInFlight = operation;
    return operation;
  }

  Future<void> resetDeviceSync() async {
    final subscription = _tokenRefreshSubscription;
    _tokenRefreshSubscription = null;
    _deviceSyncInFlight = null;
    await subscription?.cancel();
  }

  Future<void> _syncDevice(AppRepository repository) async {
    try {
      final userId = repository.signedInUser?.id;
      if (userId == null) return;
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;
      if (repository.signedInUser?.id != userId) return;
      const appVersion = String.fromEnvironment(
        'APP_VERSION',
        defaultValue: '1.0.0',
      );
      final platform = Platform.isIOS ? 'ios' : 'android';
      await _registerDeviceToken(
        repository,
        platform: platform,
        token: token,
        appVersion: appVersion,
      );
      if (repository.signedInUser?.id != userId) return;
      _tokenRefreshSubscription ??= FirebaseMessaging.instance.onTokenRefresh
          .listen((newToken) {
            if (repository.signedInUser?.id != userId) return;
            unawaited(
              _registerDeviceToken(
                repository,
                platform: platform,
                token: newToken,
                appVersion: appVersion,
              ),
            );
          });
    } catch (error, stack) {
      await recordError(error, stack);
    } finally {
      _deviceSyncInFlight = null;
    }
  }

  Future<void> _registerDeviceToken(
    AppRepository repository, {
    required String platform,
    required String token,
    required String appVersion,
  }) async {
    try {
      await repository.registerDevice(
        platform: platform,
        token: token,
        appVersion: appVersion,
      );
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

  Future<void> showInterstitialIfAllowed() async {
    if (!adsEnabled || !adPolicy.canShowInterstitial()) return;
    final completer = Completer<void>();
    await InterstitialAd.load(
      adUnitId: const String.fromEnvironment(
        'ADMOB_INTERSTITIAL_ID',
        defaultValue: 'ca-app-pub-3940256099942544/1033173712',
      ),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete();
            },
          );
          adPolicy.markInterstitialShown();
          ad.show();
        },
        onAdFailedToLoad: (_) {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );
    await completer.future;
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
