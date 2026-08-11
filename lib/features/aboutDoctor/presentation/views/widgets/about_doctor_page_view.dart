import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/features/aboutDoctor/presentation/views/widgets/about_item.dart';
import 'package:docdoc/features/aboutDoctor/presentation/views/widgets/location_item.dart';
import 'package:docdoc/features/aboutDoctor/presentation/views/widgets/review_item.dart';
import 'package:flutter/cupertino.dart';

class AboutDoctorPageView extends StatelessWidget {
  final DoctorModel doctorModel;
  final PageController pageController;
  final Function(int)? onPageChanged;
  const AboutDoctorPageView({
    super.key,
    required this.pageController,
    required this.onPageChanged,
    required this.doctorModel,
  });

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      onPageChanged: onPageChanged,
      children: [
        AboutItem(
          doctorModel: doctorModel,
        ),
        LocationItem(
          doctorModel: doctorModel,
        ),
        ReviewItem(doctorId: doctorModel.id),
      ],
    );
  }
}
