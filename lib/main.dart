import 'package:docdoc/core/helper_functions/on_generate_route.dart';
import 'package:docdoc/features/splash/presentation/views/splash_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){

   runApp(Docdoc());
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