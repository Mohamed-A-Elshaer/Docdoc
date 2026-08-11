import 'package:docdoc/core/api_services/appointment_module.dart';
import 'package:docdoc/core/helper_models/appointment_model.dart';
import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/features/bookAppoint/domain/entities/date_time_entity.dart';
import 'package:intl/intl.dart';

/// Calls the booking API and parses [AppointmentModel] (same rules as [ConfirmationSection]).
class StoreAppointmentApiUsecase {
  const StoreAppointmentApiUsecase();

  static String _convertTo24HourFormat(String time12Hour) {
    try {
      final inputFormat = DateFormat('hh.mm a');
      final outputFormat = DateFormat('HH:mm');
      final dateTime = inputFormat.parse(time12Hour);
      return outputFormat.format(dateTime);
    } catch (_) {
      try {
        String time = time12Hour.replaceAll(' ', '').toUpperCase();
        final parts = time.split(RegExp(r'[.:]'));
        if (parts.length < 2) {
          throw const FormatException('Invalid time format');
        }
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1].substring(0, 2));
        String period = parts[1].substring(2).trim();
        if (period == 'PM' && hour != 12) {
          hour += 12;
        } else if (period == 'AM' && hour == 12) {
          hour = 0;
        }
        return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      } catch (e2) {
        throw FormatException('Unable to parse time: $time12Hour');
      }
    }
  }

  Future<AppointmentModel?> call({
    required DoctorModel doctor,
    required DateTimeEntity dateTimeEntity,
  }) async {
    final dateFormatter = DateFormat('EEEE, dd MMMM yyyy');
    DateTime selectedDate;
    try {
      selectedDate = dateFormatter.parse(dateTimeEntity.date);
    } catch (_) {
      return null;
    }

    final time24Hour = _convertTo24HourFormat(dateTimeEntity.time);
    final dateTimeString =
        '${DateFormat('yyyy-MM-dd').format(selectedDate)} $time24Hour';

    final response = await AppointmentModule().storeAppoint(
      docId: doctor.id,
      start_time: dateTimeString,
      notes: '',
    );

    final message = response['message']?.toString().trim();
    final hasSuccessMessage = message == 'Created Successfuly';

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

    if (!isSuccess || appointmentData == null) {
      return null;
    }
    return AppointmentModel.fromJson(appointmentData);
  }
}
