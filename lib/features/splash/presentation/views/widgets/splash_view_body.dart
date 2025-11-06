import 'package:docdoc/core/generated/assets.dart';
import 'package:docdoc/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        SvgPicture.asset(Assets.appEmblem,width: screenWidth,fit: BoxFit.fitWidth,),
       SvgPicture.asset(Assets.appLogo),

      ],

    ),
),

   );
  }

  void executeNavigation() {
    Future.delayed(Duration(seconds: 3),(){
      Navigator.pushReplacementNamed(context, onBoardingView.routeName);
    });
    
  }
}