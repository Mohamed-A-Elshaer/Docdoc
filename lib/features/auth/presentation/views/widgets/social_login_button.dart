import 'package:docdoc/core/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialLoginButton extends StatelessWidget{
  const SocialLoginButton({super.key, required this.imageName, required this.height, required this.onTap});

  final String imageName;
  final double height;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
   return InkWell(
     onTap: onTap,
     child: CircleAvatar(
       radius: 26,
       backgroundColor: const Color(0xffF5F5F5),
       child: SvgPicture.asset(imageName,height: height,),

     ),
   );
  }


}