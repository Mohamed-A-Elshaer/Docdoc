import 'doctor_model.dart';

String _jsonToString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  return value.toString();
}

class AppointmentModel {
  final int id;
  final DoctorModel doctor;
  final Patient patient;
  final String appoint_time;
  final String appoint_end_time;
  final String status;
  final String notes;
  final String appoint_price;

  AppointmentModel(
      {required this.id,
      required this.doctor,
      required this.appoint_time,
      required this.appoint_end_time,
      required this.status,
      required this.notes,
      required this.appoint_price,
      required this.patient});

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
        id: json['id'] is int
            ? json['id'] as int
            : int.tryParse(json['id'].toString()) ?? 0,
        doctor: DoctorModel.fromJson(json['doctor'] as Map<String, dynamic>),
        appoint_time: _jsonToString(json['appointment_time']),
        appoint_end_time: _jsonToString(json['appointment_end_time']),
        status: _jsonToString(json['status']),
        notes: _jsonToString(json['notes']),
        appoint_price: _jsonToString(json['appointment_price']),
        patient: Patient.fromJson(json['patient'] as Map<String, dynamic>));
  }
}

class Patient {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String gender;

  Patient(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.gender});

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
        id: json['id'] is int
            ? json['id'] as int
            : int.tryParse(json['id'].toString()) ?? 0,
        name: _jsonToString(json['name']),
        email: _jsonToString(json['email']),
        phone: _jsonToString(json['phone']),
        gender: _jsonToString(json['gender']));
  }
}
