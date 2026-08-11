import 'package:docdoc/core/helper_models/appointment_model.dart';
import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/core/widgets/custom_doctor_info_model.dart';
import 'package:flutter/material.dart';

import 'booking_info_item.dart';

class BookingDetailsSection extends StatelessWidget {
  const BookingDetailsSection({
    super.key,
    required this.appointmentModel,
    this.extraSpaceBeforeBookingInformation = 0,
    this.extraSpaceBeforeDoctorInformation = 0,
  });

  final AppointmentModel appointmentModel;
  final double extraSpaceBeforeBookingInformation;
  final double extraSpaceBeforeDoctorInformation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        if (extraSpaceBeforeBookingInformation > 0)
          SizedBox(height: extraSpaceBeforeBookingInformation),
        Text(
          'Booking Information',
          style: TextStyles.semiBold16.copyWith(color: const Color(0xff242424)),
        ),
        const SizedBox(height: 14),
        const BookingInfoItem(
          isBookingDetailsSection: true,
        ),
        const SizedBox(height: 22),
        if (extraSpaceBeforeDoctorInformation > 0)
          SizedBox(height: extraSpaceBeforeDoctorInformation),
        Text(
          'Doctor Information',
          style: TextStyles.semiBold16.copyWith(color: const Color(0xff242424)),
        ),
        const SizedBox(height: 8),
        CustomDoctorInfoModel(
          doctorModel: appointmentModel.doctor,
          isAboutDoctorView: true,
          height: 80,
          width: 80,
        ),
      ],
    );
  }
}
