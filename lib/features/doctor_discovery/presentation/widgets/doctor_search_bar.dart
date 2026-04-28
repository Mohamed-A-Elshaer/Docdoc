import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/core/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DoctorSearchBar extends StatelessWidget {
  const DoctorSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onSubmitted,
    this.hintText = 'Search',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return CustomSearchField(
      hintText: hintText,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      prefixIcon: SvgPicture.asset(
        Assets.imagesSearchIcon,
        height: 24,
        width: 24,
        color: const Color(0xffC2C2C2),
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
