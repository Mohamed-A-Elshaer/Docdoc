import 'dart:developer';

import 'package:docdoc/core/services/local_notifications_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Must be a top-level function for background message handling.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log(
    'Background message: ${message.notification?.title ?? message.data}',
    name: 'FirebaseMessaging',
  );
}

class FirebaseMessagingService {
  FirebaseMessagingService._();

  static final FirebaseMessagingService instance = FirebaseMessagingService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _requestPermission();
    await _fetchToken();
    _configureForegroundCallbacks();
  }

  Future<void> _fetchToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      log('FCM token: $token', name: 'FirebaseMessaging');
    } catch (error, stackTrace) {
      log(
        'FCM token unavailable at startup: $error',
        name: 'FirebaseMessaging',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _requestPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _configureForegroundCallbacks() {
    _firebaseMessaging.onTokenRefresh.listen((token) {
      log('FCM token refreshed: $token', name: 'FirebaseMessaging');
    });

    FirebaseMessaging.onMessage.listen((message) {

      LocalNotificationsService.showBasicNotification(message);

      debugPrint(
        'Foreground message: ${message.notification?.title ?? message.data}',
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint(
        'Notification opened app: ${message.notification?.title ?? message.data}',
      );
    });
  }
}
