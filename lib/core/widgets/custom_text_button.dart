import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomTextButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: AppColors.primaryColor),
            ),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyles.regular12.copyWith(color: AppColors.primaryColor),
          ),
        ));
  }
}
