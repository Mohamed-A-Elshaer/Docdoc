import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/features/auth/domain/entities/user_entity.dart';
import 'package:docdoc/features/auth/presentation/views/fill_your_profile_view.dart';
import 'package:docdoc/features/auth/presentation/views/sign_in_view.dart';
import 'package:docdoc/features/auth/presentation/views/sign_up_view.dart';
import 'package:docdoc/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:docdoc/features/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';

import '../../features/aboutDoctor/presentation/views/about_doctor_view.dart';
import '../../features/bookAppoint/presentation/views/book_appoint_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/recommended_doctors/presentation/views/recommended_doctors_view.dart';
import '../../features/speciality/presentation/views/doctor_speciality_view.dart';
import '../../test_post.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings){
  switch(settings.name){
    case SplashView.routeName:
      return MaterialPageRoute(builder: (context)=>const SplashView());

    case OnBoardingView.routeName:
      return MaterialPageRoute(builder: (context)=>const OnBoardingView());

    case SignInView.routeName:
      return MaterialPageRoute(builder: (context)=>const SignInView());

    case SignUpView.routeName:
      return MaterialPageRoute(builder: (context)=>const SignUpView());

    case FillYourProfileView.routeName:
      final user = settings.arguments as UserEntity;
      return MaterialPageRoute(builder: (context)=>FillYourProfileView(userEntity: user,));

    case HomeView.routeName:
      return MaterialPageRoute(builder: (context)=>const HomeView());

    case DoctorSpecialityView.routeName:
      return MaterialPageRoute(builder: (context)=>const DoctorSpecialityView());

    case RecommendedDoctorsView.routeName:
      final speciality = settings.arguments as String?;
      return MaterialPageRoute(
        builder: (context) => RecommendedDoctorsView(initialSpeciality: speciality),
        settings: settings,
      );

    case AboutDoctorView.routeName:
      final doctorModel = settings.arguments as DoctorModel?;
      return MaterialPageRoute(
        builder: (context) => AboutDoctorView(doctorModel: doctorModel),
        settings: settings,
      );


    case BookAppointView.routeName:
      return MaterialPageRoute(builder: (context)=>const BookAppointView());

    case TestPost.routeName:
      return MaterialPageRoute(builder: (context)=>const TestPost());

    default:
      return MaterialPageRoute(builder: (context)=>const Scaffold());

  }


}