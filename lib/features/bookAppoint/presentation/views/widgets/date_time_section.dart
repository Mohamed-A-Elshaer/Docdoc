import 'package:docdoc/core/utils/app_colors.dart';
import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/features/bookAppoint/domain/entities/booking_entity.dart';
import 'package:docdoc/features/bookAppoint/domain/entities/date_time_entity.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/appoint_type_item.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/select_date_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:docdoc/core/services/get_it_service.dart';
import 'package:docdoc/features/bookAppoint/domain/repos/booking_repo.dart';
import '../../../../../core/utils/assets.dart';
import 'available_time_item.dart';

class DateTimeSection extends StatefulWidget {
  const DateTimeSection({
    super.key,
    required this.doctorId,
    this.initialStartTime,
    this.excludeAppointmentRowIdFromBookedSlots,
    this.extraSpaceBeforeAvailableTime = 0,
    this.extraSpaceBeforeAppointmentType = 0,
  });

  final int doctorId;

  /// When set (e.g. reschedule), selects date/time slots to match this instant.
  final DateTime? initialStartTime;

  /// Omits this Supabase `appointments.id` row when blocking booked time slots.
  final int? excludeAppointmentRowIdFromBookedSlots;

  /// Extra vertical gap before the "Available time" block (e.g. reschedule screen).
  final double extraSpaceBeforeAvailableTime;

  /// Extra vertical gap before the "Appointment Type" block (e.g. reschedule screen).
  final double extraSpaceBeforeAppointmentType;

  @override
  State<DateTimeSection> createState() => _DateTimeSectionState();
}

