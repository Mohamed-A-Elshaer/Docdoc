import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookingFlowSuccessHeader extends StatelessWidget {
  const BookingFlowSuccessHeader({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(
            Assets.imagesBookingConfirmed,
            height: 78,
            width: 78,
          ),
          const SizedBox(height: 21),
          Text(
            title,
            style: TextStyles.medium20.copyWith(color: const Color(0xff242424)),
          ),
        ],
      ),
    );
  }
}
