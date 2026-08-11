import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/features/aboutDoctor/presentation/views/widgets/about_doctor_view_body.dart';
import 'package:flutter/cupertino.dart';

class AboutDoctorView extends StatelessWidget {
  static const routeName = "aboutDoctor";
  const AboutDoctorView({super.key, this.doctorModel});

  final DoctorModel? doctorModel;

  @override
  Widget build(BuildContext context) {
    return AboutDoctorViewBody(doctorModel: doctorModel);
  }
}
