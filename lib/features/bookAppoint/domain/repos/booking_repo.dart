import 'package:docdoc/features/bookAppoint/domain/entities/appoint_entity.dart';

abstract class BookingRepo {
  Future<void> addAppointment({required AppointEntity appoint});

  /// Returns list of appointment rows (e.g. for reading start_time) for the given doctor.
  Future<List<Map<String, dynamic>>> getAppointmentsByDoctorId(int doctorId);

  Future<List<Map<String, dynamic>>> getAppointmentsForUser(String userUid);

  Future<void> updateAppointmentById({
    required int id,
    required Map<String, dynamic> data,
  });
}
