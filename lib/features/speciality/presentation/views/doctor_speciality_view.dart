import 'package:flutter/cupertino.dart';

import 'widgets/doctor_speciality_view_body.dart';

class DoctorSpecialityView extends StatelessWidget {
  static const routeName = "speciality";

  const DoctorSpecialityView({super.key});

  @override
  Widget build(BuildContext context) {
    return DoctorSpecialityViewBody();
  }
}