class _DateTimeSectionState extends State<DateTimeSection>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<SelectDateItemState> _selectDateItemKey =
      GlobalKey<SelectDateItemState>();
  int selectedAppointmentType = 0;
  List<Map<String, dynamic>> _doctorAppointments = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadDoctorAppointments();
      await _prefillFromInitialStartTime();
      if (!mounted) return;
      final bookingEntity = context.read<BookingEntity>();
      if (bookingEntity.dateTimeEntity != null) {
        final appointType = bookingEntity.dateTimeEntity!.appointType;
        setState(() {
          if (appointType == 'In Person') {
            selectedAppointmentType = 0;
          } else if (appointType == 'Video Call') {
            selectedAppointmentType = 1;
          } else if (appointType == 'Phone Call') {
            selectedAppointmentType = 2;
          }
        });
      }
    });
  }

  Future<void> _prefillFromInitialStartTime() async {
    if (widget.initialStartTime == null) return;
    final dt = widget.initialStartTime!.toLocal();
    _selectDateItemKey.currentState?.selectDate(dt);
    final dateFormatter = DateFormat('EEEE, dd MMMM yyyy');
    final dateStr = dateFormatter.format(dt);
    final timeStr = DateFormat('hh.mm a').format(dt);
    if (!mounted) return;
    final bookingEntity = context.read<BookingEntity>();
    bookingEntity.dateTimeEntity = DateTimeEntity(
      date: dateStr,
      time: timeStr,
      appointType: 'In Person',
      isAvailableTimeChosen: true,
    );
    setState(() {
      selectedAppointmentType = 0;
    });
  }

  Future<void> _loadDoctorAppointments() async {
    try {
      // Load all appointments for this doctor from Supabase (all users)
      final list =
          await getIt<BookingRepo>().getAppointmentsByDoctorId(widget.doctorId);
      if (!mounted) return;
      setState(() {
        _doctorAppointments =
            list; // each row has 'start_time', 'api_doctor_id', etc.
      });
    } catch (e) {
      // optional: debugPrint('Error loading doctor appointments: $e');
    }
  }

  /// Parses start_time from DB (ISO or "Monday, February 16, 2026 5:30 PM") to DateTime.
  static DateTime? _parseStartTime(dynamic value) {
    if (value == null) return null;
    final s = value.toString().trim();
    if (s.isEmpty) return null;
    try {
      return DateTime.parse(s);
    } catch (_) {}
    try {
      return DateFormat('EEEE, MMMM d, yyyy h:mm a').parse(s);
    } catch (_) {}
    try {
      return DateFormat('yyyy-MM-dd HH:mm').parse(s);
    } catch (_) {}
    return null;
  }

  /// For the given date, returns set of time slot strings ("02.00 PM", ...) that are already booked.
  Set<String> _bookedTimeSlotsForDate(DateTime selectedDate) {
    var slotFormat = DateFormat('hh.mm a');
    final out = <String>{};
    final dayStart =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    for (final row in _doctorAppointments) {
      if (widget.excludeAppointmentRowIdFromBookedSlots != null) {
        final rawId = row['id'];
        final rowId =
            rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');
        if (rowId == widget.excludeAppointmentRowIdFromBookedSlots) continue;
      }
      final dt = _parseStartTime(row['start_time']);
      if (dt == null) continue;
      final local = dt.isUtc ? dt.toLocal() : dt;
      if (local.isBefore(dayStart) || !local.isBefore(dayEnd)) continue;
      out.add(slotFormat.format(local));
    }
    return out;
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

  void _updateDateTimeEntity(BuildContext context) {
    final bookingEntity = context.read<BookingEntity>();

    // Only update if there's already a dateTimeEntity with a selected time
    if (bookingEntity.dateTimeEntity != null &&
        bookingEntity.dateTimeEntity?.isAvailableTimeChosen == true) {
      // Get selected date from SelectDateItem
      final selectedDate =
          _selectDateItemKey.currentState?.getSelectedDate() ?? DateTime.now();

      // Format date as "Wednesday, 08 May 2023"
      final dateFormatter = DateFormat('EEEE, dd MMMM yyyy');
      final dateString = dateFormatter.format(selectedDate);

      // Get appointment type string
      final appointmentType =
          _getAppointmentTypeString(selectedAppointmentType);

      // Update dateTimeEntity with current date and appointment type, preserving the time
      bookingEntity.dateTimeEntity = DateTimeEntity(
        date: dateString,
        time: bookingEntity.dateTimeEntity!.time,
        appointType: appointmentType,
        isAvailableTimeChosen: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Date',
              style: TextStyles.semiBold16
                  .copyWith(color: const Color(0xff242424)),
            ),
            GestureDetector(
              onTap: () async {
                final today = DateTime.now();

                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: today,
                  firstDate: DateTime(today.year, today.month, today.day),
                  lastDate: DateTime(today.year, today.month, today.day)
                      .add(const Duration(days: 13)),
                  helpText: 'Select date',
                  cancelText: 'Cancel',
                  confirmText: 'OK',
                );

                if (selectedDate != null) {
                  debugPrint('Selected date: $selectedDate');
                  // Update SelectDateItem with the selected date
                  _selectDateItemKey.currentState?.selectDate(selectedDate);
                  // Update dateTimeEntity if a time is already selected
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _updateDateTimeEntity(context);
                  });
                }
              },
              child: Text(
                'Set Manual',
                style:
                    TextStyles.medium12.copyWith(color: AppColors.primaryColor),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        SelectDateItem(
          key: _selectDateItemKey,
          onDateChanged: () {
            setState(() {});
            _updateDateTimeEntity(context);
          },
        ),
        const SizedBox(
          height: 14,
        ),
        if (widget.extraSpaceBeforeAvailableTime > 0)
          SizedBox(height: widget.extraSpaceBeforeAvailableTime),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Available time',
              style: TextStyles.semiBold16
                  .copyWith(color: const Color(0xff242424)),
            )),
        const SizedBox(
          height: 14,
        ),
        AvailableTimeItem(
          selectDateItemKey: _selectDateItemKey,
          selectedAppointmentType: selectedAppointmentType,
          bookedTimeSlots: _bookedTimeSlotsForDate(
            _selectDateItemKey.currentState?.getSelectedDate() ??
                DateTime.now(),
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        if (widget.extraSpaceBeforeAppointmentType > 0)
          SizedBox(height: widget.extraSpaceBeforeAppointmentType),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Appointment Type',
              style: TextStyles.semiBold16
                  .copyWith(color: const Color(0xff242424)),
            )),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CustomPressableList(
                  image: Assets.imagesAppointInPerson,
                  text: 'In Person',
                  isSelected: selectedAppointmentType == 0,
                  onTap: () {
                    setState(() {
                      selectedAppointmentType = 0;
                    });
                    _updateDateTimeEntity(context);
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomPressableList(
                  image: Assets.imagesAppointVideoCall,
                  text: 'Video Call',
                  isSelected: selectedAppointmentType == 1,
                  onTap: () {
                    setState(() {
                      selectedAppointmentType = 1;
                    });
                    _updateDateTimeEntity(context);
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomPressableList(
                  image: Assets.imagesAppointCall,
                  text: 'Phone Call',
                  isSelected: selectedAppointmentType == 2,
                  onTap: () {
                    setState(() {
                      selectedAppointmentType = 2;
                    });
                    _updateDateTimeEntity(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
