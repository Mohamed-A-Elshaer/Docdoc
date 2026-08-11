import 'package:docdoc/core/helper_models/doctor_model.dart';

class HomeSpecialtyModel {
  final int id;
  final String name;
  final List<DoctorModel> doctors;

  HomeSpecialtyModel({
    required this.id,
    required this.name,
    required this.doctors,
  });

  factory HomeSpecialtyModel.fromJson(Map<String, dynamic> json) {
    final doctorsList = json['doctors'] as List<dynamic>? ?? [];
    return HomeSpecialtyModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      doctors: doctorsList
          .map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
