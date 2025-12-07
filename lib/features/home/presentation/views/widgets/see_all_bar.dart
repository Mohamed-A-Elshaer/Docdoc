import 'package:docdoc/core/generated/app_colors.dart';
import 'package:docdoc/core/generated/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeeAllBar extends StatelessWidget{
  final String text;
   const SeeAllBar({super.key,required this.text});
  @override
  Widget build(BuildContext context) {
   return Row(
     children: [
       Text(text,style: TextStyles.semiBold18.copyWith(color: const Color(0xff242424)),),
       const Spacer(),
       InkWell(
           onTap: (){},
           child: Text('See All',style: TextStyles.regular12.copyWith(color: AppColors.primaryColor),))
     ],
   );
  }


}