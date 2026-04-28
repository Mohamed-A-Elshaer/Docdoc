import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget{
    CustomSearchField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.fillColor=const Color(0xffF5F5F5),
    TextStyle? hintStyle,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.width,
  }) : hintStyle = hintStyle ?? TextStyles.medium12.copyWith(color: const Color(0xffC2C2C2));
  final String hintText;
  final Widget? prefixIcon;
  final TextStyle hintStyle;
  final Color? fillColor;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final double? width;

  @override
  Widget build(BuildContext context) {
  return SizedBox(
    height: 46,
    width: width ?? 303,
    child: TextField(
    controller: controller,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    textInputAction: textInputAction,
    decoration: InputDecoration(
    hintText: hintText,
    hintStyle:hintStyle,
    filled: true,
    fillColor:fillColor,
    prefixIcon: prefixIcon,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
    border: buildOutlineInputBorder(),
    enabledBorder: buildOutlineInputBorder(),
    focusedBorder: buildOutlineInputBorder(),

    ),
    ),
  );
  }

    static OutlineInputBorder buildOutlineInputBorder() {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(
          color: Colors.transparent
        )
      );
    }
}