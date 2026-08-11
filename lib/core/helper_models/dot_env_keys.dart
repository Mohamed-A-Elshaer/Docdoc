import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Runtime-only secrets loaded from `.env.development` / `.env.production`.
/// These values are not compiled into the app via envied.
final class DotEnvKeys {
  DotEnvKeys._();

  static Future<void> load() async {
    await dotenv.load(
      fileName: kDebugMode ? '.env.development' : '.env.production',
    );
  }

  static String get stripeSecretKey {
    final key = dotenv.env['stripe_secretKey'];
    if (key == null || key.isEmpty) {
      throw StateError(
        'stripe_secretKey is missing. Add it to '
        '${kDebugMode ? '.env.development' : '.env.production'}.',
      );
    }
    return key;
  }

  static String get stripePublishableKey {
    final key = dotenv.env['stripe_publishableKey'];
    if (key == null || key.isEmpty) {
      throw StateError(
        'stripe_publishableKey is missing. Add it to '
        '${kDebugMode ? '.env.development' : '.env.production'}.',
      );
    }
    return key;
  }

  static String get paypalClientId {
    final key = dotenv.env['paypal_clientId'];
    if (key == null || key.isEmpty) {
      throw StateError(
        'paypal_clientId is missing. Add it to '
        '${kDebugMode ? '.env.development' : '.env.production'}.',
      );
    }
    return key;
  }

  static String get paypalSecretKey {
    final key = dotenv.env['paypal_secretKey'];
    if (key == null || key.isEmpty) {
      throw StateError(
        'paypal_secretKey is missing. Add it to '
        '${kDebugMode ? '.env.development' : '.env.production'}.',
      );
    }
    return key;
  }
}
