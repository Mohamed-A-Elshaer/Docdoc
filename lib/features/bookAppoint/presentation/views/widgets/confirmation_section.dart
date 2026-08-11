import 'package:docdoc/core/api_services/appointment_module.dart';
import 'package:docdoc/core/helper_functions/build_error_bar.dart';
import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/core/helper_models/appointment_model.dart';
import 'package:docdoc/core/services/get_it_service.dart';
import 'package:docdoc/core/widgets/custom_doctor_info_model.dart';
import 'package:docdoc/core/widgets/custom_text_button.dart';
import 'package:docdoc/features/bookAppoint/domain/entities/appoint_entity.dart';
import 'package:docdoc/features/bookAppoint/domain/entities/booking_entity.dart';
import 'package:docdoc/features/bookAppoint/domain/repos/booking_repo.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/booking_info_item.dart';
import 'package:docdoc/features/checkout/data/models/payment_intent_input_model.dart';
import 'package:docdoc/features/checkout/data/models/paypal_transaction_input_model.dart';
import 'package:docdoc/features/checkout/presentation/cubits/paypal_payment_cubit.dart';
import 'package:docdoc/features/checkout/presentation/cubits/stripe_payment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/helper_functions/responsive_dimesions.dart';
import '../../../../../core/widgets/custom_button.dart';

class ConfirmationSection extends StatelessWidget {
  const ConfirmationSection({
    super.key,
    required this.doctorModel,
    required this.pageController,
  });

