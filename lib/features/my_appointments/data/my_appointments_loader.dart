import 'package:docdoc/core/api_services/doctor_module.dart';
import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/core/services/get_it_service.dart';
import 'package:docdoc/features/bookAppoint/domain/repos/booking_repo.dart';
import 'package:docdoc/features/my_appointments/domain/entities/user_appointment_entity.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyAppointmentsLoader {
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

  Future<List<UserAppointmentEntity>> loadForCurrentUser() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];

    final rows = await getIt<BookingRepo>().getAppointmentsForUser(user.id);
    final doctors = await DoctorModule().getAllDoctorsWithMergedRatings();
    final byDoctorId = <int, DoctorModel>{
      for (final d in doctors) d.id: d,
    };

    final result = <UserAppointmentEntity>[];
    for (final row in rows) {
      final rawId = row['id'];
      final rowId =
          rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');
      if (rowId == null) continue;

      final rawDoc = row['api_doctor_id'];
      final docId =
          rawDoc is int ? rawDoc : int.tryParse(rawDoc?.toString() ?? '');
      if (docId == null) continue;

      final doctor = byDoctorId[docId];
      if (doctor == null) continue;

      final start = _parseStartTime(row['start_time']);
      if (start == null) continue;

      final rawApi = row['api_appointment_id'];
      final apiAppointId =
          rawApi is int ? rawApi : int.tryParse(rawApi?.toString() ?? '') ?? 0;

      final status = row['status']?.toString() ?? '';

      result.add(
        UserAppointmentEntity(
          supabaseRowId: rowId,
          apiAppointmentId: apiAppointId,
          apiDoctorId: docId,
          startTime: start,
          rawStatus: status,
          doctor: doctor,
        ),
      );
    }

    result.sort((a, b) => b.startTime.compareTo(a.startTime));
    return result;
  }
}
