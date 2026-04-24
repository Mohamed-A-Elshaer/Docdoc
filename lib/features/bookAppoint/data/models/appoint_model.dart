import 'package:docdoc/features/bookAppoint/domain/entities/appoint_entity.dart';

class AppointModel extends AppointEntity{
  AppointModel({
    required super.userUID,
    required super.apiAppointID,
    required super.apiDoctorID,
    required super.apiPatientID,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.appointPrice,
    super.notes
  });

  factory AppointModel.fromMap(Map<String,dynamic> map){
    return AppointModel(
        userUID: map['user_uid'] as String,
        apiAppointID: map['api_appointment_id'] as int,
        apiDoctorID: map['api_doctor_id'] as int,
        apiPatientID: map['api_patient_id'] as int,
        startTime: map['start_time'] as String,
        endTime: map['end_time'] as String,
        status: map['status'] as String,
        appointPrice: map['appoint_price'] as String,
        notes: map['notes'] as String?,
    );

  }


}