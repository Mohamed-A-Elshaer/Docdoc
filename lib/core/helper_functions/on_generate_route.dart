import 'package:docdoc/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:docdoc/features/splash/presentation/views/splash_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings){
  switch(settings.name){
    case SplashView.routeName:
      return MaterialPageRoute(builder: (context)=>SplashView());

    case onBoardingView.routeName:
      return MaterialPageRoute(builder: (context)=>onBoardingView());

    default:
      return MaterialPageRoute(builder: (context)=>const Scaffold());

  }


}