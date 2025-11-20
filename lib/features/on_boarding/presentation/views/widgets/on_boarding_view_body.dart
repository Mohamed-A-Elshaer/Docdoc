import 'package:docdoc/constants.dart';
import 'package:docdoc/core/generated/app_colors.dart';
import 'package:docdoc/core/generated/app_text_styles.dart';
import 'package:docdoc/core/generated/assets.dart';
import 'package:docdoc/core/services/shared_preferences_singelton.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/features/auth/presentation/views/sign_in_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingViewBody extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Scaffold(

     body: SafeArea(
       child: Center(
         child: Column(
           children: [
             const SizedBox(height: 35,),
             SvgPicture.asset(Assets.imagesAppLogo,height: 38,),
             Stack(
               clipBehavior: Clip.none,
               alignment: Alignment.center,
               children: [
                     Transform.translate(
                         offset: Offset(MediaQuery.of(context).size.width * -0.12, 0),
                         child: SvgPicture.asset(Assets.imagesAppEmblem)),

                     Transform.translate(
                         offset: Offset(0, MediaQuery.of(context).size.height * 0.04),
                         child: Image.asset(Assets.imagesDoctor)),
                     Transform.translate(
                         offset: Offset(0,MediaQuery.of(context).size.height * 0.21),
                         child: Image.asset(Assets.imagesLinearEffect)),

                 Positioned(
                   bottom: MediaQuery.of(context).size.height * -0.02,
                   left: 0,
                   right: 0,
                   child:  Text(
                     "Best Doctor Appointment App",
                     style:TextStyles.bold32.copyWith(color: AppColors.primaryColor),
                     textAlign: TextAlign.center,
                   ),
                 ),

               ],

             ),
             const SizedBox(height: 30,),
             Padding(
               padding: const EdgeInsets.all(12.0),
               child: Text("Manage and schedule all of your medical appointments easily\nwith Docdoc to get a new experience.",
                 style: TextStyles.regular10.copyWith(color: Color(0xff757575)),
                 textAlign: TextAlign.center,
                 ),
             ),
             
             CustomButton(text: "Get Started", onPressed: (){
               Prefs.setBool(kIsOnBoardingViewSeen, true);
               Navigator.of(context).pushReplacementNamed(SignInView.routeName);

             })
       
           ],
       
         ),
       
       ),
     ),

   );

  }



}