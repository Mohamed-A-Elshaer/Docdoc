import 'package:docdoc/core/generated/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomSpecialityIcon extends StatelessWidget{
  const CustomSpecialityIcon({super.key,required this.imageName,required this.speciality});
final String imageName;
final String speciality;

  @override
  Widget build(BuildContext context) {
   return Column(
     children: [
       CircleAvatar(
         radius: 30,
         backgroundColor: const Color(0xffF4F8FF),
         child:Image.asset(imageName,height: 27,width: 27,) ,
       ),
       const SizedBox(height: 12,),
       Text(speciality,style: TextStyles.regular12.copyWith(color: const Color(0xff242424)),)
     ],
   );
  }

}