  final DoctorModel doctorModel;
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Information',
          style: TextStyles.semiBold16.copyWith(color: const Color(0xff242424)),
        ),
        const SizedBox(
          height: 14,
        ),
        const BookingInfoItem(
          isBookingDetailsSection: false,
        ),
        const SizedBox(
          height: 22,
        ),
        Text(
          'Doctor Information',
          style: TextStyles.semiBold16.copyWith(color: const Color(0xff242424)),
        ),
        const SizedBox(
          height: 8,
        ),
        CustomDoctorInfoModel(
          doctorModel: doctorModel,
          isAboutDoctorView: true,
          height: 80,
          width: 80,
        ),
        const SizedBox(
          height: 40,
        ),
        Text(
          'Payment Information',
          style: TextStyles.semiBold16.copyWith(color: const Color(0xff242424)),
        ),
        const SizedBox(
          height: 20,
        ),
        Consumer<BookingEntity>(
          builder: (context, bookingEntity, child) {
            final paymentOption =
                bookingEntity.paymentOptionEntity?.paymentOption ??
                    'Not selected';

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      Assets.imagesPaypal,
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          paymentOption,
                          style: TextStyles.medium14
                              .copyWith(color: const Color(0xff242424)),
                        ),
                        /*Text(
                          '***** ***** ***** 37842',
                          style: TextStyles.regular10
                              .copyWith(color: const Color(0xff616161)),
                        ),*/
                      ],
                    ),
                  ],
                ),
                SizedBox(
                    width: 80,
                    height: 38,
                    child: CustomTextButton(
                      text: 'Change',
                      onPressed: () {
                        pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                    ))
              ],
            );
          },
        )
      ],
    );
  }

  static void confirmationSheet(
    BuildContext context,
    DoctorModel doctorModel, {
    required Function(AppointmentModel) onBookingSuccess,
  }) {
    // Capture providers from the parent route before showing the modal sheet,
    // since modal routes do not inherit them automatically.
    final bookingEntity = Provider.of<BookingEntity>(context, listen: false);
    final stripePaymentCubit = context.read<StripePaymentCubit>();
    final payPalPaymentCubit = context.read<PayPalPaymentCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: ResponsiveDimensions.responsiveHeight(context, 300),
        minHeight: ResponsiveDimensions.responsiveHeight(context, 300),
      ),
      builder: (modalContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: stripePaymentCubit),
            BlocProvider.value(value: payPalPaymentCubit),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Payment Info',
                    style: TextStyles.semiBold14
                        .copyWith(color: const Color(0xff242424)),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal',
                        style: TextStyles.regular14
                            .copyWith(color: const Color(0xff757575)),
                      ),
                      Text(
                        '\$${doctorModel.appointPrice.toString()}',
                        style: TextStyles.semiBold14
                            .copyWith(color: const Color(0xff242424)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tax',
                        style: TextStyles.regular14
                            .copyWith(color: const Color(0xff757575)),
                      ),
                      Text(
                        '\$250',
                        style: TextStyles.semiBold14
                            .copyWith(color: const Color(0xff242424)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Total',
                        style: TextStyles.semiBold16
                            .copyWith(color: const Color(0xff242424)),
                      ),
                      Text(
                        '\$${(doctorModel.appointPrice + 250).toString()}',
                        style: TextStyles.semiBold16
                            .copyWith(color: const Color(0xff242424)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  // Use Consumer to listen to changes, but provide the bookingEntity we got earlier
                  ChangeNotifierProvider.value(
                    value: bookingEntity,
                    child: Consumer<BookingEntity>(
                      builder: (context, bookingEntity, child) {
                        var isBooking = false;
                        return BlocBuilder<StripePaymentCubit, StripePaymentState>(
                          builder: (context, stripeState) {
                            return BlocBuilder<PayPalPaymentCubit,
                                PayPalPaymentState>(
                              builder: (context, payPalState) {
                                final isStripeLoading =
                                    stripeState is StripePaymentLoading;
                                final isPayPalLoading =
                                    payPalState is PayPalPaymentLoading;
                                final isPaymentLoading =
                                    isStripeLoading || isPayPalLoading;
                                return StatefulBuilder(
                                  builder: (context, setLocalState) {
                                    return CustomButton(
                                      text: 'Book Now',
                                      isLoading: isBooking || isPaymentLoading,
                                      onPressed: () async {
                                        if (isBooking || isPaymentLoading) {
                                          return;
                                        }
                                        setLocalState(() => isBooking = true);

                                        final dateTimeEntity =
                                            bookingEntity.dateTimeEntity;
                                        if (dateTimeEntity == null ||
                                            dateTimeEntity
                                                    .isAvailableTimeChosen !=
                                                true) {
                                          buildErrorBar(context,
                                              'Please select date and time');
                                          setLocalState(
                                              () => isBooking = false);
                                          return;
                                        }

                                        final paymentOption = bookingEntity
                                                .paymentOptionEntity
                                                ?.paymentOption ??
                                            '';

                                        const taxAmount = 250;
                                        final paymentTotal =
                                            doctorModel.appointPrice + taxAmount;

                                        if (paymentOption == 'Credit Card') {
                                          final paymentSucceeded = await context
                                              .read<StripePaymentCubit>()
                                              .makePaymentAsync(
                                                paymentIntentInputModel:
                                                    PaymentIntentInputModel
                                                        .fromPrice(
                                                  priceInMainUnits:
                                                      paymentTotal,
                                                  currency: 'usd',
                                                ),
                                              );

                                          if (!paymentSucceeded) {
                                            if (!context.mounted) return;
                                            final failureState = context
                                                .read<StripePaymentCubit>()
                                                .state;
                                            final errMsg = failureState
                                                    is StripePaymentFailure
                                                ? failureState.errMsg
                                                : 'Payment failed. Please try again.';
                                            buildErrorBar(context, errMsg);
                                            setLocalState(
                                                () => isBooking = false);
                                            return;
                                          }
                                        } else if (paymentOption == 'Paypal') {
                                          final paymentSucceeded = await context
                                              .read<PayPalPaymentCubit>()
                                              .makePaymentAsync(
                                                context: context,
                                                transactionInputModel:
                                                    PayPalTransactionInputModel
                                                        .fromBooking(
                                                  appointPrice:
                                                      doctorModel.appointPrice,
                                                  taxAmount: taxAmount,
                                                  doctorName:
                                                      doctorModel.name,
                                                ),
                                              );

                                          if (!paymentSucceeded) {
                                            if (!context.mounted) return;
                                            final failureState = context
                                                .read<PayPalPaymentCubit>()
                                                .state;
                                            final errMsg = failureState
                                                    is PayPalPaymentFailure
                                                ? failureState.errMsg
                                                : 'Payment failed. Please try again.';
                                            buildErrorBar(context, errMsg);
                                            setLocalState(
                                                () => isBooking = false);
                                            return;
                                          }
                                        }

                                        if (!context.mounted) return;
                                        await _bookAppointment(
                                          context: context,
                                          doctorModel: doctorModel,
                                          bookingEntity: bookingEntity,
                                          onBookingSuccess: onBookingSuccess,
                                          onComplete: () => setLocalState(
                                              () => isBooking = false),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ), // Add bottom padding for scroll
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> _bookAppointment({
    required BuildContext context,
    required DoctorModel doctorModel,
    required BookingEntity bookingEntity,
    required Function(AppointmentModel) onBookingSuccess,
    required VoidCallback onComplete,
  }) async {
    final dateTimeEntity = bookingEntity.dateTimeEntity!;

    final dateFormatter = DateFormat('EEEE, dd MMMM yyyy');
    DateTime selectedDate;
    try {
      selectedDate = dateFormatter.parse(dateTimeEntity.date);
    } catch (e) {
      buildErrorBar(context, 'Invalid date format');
      onComplete();
      return;
    }

    final time24Hour = _convertTo24HourFormat(dateTimeEntity.time);
    final dateTimeString =
        '${DateFormat('yyyy-MM-dd').format(selectedDate)} $time24Hour';

    try {
      final response = await AppointmentModule().storeAppoint(
        docId: doctorModel.id,
        start_time: dateTimeString,
        notes: '',
      );

      print('Appointment API response: $response');

      final message = response['message']?.toString().trim();
      final hasSuccessMessage =
          message != null && (message == 'Created Successfuly');

      Map<String, dynamic>? appointmentData;
      if (response.containsKey('data')) {
        final data = response['data'];
        if (data is Map<String, dynamic>) {
          if (data.containsKey('id') && data.containsKey('doctor')) {
            appointmentData = data;
          } else if (data.containsKey('appointment') &&
              data['appointment'] is Map) {
            appointmentData =
                Map<String, dynamic>.from(data['appointment'] as Map);
          } else {
            appointmentData = data;
          }
        } else if (data is List && data.isNotEmpty && data[0] is Map) {
          appointmentData = Map<String, dynamic>.from(data[0] as Map);
        }
      } else if (response.containsKey('id') && response.containsKey('doctor')) {
        appointmentData = response;
      }

      final isSuccess = hasSuccessMessage ||
          (appointmentData != null &&
              appointmentData.containsKey('id') &&
              appointmentData.containsKey('doctor'));

      if (isSuccess && appointmentData != null) {
        final appointment = AppointmentModel.fromJson(appointmentData);

        final userUid = Supabase.instance.client.auth.currentUser?.id;
        if (userUid == null || userUid.isEmpty) {
          buildErrorBar(
              context, 'You must be signed in to save the appointment.');
          onComplete();
          return;
        }

        final appointEntity = AppointEntity(
          userUID: userUid,
          apiAppointID: appointment.id,
          apiDoctorID: appointment.doctor.id,
          apiPatientID: appointment.patient.id,
          startTime: appointment.appoint_time,
          endTime: appointment.appoint_end_time,
          status: appointment.status,
          notes: appointment.notes.isEmpty ? null : appointment.notes,
          appointPrice: appointment.appoint_price,
        );

        try {
          await getIt<BookingRepo>().addAppointment(appoint: appointEntity);
        } catch (e) {
          print('Supabase appointment save error: $e');
          buildErrorBar(context,
              'Appointment booked but could not save locally. Please try again later.');
          onComplete();
          return;
        }

        if (context.mounted) {
          Navigator.of(context).pop();
        }
        onBookingSuccess(appointment);
      } else {
        if (!isSuccess) {
          print('Appointment response message not recognized: "$message"');
        }
        if (appointmentData == null) {
          print(
              'Appointment response has no data or unexpected structure. Keys: ${response.keys.toList()}');
        }
        buildErrorBar(context, 'Failed to book appointment. Please try again.');
        onComplete();
      }
    } catch (e, stackTrace) {
      print('Appointment booking error: $e');
      print('Stack trace: $stackTrace');
      buildErrorBar(context, 'Failed to book appointment. Please try again.');
      onComplete();
    }
  }

  // Helper function to convert time from "02.00 PM" to "14:00" format
  static String _convertTo24HourFormat(String time12Hour) {
    try {
      // Use DateFormat to parse the time (format: "02.00 PM")
      final inputFormat = DateFormat('hh.mm a');
      final outputFormat = DateFormat('HH:mm');
      final dateTime = inputFormat.parse(time12Hour);
      return outputFormat.format(dateTime);
    } catch (e) {
      // Fallback: manual parsing if DateFormat fails
      try {
        // Remove spaces and convert to uppercase for easier parsing
        String time = time12Hour.replaceAll(' ', '').toUpperCase();

        // Extract hour, minute, and AM/PM
        final parts = time.split(RegExp(r'[.:]'));
        if (parts.length < 2) {
          throw const FormatException('Invalid time format');
        }

        int hour = int.parse(parts[0]);
        int minute =
            int.parse(parts[1].substring(0, 2)); // Get first 2 digits (minute)
        String period = parts[1].substring(2).trim(); // Get AM/PM and trim

        // Convert to 24-hour format
        if (period == 'PM' && hour != 12) {
          hour += 12;
        } else if (period == 'AM' && hour == 12) {
          hour = 0;
        }

        // Format as "HH:mm"
        return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      } catch (e2) {
        throw FormatException('Unable to parse time: $time12Hour');
      }
    }
  }
}
