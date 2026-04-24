import 'package:docdoc/core/utils/backend_endpoint.dart';
import 'package:docdoc/features/bookAppoint/domain/repos/booking_repo.dart';
import '../../../../core/services/database_service.dart';
import '../../domain/entities/appoint_entity.dart';

class BookingRepoImp extends BookingRepo {
  final DatabaseService databaseService;
  BookingRepoImp({required this.databaseService});

  @override
  Future<void> addAppointment({required AppointEntity appoint}) async {
    await databaseService.addAppointment(path: BackendEndpoint.addAppointmentData, data: appoint.toMap());
  }

  @override
  Future<List<Map<String, dynamic>>> getAppointmentsByDoctorId(int doctorId) async {
    return databaseService.getAppointmentsByDoctorId(
      path: BackendEndpoint.addAppointmentData,
      doctorId: doctorId,
    );
  }
}