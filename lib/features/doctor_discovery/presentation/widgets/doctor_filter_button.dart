import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/features/doctor_discovery/presentation/widgets/doctor_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DoctorFilterButton extends StatelessWidget {
  const DoctorFilterButton({
    super.key,
    required this.onDone,
    this.title = 'Sort By',
  });

  final DoctorFilterDone onDone;
  final String title;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        DoctorFilterSheet.show(
          context,
          onDone: onDone,
          title: title,
        );
      },
      icon: SvgPicture.asset(
        Assets.imagesSortIcon,
        height: 24,
        width: 24,
      ),
    );
  }
}
