import 'package:docdoc/core/helper_functions/responsive_dimesions.dart';
import 'package:flutter/material.dart';
import 'package:docdoc/core/widgets/custom_tab_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../../domain/entities/date_time_entity.dart';
import 'select_date_item.dart';

class AvailableTimeItem extends StatefulWidget {
  const AvailableTimeItem({
    super.key,
    required this.selectDateItemKey,
    required this.selectedAppointmentType,
    this.bookedTimeSlots,
  });

  final GlobalKey<SelectDateItemState> selectDateItemKey;
  final int selectedAppointmentType;

  /// Time slot strings (e.g. "05.30 PM") that are already booked for the selected date.
  final Set<String>? bookedTimeSlots;

  @override
  State<AvailableTimeItem> createState() => _AvailableTimeItemState();
}

class _AvailableTimeItemState extends State<AvailableTimeItem> {
  int? selectedIndex;

  final List<String> timeSlots = [
    '02.00 PM',
    '02.30 PM',
    '03.00 PM',
    '03.30 PM',
    '04.00 PM',
    '04.30 PM',
    '05.00 PM',
    '05.30 PM',
    '06.00 PM',
    '06.30 PM',
    '07.00 PM',
    '07.30 PM',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize selectedIndex from bookingEntity if it exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookingEntity = context.read<BookingEntity>();
      if (bookingEntity.dateTimeEntity != null &&
          bookingEntity.dateTimeEntity?.isAvailableTimeChosen == true) {
        final selectedTime = bookingEntity.dateTimeEntity!.time;
        final index = timeSlots.indexOf(selectedTime);
        if (index != -1) {
          setState(() {
            selectedIndex = index;
          });
        }
      }
    });
  }

  String _getAppointmentTypeString(int index) {
    switch (index) {
      case 0:
        return 'In Person';
      case 1:
        return 'Video Call';
      case 2:
        return 'Phone Call';
      default:
        return 'In Person';
    }
  }

  bool _isPastSlotForSelectedDate(String slot) {
    final selectedDate =
        widget.selectDateItemKey.currentState?.getSelectedDate() ??
            DateTime.now();
    final now = DateTime.now();
    final selectedDay =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final today = DateTime(now.year, now.month, now.day);
    if (selectedDay != today) return false;

    try {
      final parsedSlot = DateFormat('hh.mm a').parse(slot);
      final slotDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        parsedSlot.hour,
        parsedSlot.minute,
      );
      return !slotDateTime.isAfter(now);
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveDimensions.responsiveHeight(context, 122),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 157 / 49,
        ),
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          final isBooked =
              widget.bookedTimeSlots?.contains(timeSlots[index]) ?? false;
          final isPastSlot = _isPastSlotForSelectedDate(timeSlots[index]);
          final isUnavailable = isBooked || isPastSlot;
          return GestureDetector(
            onTap: isUnavailable
                ? null
                : () {
                    setState(() {
                      selectedIndex = index;
                      final bookingEntity = context.read<BookingEntity>();

                      // Get selected date from SelectDateItem
                      final selectedDate = widget.selectDateItemKey.currentState
                              ?.getSelectedDate() ??
                          DateTime.now();

                      // Format date as "Wednesday, 08 May 2023"
                      final dateFormatter = DateFormat('EEEE, dd MMMM yyyy');
                      final dateString = dateFormatter.format(selectedDate);

                      // Get appointment type string
                      final appointmentType = _getAppointmentTypeString(
                          widget.selectedAppointmentType);

                      // Create or update dateTimeEntity with current selections
                      bookingEntity.dateTimeEntity = DateTimeEntity(
                        date: dateString,
                        time: timeSlots[index],
                        appointType: appointmentType,
                        isAvailableTimeChosen: true,
                      );
                    });
                  },
            child: IgnorePointer(
              ignoring: isUnavailable,
              child: CustomTabButton(
                containerHeight: 49,
                containerWidth: 157,
                buttonRadius: 16,
                isActive: selectedIndex == index,
                isRatingTab: false,
                tabTitle: timeSlots[index],
                isDisabled: isUnavailable,
              ),
            ),
          );
        },
      ),
    );
  }
}
