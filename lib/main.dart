import 'package:docdoc/core/helper_functions/on_generate_route.dart';
import 'package:docdoc/core/services/custom_bloc_observer.dart';
import 'package:docdoc/core/services/get_it_service.dart';
import 'package:docdoc/core/services/shared_preferences_singelton.dart';
import 'package:docdoc/features/home/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  Bloc.observer=CustomBlocObserver();
  await Supabase.initialize(
    url: 'https://kmzdvodtliieskcpjrzd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImttemR2b2R0bGlpZXNrY3BqcnpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI4NDU4MzcsImV4cCI6MjA3ODQyMTgzN30.XP_gM-xJEYjBDBdv1jbZf08-Cb55kPvvWCRqeg-5V8o',
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
    initialRoute: HomeView.routeName,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
    ),
  );
  }



}