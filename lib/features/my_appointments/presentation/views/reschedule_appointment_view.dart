import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/features/bookAppoint/domain/entities/booking_entity.dart';
import 'package:docdoc/features/bookAppoint/domain/entities/payment_option_entity.dart';
import 'package:docdoc/features/my_appointments/presentation/views/widgets/reschedule_appointment_view_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RescheduleAppointmentArgs {
  const RescheduleAppointmentArgs({
    required this.doctor,
    required this.initialStartTime,
    required this.supabaseAppointmentId,
  });

  final DoctorModel doctor;
  final DateTime initialStartTime;
  final int supabaseAppointmentId;
}

class RescheduleAppointmentView extends StatelessWidget {
  const RescheduleAppointmentView({
    super.key,
    required this.args,
  });

  static const String routeName = 'RescheduleAppointment';

  final RescheduleAppointmentArgs args;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingEntity(
        paymentOptionEntity: PaymentOptionEntity(
          paymentOption: 'Paypal',
          isPaymentOptionChosen: true,
        ),
      ),
      child: RescheduleAppointmentViewBody(args: args),
    );
  }
}
