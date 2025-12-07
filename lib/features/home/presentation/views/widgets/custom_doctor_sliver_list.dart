import 'package:flutter/cupertino.dart';

import 'custom_doctor_info_model.dart';

class CustomDoctorSliverList extends StatelessWidget{
  const CustomDoctorSliverList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          // Test data - replace with API data later
          final doctors = CustomDoctorInfoModel.getTestDoctors();
          if (index >= doctors.length) return null;

          return Padding(
            padding: EdgeInsets.only(
              bottom: index < doctors.length - 1 ? 26 : 0,
            ),
            child: CustomDoctorInfoModel(
              imageName: doctors[index]['imageName']!,
              doctorName: doctors[index]['doctorName']!,
              speciality: doctors[index]['speciality']!,
              hospitalName: doctors[index]['hospitalName']!,
              rate: doctors[index]['rate']!,
              reviewsCount: doctors[index]['reviewsCount']!,
            ),
          );
        },
        childCount: CustomDoctorInfoModel.getTestDoctors().length,
      ),
    );
  }

}