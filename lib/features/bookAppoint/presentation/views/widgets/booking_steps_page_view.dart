import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/confirmation_section.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/date_time_section.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/payment_section.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/booking_details_section.dart';
import 'package:docdoc/core/helper_models/appointment_model.dart';
import 'package:flutter/cupertino.dart';

class BookingStepsPageView extends StatelessWidget {
  const BookingStepsPageView({
    super.key,
    required this.pageController,
    required this.doctorModel,
    this.appointmentModel,
  });

  final PageController pageController;
  final DoctorModel doctorModel;
  final AppointmentModel? appointmentModel;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: getPages().length,
          itemBuilder: (context,index){
            return getPages()[index];
          }
      );

  }

  List<Widget> getPages(){
    List<Widget> pages = [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 21,horizontal: 24),
        child: DateTimeSection(doctorId: doctorModel.id),
      ),
      const PaymentSection(),
       Padding(
        padding: const EdgeInsets.symmetric(vertical: 21,horizontal: 24),
        child: ConfirmationSection(doctorModel:doctorModel ,),
      ),
    ];

    // Add booking details page if appointment was successfully created
    // The appointmentModel will only be set if the API response message was 'Created Successfully'
    if (appointmentModel != null) {
      pages.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 21,horizontal: 24),
          child: BookingDetailsSection(appointmentModel: appointmentModel!),
        ),
      );
    }

    return pages;
  }
}