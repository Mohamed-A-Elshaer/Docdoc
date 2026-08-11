import 'package:docdoc/core/utils/app_colors.dart';
import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomPressableList extends StatelessWidget {
  final String image;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLastItem;
  final bool showSelectionControl;

  const CustomPressableList({
    super.key,
    required this.image,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.isLastItem = false,
    this.showSelectionControl = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          if (showSelectionControl == false) ...[
            const SizedBox(
              height: 8,
            ),
          ],
          Row(
            children: [
              Image.asset(image, height: 40, width: 40),
              const SizedBox(width: 13),
              Text(
                text,
                style: TextStyles.regular14
                    .copyWith(color: const Color(0xff242424)),
              ),
              const Spacer(),
              if (showSelectionControl)
                IconButton(
                  onPressed: onTap,
                  icon: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),
            ],
          ),
          if (!isLastItem) ...[
            showSelectionControl
                ? const SizedBox(height: 6)
                : const SizedBox(height: 15),
          ],
          if (!isLastItem)
            const Divider(
              thickness: 1,
              height: 2,
              color: Color(0xffEDEDED),
            ),
        ],
      ),
    );
  }
}
