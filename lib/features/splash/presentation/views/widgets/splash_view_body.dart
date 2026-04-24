import 'package:docdoc/constants.dart';
import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/core/services/shared_preferences_singelton.dart';
import 'package:docdoc/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../auth/presentation/views/sign_in_view.dart';

class SplashViewBody extends StatefulWidget{
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    executeNavigation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth=MediaQuery.of(context).size.width;
   return Scaffold(
body: Center(
  child: Stack(
    alignment: Alignment.center,
      children: [
        SvgPicture.asset(Assets.imagesAppEmblem,width: screenWidth,fit: BoxFit.fitWidth,),
       SvgPicture.asset(Assets.imagesAppLogo),

      ],

    ),
),

   );
  }

  void executeNavigation() {
    Future.delayed(const Duration(seconds: 3),(){
      bool isOnBoardingViewSeen=Prefs.getBool(kIsOnBoardingViewSeen);
       if(isOnBoardingViewSeen) {
         Navigator.pushReplacementNamed(context, SignInView.routeName);
       }
       else {
         Navigator.pushReplacementNamed(context, OnBoardingView.routeName);
       }
       });
    
  }
}