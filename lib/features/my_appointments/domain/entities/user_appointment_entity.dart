import 'package:docdoc/core/helper_models/doctor_model.dart';

class UserAppointmentEntity {
  const UserAppointmentEntity({
    required this.supabaseRowId,
    required this.apiAppointmentId,
    required this.apiDoctorId,
    required this.startTime,
    required this.rawStatus,
    required this.doctor,
  });

  final int supabaseRowId;
  final int apiAppointmentId;
  final int apiDoctorId;
  final DateTime startTime;
  final String rawStatus;
  final DoctorModel doctor;

  bool get isPending => rawStatus.toLowerCase().trim() == 'pending';

  bool get isFinished {
    final s = rawStatus.toLowerCase().trim();
    return s == 'finished' || s == 'completed';
  }

  bool get isCancelled {
    final s = rawStatus.toLowerCase().trim();
    return s == 'cancelled' || s == 'canceled';
  }
}
