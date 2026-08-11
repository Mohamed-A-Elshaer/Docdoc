import 'package:docdoc/features/recommended_doctors/presentation/views/widgets/recommended_doctors_view_body.dart';
import 'package:flutter/cupertino.dart';

class RecommendedDoctorsView extends StatelessWidget {
  static const routeName = "RecommendedDoctors";
  const RecommendedDoctorsView({super.key, this.initialSpeciality});

  final String? initialSpeciality;

  @override
  Widget build(BuildContext context) {
    return RecommendedDoctorsViewBody(initialSpeciality: initialSpeciality);
  }
}
