import 'package:docdoc/core/utils/app_colors.dart';
import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppointTypeItem extends StatelessWidget {
  final String image;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLastItem;

  const AppointTypeItem({
    super.key,
    required this.image,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.isLastItem=false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
             Image.asset(image,height: 40,width: 40,),
            const SizedBox(width: 13,),
             Text(text,style: TextStyles.regular14.copyWith(color: const Color(0xff242424)),),
            const Spacer(),
            IconButton(
                onPressed: onTap,
                icon: Icon( isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: AppColors.primaryColor,size: 20,
                )
            ),
          ],
        ),
        if (!isLastItem)
          const SizedBox(height: 6,),

        if (!isLastItem)
          const Divider(
          thickness: 1,
          height: 2,
          color: Color(0xffEDEDED),
        )
      ],
    );
  }
}
