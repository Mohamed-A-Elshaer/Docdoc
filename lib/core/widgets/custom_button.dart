import 'package:docdoc/core/generated/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget{
  const CustomButton({super.key,required this.text,required this.onPressed});
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 12),
      child: SizedBox(
        width: 327,
        height: 52,
        child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor:AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                )
            ),
            onPressed: onPressed,
            child: Text(text,
              style: const TextStyle(color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16),)),

      ),
    );
  }


}