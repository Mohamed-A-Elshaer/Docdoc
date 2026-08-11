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
import '../../features/my_appointments/presentation/views/my_appointments_view.dart';
import '../../features/my_appointments/presentation/views/reschedule_appointment_view.dart';
import '../../features/profile/presentation/views/faq_view.dart';
import '../../features/profile/presentation/views/language_view.dart';
import '../../features/profile/presentation/views/medical_record_view.dart';
import '../../features/profile/presentation/views/payment_view.dart';
import '../../features/profile/presentation/views/notification_view.dart';
import '../../features/profile/presentation/views/personal_information_view.dart';
import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/profile/presentation/views/security_view.dart';
import '../../features/profile/presentation/views/settings_view.dart';
import '../../features/recommended_doctors/presentation/views/recommended_doctors_view.dart';
import '../../features/search/presentation/views/search_view.dart';
import '../../features/speciality/presentation/views/doctor_speciality_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(builder: (context) => const SplashView());

    case OnBoardingView.routeName:
      return MaterialPageRoute(builder: (context) => const OnBoardingView());

    case SignInView.routeName:
      return MaterialPageRoute(builder: (context) => const SignInView());

    case SignUpView.routeName:
      return MaterialPageRoute(builder: (context) => const SignUpView());

    case FillYourProfileView.routeName:
      final user = settings.arguments as UserEntity;
      return MaterialPageRoute(
          builder: (context) => FillYourProfileView(
                userEntity: user,
              ));

    case HomeView.routeName:
      return MaterialPageRoute(builder: (context) => const HomeView());

    case DoctorSpecialityView.routeName:
      return MaterialPageRoute(
          builder: (context) => const DoctorSpecialityView());

    case RecommendedDoctorsView.routeName:
      final speciality = settings.arguments as String?;
      return MaterialPageRoute(
        builder: (context) =>
            RecommendedDoctorsView(initialSpeciality: speciality),
        settings: settings,
      );

    case SearchView.routeName:
      final initialQuery = settings.arguments as String?;
      return MaterialPageRoute(
        builder: (context) => SearchView(initialQuery: initialQuery),
        settings: settings,
      );

    case AboutDoctorView.routeName:
      final doctorModel = settings.arguments as DoctorModel?;
      return MaterialPageRoute(
        builder: (context) => AboutDoctorView(doctorModel: doctorModel),
        settings: settings,
      );

    case BookAppointView.routeName:
      final doctorModel = settings.arguments as DoctorModel;
      return MaterialPageRoute(
        builder: (context) => BookAppointView(
          doctorModel: doctorModel,
        ),
        settings: settings,
      );

    case MyAppointmentsView.routeName:
      return MaterialPageRoute(
        builder: (context) => const MyAppointmentsView(),
        settings: settings,
      );

    case RescheduleAppointmentView.routeName:
      final args = settings.arguments as RescheduleAppointmentArgs;
      return MaterialPageRoute<bool>(
        builder: (context) => RescheduleAppointmentView(args: args),
        settings: settings,
      );

    case ProfileView.routeName:
      return MaterialPageRoute(
        builder: (context) => const ProfileView(),
        settings: settings,
      );

    case SettingsView.routeName:
      return MaterialPageRoute(
        builder: (context) => const SettingsView(),
        settings: settings,
      );

    case NotificationView.routeName:
      return MaterialPageRoute(
        builder: (context) => const NotificationView(),
        settings: settings,
      );

    case FaqView.routeName:
      return MaterialPageRoute(
        builder: (context) => const FaqView(),
        settings: settings,
      );

    case SecurityView.routeName:
      return MaterialPageRoute(
        builder: (context) => const SecurityView(),
        settings: settings,
      );

    case LanguageView.routeName:
      return MaterialPageRoute(
        builder: (context) => const LanguageView(),
        settings: settings,
      );

    case PersonalInformationView.routeName:
      return MaterialPageRoute(
        builder: (context) => const PersonalInformationView(),
        settings: settings,
      );

    case MedicalRecordView.routeName:
      return MaterialPageRoute(
        builder: (context) => const MedicalRecordView(),
        settings: settings,
      );

    case PaymentView.routeName:
      return MaterialPageRoute(
        builder: (context) => const PaymentView(),
        settings: settings,
      );

    default:
      return MaterialPageRoute(builder: (context) => const Scaffold());
  }
}
