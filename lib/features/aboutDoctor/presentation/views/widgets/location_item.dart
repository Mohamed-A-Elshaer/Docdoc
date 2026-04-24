import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/utils/app_text_styles.dart';

class LocationItem extends StatelessWidget{
  const LocationItem({super.key,required this.doctorModel});

  final DoctorModel doctorModel;
  @override
  Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Practice Place',style: TextStyles.semiBold16.copyWith(color: const Color(0xff242424)),),
          const SizedBox(height: 12,),
          Text('${doctorModel.city.name}, ${doctorModel.city.governrate.name}',style: TextStyles.regular14.copyWith(color: const Color(0xff757575)),),
          const SizedBox(height: 24,),
          Text('Location Map',style: TextStyles.semiBold16.copyWith(color: const Color(0xff242424)),),
          const SizedBox(height: 12,),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: double.infinity,
              height: 258,
              child: Image.asset(
                Assets.imagesMap,
                fit: BoxFit.cover,
              ),
            ),
          )

        ],
    ),
  );
  }


}