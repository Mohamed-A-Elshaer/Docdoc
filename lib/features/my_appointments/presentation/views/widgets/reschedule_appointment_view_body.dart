import 'package:docdoc/core/helper_functions/build_error_bar.dart';
import 'package:docdoc/core/helper_functions/responsive_dimesions.dart';
import 'package:docdoc/core/helper_models/appointment_model.dart';
import 'package:docdoc/core/widgets/custom_app_bar.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/features/bookAppoint/domain/entities/booking_entity.dart';
import 'package:docdoc/features/bookAppoint/domain/usecases/store_appointment_api_usecase.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/booking_details_section.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/booking_flow_success_header.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/date_time_section.dart';
import 'package:docdoc/features/bookAppoint/domain/entities/date_time_entity.dart';
import 'package:docdoc/features/my_appointments/presentation/views/reschedule_appointment_view.dart';
import 'package:docdoc/core/services/get_it_service.dart';
import 'package:docdoc/features/bookAppoint/domain/repos/booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RescheduleAppointmentViewBody extends StatefulWidget {
  const RescheduleAppointmentViewBody({super.key, required this.args});

  final RescheduleAppointmentArgs args;

  @override
  State<RescheduleAppointmentViewBody> createState() =>
      _RescheduleAppointmentViewBodyState();
}

class _RescheduleAppointmentViewBodyState
    extends State<RescheduleAppointmentViewBody> {
  bool _success = false;
  bool _submitting = false;
  AppointmentModel? _appointmentModel;

  Future<void> _submit() async {
    final bookingEntity = context.read<BookingEntity>();
    final dt = bookingEntity.dateTimeEntity;
    if (dt == null || dt.isAvailableTimeChosen != true) {
      buildErrorBar(context, 'Please choose an appointment time');
      return;
    }

    setState(() => _submitting = true);
    try {
      final usecase = const StoreAppointmentApiUsecase();
      final appointment = await usecase.call(
        doctor: widget.args.doctor,
        dateTimeEntity: dt,
      );
      if (!mounted) return;
      if (appointment == null) {
        buildErrorBar(context, 'Failed to reschedule. Please try again.');
        return;
      }

      await getIt<BookingRepo>().updateAppointmentById(
        id: widget.args.supabaseAppointmentId,
        data: {
          'api_appointment_id': appointment.id,
          'api_doctor_id': appointment.doctor.id,
          'api_patient_id': appointment.patient.id,
          'start_time': appointment.appoint_time,
          'end_time': appointment.appoint_end_time,
          'status': appointment.status,
          'notes': appointment.notes.isEmpty ? null : appointment.notes,
          'appoint_price': appointment.appoint_price,
        },
      );

      if (!mounted) return;
      bookingEntity.dateTimeEntity = DateTimeEntity(
        date: dt.date,
        time: dt.time,
        appointType: dt.appointType,
        isAvailableTimeChosen: true,
      );

      setState(() {
        _success = true;
        _appointmentModel = appointment;
      });
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDetails = _success;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reschedule',
        leftPadding: 55,
        onTap: () => Navigator.of(context).pop(),
      ),
      body: Column(
        children: [
          if (isDetails)
            const BookingFlowSuccessHeader(
              title: 'Booking has been rescheduled',
            ),
          Expanded(
            child: Transform.translate(
              offset:
                  Offset(0, ResponsiveDimensions.responsiveHeight(context, 5)),
              child: isDetails
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: BookingDetailsSection(
                        appointmentModel: _appointmentModel!,
                        extraSpaceBeforeBookingInformation: 30,
                        extraSpaceBeforeDoctorInformation: 30,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 21,
                        horizontal: 24,
                      ),
                      child: DateTimeSection(
                        doctorId: widget.args.doctor.id,
                        initialStartTime: widget.args.initialStartTime,
                        excludeAppointmentRowIdFromBookedSlots:
                            widget.args.supabaseAppointmentId,
                        extraSpaceBeforeAvailableTime: 30,
                        extraSpaceBeforeAppointmentType: 30,
                      ),
                    ),
            ),
          ),
          CustomButton(
            text: isDetails ? 'Done' : 'Reschedule',
            isLoading: _submitting,
            onPressed: () {
              if (isDetails) {
                Navigator.of(context).pop(true);
              } else {
                _submit();
              }
            },
          ),
        ],
      ),
    );
  }
}
