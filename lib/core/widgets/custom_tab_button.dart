import 'package:docdoc/core/generated/app_colors.dart';
import 'package:docdoc/core/generated/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomTabButton extends StatelessWidget{
  const CustomTabButton({
    super.key,
    required this.containerHeight,
    required this.containerWidth,
    required this.buttonRadius,
    required this.isActive,
    required this.isRatingTab,
    required this.tabTitle,
  });
final double containerHeight;
final double containerWidth;
final double buttonRadius;
final bool isActive;
final bool isRatingTab;
final String tabTitle;

  @override
  Widget build(BuildContext context) {
return Container(
  height:containerHeight,
  width:containerWidth,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(buttonRadius),
    color: isActive? AppColors.primaryColor:const Color(0xffF2F4F7),
  ),
  child: Center(
    child: isRatingTab? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.star,size: 19,color: isActive? Colors.white:const Color(0xffC2C2C2)),
        const SizedBox(width: 2,),
        Text(tabTitle,style: TextStyles.regular14.copyWith(color: isActive? Colors.white:const Color(0xffC2C2C2)),),
      ],
    )
        : Text(tabTitle,style: TextStyles.regular14.copyWith(color: isActive? Colors.white:const Color(0xffC2C2C2)),),

  ),
);
  }


}