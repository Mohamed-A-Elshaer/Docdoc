import 'package:docdoc/core/helper_functions/build_error_bar.dart';
import 'package:docdoc/core/helper_functions/responsive_dimesions.dart';
import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/core/helper_models/appointment_model.dart';
import 'package:docdoc/core/widgets/custom_app_bar.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/features/bookAppoint/domain/entities/booking_entity.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/booking_flow_success_header.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/booking_steps.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/confirmation_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'booking_steps_page_view.dart';

class BookAppointViewBody extends StatefulWidget {
  const BookAppointViewBody({super.key, required this.doctorModel});
  final DoctorModel doctorModel;

  @override
  State<BookAppointViewBody> createState() => _BookAppointViewBodyState();
}

class _BookAppointViewBodyState extends State<BookAppointViewBody> {
  late PageController pageController;
  int currentPageIndex = 0;
  AppointmentModel? appointmentModel;

  @override
  void initState() {
    pageController = PageController();
    pageController.addListener(() {
      if (pageController.page != null) {
        setState(() {
          currentPageIndex = pageController.page!.toInt();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDetailsPage = appointmentModel != null && currentPageIndex == 3;
    final title = isDetailsPage ? 'Details' : 'Book Appointment';
    final buttonText = isDetailsPage ? 'Done' : 'Continue';

    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        leftPadding: isDetailsPage ? 70 : 25,
        onTap: () => Navigator.of(context).pop(),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          isDetailsPage
              ? const BookingFlowSuccessHeader(title: 'Booking Confirmed')
              : BookingSteps(
                  currentPageIndex: currentPageIndex,
                  pageController: pageController,
                ),
          Expanded(
            child: Transform.translate(
              offset:
                  Offset(0, ResponsiveDimensions.responsiveHeight(context, 5)),
              child: BookingStepsPageView(
                pageController: pageController,
                doctorModel: widget.doctorModel,
                appointmentModel: appointmentModel,
              ),
            ),
          ),
          CustomButton(
            text: buttonText,
            onPressed: () {
              if (isDetailsPage) {
                Navigator.of(context).pop();
              } else if (currentPageIndex == 1) {
                _handlePaymentSectionValidation(context);
              } else if (currentPageIndex == 2) {
                ConfirmationSection.confirmationSheet(
                  context,
                  widget.doctorModel,
                  onBookingSuccess: (appointment) {
                    setState(() {
                      appointmentModel = appointment;
                    });
                    pageController.animateToPage(
                      3,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                );
              } else if (currentPageIndex == 0) {
                _handleDateTimeSectionValidation(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _handleDateTimeSectionValidation(BuildContext context) {
    final bookingEntity = context.read<BookingEntity>();
    if (bookingEntity.dateTimeEntity == null ||
        bookingEntity.dateTimeEntity?.isAvailableTimeChosen != true) {
      buildErrorBar(context, 'Please choose an appointment time');
      return;
    }
    pageController.animateToPage(currentPageIndex + 1,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void _handlePaymentSectionValidation(BuildContext context) {
    final bookingEntity = context.read<BookingEntity>();
    if (bookingEntity.paymentOptionEntity == null ||
        bookingEntity.paymentOptionEntity?.isPaymentOptionChosen != true) {
      buildErrorBar(context, 'Please choose a payment option');
      return;
    }

    pageController.animateToPage(currentPageIndex + 1,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }
}
