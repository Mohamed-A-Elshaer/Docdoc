import 'package:docdoc/core/helper_functions/on_generate_route.dart';
import 'package:docdoc/core/helper_models/dot_env_keys.dart';
import 'package:docdoc/core/helper_models/environment.dart';
import 'package:docdoc/core/services/auth_email_change_session_service.dart';
import 'package:docdoc/core/services/custom_bloc_observer.dart';
import 'package:docdoc/core/services/firebase_messaging_service.dart';
import 'package:docdoc/core/services/get_it_service.dart';
import 'package:docdoc/core/services/local_notifications_service.dart';
import 'package:docdoc/core/services/shared_preferences_singelton.dart';
import 'package:docdoc/features/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await DotEnvKeys.load();
  await Prefs.init();
  Bloc.observer = CustomBlocObserver();
  await Supabase.initialize(
    url: Environment.supabaseUrl,
    anonKey: Environment.supabaseAnonKey,
  );
  AuthEmailChangeSessionServiceSessionService.instance
      .listenForEmailChangeConfirmation(
    rootNavigatorKey,
  );
  setupGetit();
  Stripe.publishableKey = DotEnvKeys.stripePublishableKey;
  await Stripe.instance.applySettings();
  FirebaseAnalytics.instance;
  await FirebaseMessagingService.instance.initialize();
  await LocalNotificationsService.init();
  runApp(const Docdoc());
}

class Docdoc extends StatelessWidget {
  const Docdoc({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      onGenerateRoute: onGenerateRoute,
      initialRoute: SplashView.routeName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
