import 'package:docdoc/features/my_appointments/presentation/views/widgets/my_appointments_view_body.dart';
import 'package:flutter/material.dart';

class MyAppointmentsView extends StatelessWidget {
  const MyAppointmentsView({super.key});

  static const String routeName = 'MyAppointments';

  @override
  Widget build(BuildContext context) {
    return const MyAppointmentsViewBody();
  }
}
