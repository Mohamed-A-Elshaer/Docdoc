import 'package:docdoc/core/generated/assets.dart';
import 'package:docdoc/core/widgets/custom_app_bar.dart';
import 'package:docdoc/core/widgets/custom_speciality_icon.dart';
import 'package:docdoc/features/recommended_doctors/presentation/views/recommended_doctors_view.dart';
import 'package:flutter/material.dart';
import '../../../../../core/generated/app_text_styles.dart';

class DoctorSpecialityViewBody extends StatelessWidget {
  const DoctorSpecialityViewBody({super.key});

  static final List<Map<String, dynamic>> specialities = [
    {
      'imageName': Assets.imagesCardiology,
      'speciality': 'Cardiology',
    },
    {
      'imageName': Assets.imagesDermatology,
      'speciality': 'Dermatology',
    },
    {
      'imageName': Assets.imagesBrain,
      'speciality': 'Neurology',
    },
    {
      'imageName': Assets.imagesOrthopedics,
      'speciality': 'Orthopedics',
    },
    {
      'imageName': Assets.imagesBaby,
      'speciality': 'Pediatrics',
    },
    {
      'imageName': Assets.imagesGynecology,
      'speciality': 'Gynecology',
    },
    {
      'imageName': Assets.imagesOphthalmology,
      'speciality': 'Ophthalmology',
    },
    {
      'imageName': Assets.imagesKidneys,
      'speciality': 'Urology',
    },
    {
      'imageName': Assets.imagesPsychiatry,
      'speciality': 'Psychiatry',
    },
    {
      'imageName': Assets.imagesGastrenterology,
      'speciality': 'Gastroenterology',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Doctor Speciality',
          leftPadding: 25,
          onTap: ()=> Navigator.of(context).pop(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 31,vertical:32 ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 36,
            mainAxisSpacing: 32,
            childAspectRatio: 0.75,
          ),
          itemCount: specialities.length, // 10 items total
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RecommendedDoctorsView.routeName,
                  arguments: specialities[index]['speciality'] as String,
                );
              },
              child: CustomSpecialityIcon(
                imageName: specialities[index]['imageName']!,
                speciality: specialities[index]['speciality']!,
                radius: 38,
                imageSize: 38.67,
                textStyle: TextStyles.regular14.copyWith(color: const Color(0xff242424)),
              ),
            );
          },
        ),
      ),
    );
  }
}