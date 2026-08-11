import 'package:docdoc/core/utils/app_colors.dart';
import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomTabButton extends StatelessWidget {
  const CustomTabButton({
    super.key,
    required this.containerHeight,
    required this.containerWidth,
    required this.buttonRadius,
    required this.isActive,
    required this.isRatingTab,
    required this.tabTitle,
    this.isDisabled = false,
  });

  final double containerHeight;
  final double containerWidth;
  final double buttonRadius;
  final bool isActive;
  final bool isRatingTab;
  final String tabTitle;

  /// When true, the slot is faded and non-interactive (e.g. already booked).
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final effectiveActive = isActive && !isDisabled;
    final color = isDisabled
        ? const Color(0xffE0E0E0)
        : (effectiveActive ? AppColors.primaryColor : const Color(0xffF2F4F7));
    final textColor = isDisabled
        ? const Color(0xff9E9E9E)
        : (effectiveActive ? Colors.white : const Color(0xffC2C2C2));

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: Container(
        height: containerHeight,
        width: containerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(buttonRadius),
          color: color,
        ),
        child: Center(
          child: isRatingTab
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, size: 19, color: textColor),
                    const SizedBox(width: 2),
                    Text(tabTitle,
                        style: TextStyles.regular14.copyWith(color: textColor)),
                  ],
                )
              : Text(tabTitle,
                  style: TextStyles.regular14.copyWith(color: textColor)),
        ),
      ),
    );
  }
}
