import 'package:docdoc/core/generated/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../../../../core/generated/assets.dart';

class CustomDoctorInfoModel extends StatelessWidget{
  const CustomDoctorInfoModel({super.key,required this.imageName,required this.doctorName,required this.speciality,
    required this.hospitalName,required this.rate,required this.reviewsCount});
final String imageName;
final String doctorName;
final String speciality;
final String hospitalName;
final String rate;
final String reviewsCount;

// Test data - Replace this with API call later
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          height: 110,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imageName, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 17.5,),
              Text(
                doctorName,
                style: TextStyles.bold16.copyWith(color: const Color(0xff242424)),
              ),
              const SizedBox(height: 8),
              Text(
                '$speciality | $hospitalName',
                style: TextStyles.medium12.copyWith(color: const Color(0xff757575)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xffFFD600), size: 18.45),
                  const SizedBox(width: 2.91),
                  Text(
                    '$rate ($reviewsCount reviews)',
                    style: TextStyles.regular12.copyWith(color: const Color(0xff757575)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

}