import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:flutter/material.dart';
import '../utils/assets.dart';

class CustomDoctorInfoModel extends StatelessWidget {
  const CustomDoctorInfoModel({
    super.key,
    required this.doctorModel,
    this.isRecommendedView = false,
    this.height,
    this.width,
    this.isAboutDoctorView = false,
    this.appointmentDateLine,
  });

  final DoctorModel doctorModel;
  final bool isRecommendedView;
  final double? height;
  final double? width;
  final bool isAboutDoctorView;
  final String? appointmentDateLine;

  static List<Map<String, dynamic>> getTestDoctors() {
    return [
      {
        'imageName': Assets.imagesRandy,
        'doctorName': 'Dr. Ahmed Mohamed',
        'speciality': 'General',
        'hospitalName': 'Cairo Hospital',
        'rate': '4.8',
        'reviewsCount': '1,520',
      },
      {
        'imageName': Assets.imagesRandy,
        'doctorName': 'Dr. Sarah Ali',
        'speciality': 'Neurologic',
        'hospitalName': 'Alexandria Medical',
        'rate': '4.9',
        'reviewsCount': '8,535',
      },
      {
        'imageName': Assets.imagesRandy,
        'doctorName': 'Dr. Omar Hassan',
        'speciality': 'Pediatric',
        'hospitalName': 'Children Hospital',
        'rate': '4.7',
        'reviewsCount': '2,000',
      },
      {
        'imageName': Assets.imagesRandy,
        'doctorName': 'Dr. Fatima Ibrahim',
        'speciality': 'Radiology',
        'hospitalName': 'National Clinic',
        'rate': '4.6',
        'reviewsCount': '150',
      },
      {
        'imageName': Assets.imagesRandy,
        'doctorName': 'Dr. Mohamed Tarek',
        'speciality': 'General',
        'hospitalName': 'City Hospital',
        'rate': '4.8',
        'reviewsCount': '95',
      },
      {
        'imageName': Assets.imagesRandy,
        'doctorName': 'Dr. Nour Youssef',
        'speciality': 'Neurologic',
        'hospitalName': 'University Hospital',
        'rate': '4.9',
        'reviewsCount': '175',
      },
      {
        'imageName': Assets.imagesRandy,
        'doctorName': 'Dr. Karim Samir',
        'speciality': 'Pediatric',
        'hospitalName': 'Kids Care',
        'rate': '4.7',
        'reviewsCount': '110',
      },
      {
        'imageName': Assets.imagesRandy,
        'doctorName': 'Dr. Layla Mahmoud',
        'speciality': 'Radiology',
        'hospitalName': 'Medical Center',
        'rate': '4.8',
        'reviewsCount': '130',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return isRecommendedView
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: 343,
              height: 126,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xff000000).withOpacity(0.04),
                        blurRadius: 30,
                        offset: const Offset(0, -5),
                        spreadRadius: 0)
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildRow(height: height, width: width),
              ),
            ),
          )
        : buildRow(height: height, width: width);
  }

  Row buildRow({double? height, double? width}) {
    return Row(
      crossAxisAlignment: isAboutDoctorView
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width ?? 110,
          height: height ?? 110,
          child: isAboutDoctorView
              ? Transform.translate(
                  offset: const Offset(0, 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      doctorModel.photo,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const ColoredBox(
                          color: Color(0xFFE0E0E0),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          Assets.imagesDefaultAvatar,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    doctorModel.photo,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const ColoredBox(
                        color: Color(0xFFE0E0E0),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        Assets.imagesDefaultAvatar,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 17.5,
              ),
              Text(
                doctorModel.name,
                style:
                    TextStyles.bold16.copyWith(color: const Color(0xff242424)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                '${doctorModel.specialization.name} | ${doctorModel.degree}',
                style: TextStyles.medium12
                    .copyWith(color: const Color(0xff757575)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xffFFD600), size: 18.45),
                  const SizedBox(width: 2.91),
                  Text(
                    '${doctorModel.ratingModel.rate} (${doctorModel.ratingModel.count} reviews)',
                    style: TextStyles.regular12
                        .copyWith(color: const Color(0xff757575)),
                  ),
                ],
              ),
              if (appointmentDateLine != null) ...[
                const SizedBox(height: 8),
                Text(
                  appointmentDateLine!,
                  style: TextStyles.medium12
                      .copyWith(color: const Color(0xff757575)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
