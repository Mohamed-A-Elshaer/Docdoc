import 'doctor_model.dart';

class SpecializationModel {
  final int id;
  final String name;
  final List<DoctorModel> doctors;

  SpecializationModel({
    required this.id,
    required this.name,
    required this.doctors,
  });

  factory SpecializationModel.fromJson(Map<String, dynamic> json) {
    return SpecializationModel(
      id: json['id'],
      name: json['name'],
      doctors: (json['doctors'] as List)
          .map((doctorJson) => DoctorModel.fromJson(doctorJson))
          .toList(),
    );
  }
}
