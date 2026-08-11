import 'package:docdoc/core/helper_functions/appointment_display_format.dart';
import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/core/widgets/custom_doctor_info_model.dart';
import 'package:docdoc/features/my_appointments/domain/entities/user_appointment_entity.dart';
import 'package:flutter/material.dart';

BoxDecoration _appointmentCardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: const Color(0xff000000).withOpacity(0.04),
        blurRadius: 30,
        offset: const Offset(0, -5),
        spreadRadius: 0,
      ),
    ],
  );
}

class MyAppointmentUpcomingCard extends StatelessWidget {
  const MyAppointmentUpcomingCard({
    super.key,
    required this.item,
    required this.onCancel,
    required this.onReschedule,
  });

  final UserAppointmentEntity item;
  final VoidCallback onCancel;
  final VoidCallback onReschedule;

  @override
  Widget build(BuildContext context) {
    final dateLine = formatAppointmentCardDateLine(item.startTime);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          width: 343,
          decoration: _appointmentCardDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomDoctorInfoModel(
                  doctorModel: item.doctor,
                  isRecommendedView: false,
                  height: 110,
                  width: 110,
                  appointmentDateLine: dateLine,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Divider(
                    thickness: 0.3,
                    height: 0.6,
                    color: const Color(0xff616161).withOpacity(0.9),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        text: 'Cancel Appointment',
                        width: 148,
                        height: 38,
                        fontSize: 12,
                        isOutlined: true,
                        padding: EdgeInsets.zero,
                        onPressed: onCancel,
                        val: 22,
                      ),
                      CustomButton(
                        text: 'Reschedule',
                        width: 148,
                        height: 38,
                        fontSize: 12,
                        padding: EdgeInsets.zero,
                        onPressed: onReschedule,
                        val: 22,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum MyAppointmentHistoryKind { completed, cancelled }

class MyAppointmentHistoryCard extends StatelessWidget {
  const MyAppointmentHistoryCard({
    super.key,
    required this.item,
    required this.kind,
  });

  final UserAppointmentEntity item;
  final MyAppointmentHistoryKind kind;

  @override
  Widget build(BuildContext context) {
    final dateLine = formatAppointmentCardDateLine(item.startTime);
    final title = kind == MyAppointmentHistoryKind.completed
        ? 'Appointment done'
        : 'Appointment cancelled';
    final titleColor = kind == MyAppointmentHistoryKind.completed
        ? const Color(0xff22C55E)
        : const Color(0xffFF4C5E);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: 343,
          decoration: _appointmentCardDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: TextStyles.regular12.copyWith(color: titleColor),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      dateLine,
                      style: TextStyles.regular14.copyWith(
                        color: const Color(0xff616161),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Divider(
                    thickness: 0.3,
                    height: 0.6,
                    color: const Color(0xff616161).withOpacity(0.9),
                  ),
                ),
                CustomDoctorInfoModel(
                  doctorModel: item.doctor,
                  isRecommendedView: false,
                  height: 110,
                  width: 110,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
