import 'package:docdoc/core/utils/backend_endpoint.dart';
import 'package:docdoc/core/services/get_it_service.dart';
import 'package:docdoc/features/my_appointments/data/appointments_refresh_notifier.dart';
import 'package:docdoc/features/bookAppoint/domain/repos/booking_repo.dart';
import '../../../../core/services/database_service.dart';
import '../../domain/entities/appoint_entity.dart';

class BookingRepoImp extends BookingRepo {
  final DatabaseService databaseService;
  BookingRepoImp({required this.databaseService});

  @override
  Future<void> addAppointment({required AppointEntity appoint}) async {
    await databaseService.addAppointment(
        path: BackendEndpoint.addAppointmentData, data: appoint.toMap());
    getIt<AppointmentsRefreshNotifier>().refresh();
  }

  @override
  Future<List<Map<String, dynamic>>> getAppointmentsByDoctorId(
      int doctorId) async {
    return databaseService.getAppointmentsByDoctorId(
      path: BackendEndpoint.addAppointmentData,
      doctorId: doctorId,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getAppointmentsForUser(
      String userUid) async {
    return databaseService.getAppointmentsForUser(
      path: BackendEndpoint.addAppointmentData,
      userUid: userUid,
    );
  }

  @override
  Future<void> updateAppointmentById({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    await databaseService.updateAppointmentById(
      path: BackendEndpoint.addAppointmentData,
      id: id,
      data: data,
    );
    getIt<AppointmentsRefreshNotifier>().refresh();
  }
}
