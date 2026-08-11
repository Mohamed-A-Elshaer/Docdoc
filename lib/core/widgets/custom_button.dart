import 'package:docdoc/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width = 327,
    this.height = 52,
    this.fontSize = 16,
    this.isOutlined = false,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    this.val = 16,
  });
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double width;
  final double height;
  final double fontSize;
  final bool isOutlined;
  final EdgeInsetsGeometry padding;
  final double val;

  @override
  Widget build(BuildContext context) {
    final bg = isOutlined ? Colors.white : AppColors.primaryColor;
    final fg = isOutlined ? AppColors.primaryColor : Colors.white;
    return Padding(
      padding: padding,
      child: SizedBox(
        width: width,
        height: height,
        child: TextButton(
            style: TextButton.styleFrom(
                foregroundColor: fg,
                backgroundColor: bg,
                side: isOutlined
                    ? const BorderSide(color: AppColors.primaryColor)
                    : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(val))),
            onPressed: isLoading ? null : onPressed,
            child: isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation<Color>(fg),
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      color: fg,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize,
                    ),
                  )),
      ),
    );
  }
}
