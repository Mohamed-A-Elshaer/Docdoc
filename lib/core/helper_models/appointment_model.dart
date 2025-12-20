
import 'doctor_model.dart';

class AppointmentModel {
  final int id;
  final DoctorModel doctor;
  final Patient patient;
  final String appoint_time;
  final String appoint_end_time;
  final String status;
  final String notes;
  final String appoint_price;

  AppointmentModel({
      required this.id,
      required this.doctor,
      required this.appoint_time,
      required this.appoint_end_time,
      required this.status,
      required this.notes,
      required this.appoint_price,
      required this.patient});

factory AppointmentModel.fromJson(Map<String,dynamic>json){
  return AppointmentModel(
      id: json['id'],
      doctor: DoctorModel.fromJson(json['doctor']),
      appoint_time: json['appointment_time'],
      appoint_end_time: json['appointment_end_time'],
      status: json['status'],
      notes: json['notes'],
      appoint_price: json['appointment_price'],
      patient: Patient.fromJson(json['patient'])
  );

}
}


class Patient{
final int id;
final String name;
final String email;
final String phone;
final String gender;

Patient({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender});

factory Patient.fromJson(Map<String,dynamic>json){
  return Patient(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender']
  );
}
}