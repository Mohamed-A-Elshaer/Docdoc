import 'package:docdoc/core/helper_functions/on_generate_route.dart';
import 'package:docdoc/core/helper_models/environment.dart';
import 'package:docdoc/core/services/custom_bloc_observer.dart';
import 'package:docdoc/core/services/get_it_service.dart';
import 'package:docdoc/core/services/shared_preferences_singelton.dart';
import 'package:docdoc/features/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  Bloc.observer=CustomBlocObserver();
  await Supabase.initialize(
    url: Environment.supabaseUrl,
    anonKey: Environment.supabaseAnonKey,
  );
  setupGetit();
   runApp(const Docdoc());
}

class Docdoc extends StatelessWidget{
  const Docdoc({super.key});

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
onGenerateRoute: onGenerateRoute,
    initialRoute: SplashView.routeName,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
    ),
  );
  }



}