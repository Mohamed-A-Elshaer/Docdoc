import 'dart:math';

class DoctorModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final String gender;
  final String address;
  final String description;
  final String degree;
  final int appointPrice;
  final String startTime;
  final String endTime;
  final RatingModel ratingModel;
  final Specialization specialization;
  final City city;

  DoctorModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.photo,
      required this.gender,
      required this.address,
      required this.description,
      required this.degree,
      required this.appointPrice,
      required this.startTime,
      required this.endTime,
      required this.ratingModel,
      required this.specialization,
      required this.city});

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] is int
        ? json['id'] as int
        : int.tryParse(json['id'].toString()) ?? 0;
    return DoctorModel(
      id: id,
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photo: json['photo'],
      gender: json['gender'],
      address: json['address'],
      description: json['description'],
      degree: json['degree'],
      appointPrice: json['appoint_price'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      ratingModel: RatingModel.generateFakeForDoctor(id),
      specialization: Specialization.fromJson(json['specialization']),
      city: City.fromJson(json['city']),
    );
  }

  DoctorModel copyWith({
    RatingModel? ratingModel,
  }) {
    return DoctorModel(
      id: id,
      name: name,
      email: email,
      phone: phone,
      photo: photo,
      gender: gender,
      address: address,
      description: description,
      degree: degree,
      appointPrice: appointPrice,
      startTime: startTime,
      endTime: endTime,
      ratingModel: ratingModel ?? this.ratingModel,
      specialization: specialization,
      city: city,
    );
  }
}

class RatingModel {
  final double rate;
  final int count;

  RatingModel({required this.rate, required this.count});

  /// Deterministic “display” rating before any real Supabase ratings exist for this doctor.
  factory RatingModel.generateFakeForDoctor(int doctorId) {
    final random = Random(doctorId * 10007);
    final double value = 1 + random.nextDouble() * 4;
    return RatingModel(
      rate: double.parse(value.toStringAsFixed(1)),
      count: 20 + random.nextInt(231),
    );
  }

  factory RatingModel.generateFake() {
    final double value = 1 + Random().nextDouble() * 4;
    return RatingModel(
      rate: double.parse(value.toStringAsFixed(1)),
      count: 20 + Random().nextInt(231),
    );
  }

  /// [average] includes seed + all user rows; [userReviewCount] is the display review count.
  factory RatingModel.fromAggregate({
    required double average,
    required int userReviewCount,
  }) {
    return RatingModel(
      rate: double.parse(average.clamp(1.0, 5.0).toStringAsFixed(1)),
      count: userReviewCount,
    );
  }
}

class Specialization {
  final int id;
  final String name;

  Specialization({required this.id, required this.name});

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(id: json['id'], name: json['name']);
  }
}

class City {
  final int id;
  final String name;
  final Governrate governrate;

  City({required this.id, required this.name, required this.governrate});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      governrate: Governrate.fromJson(json['governrate']),
    );
  }
}

class Governrate {
  final int id;
  final String name;

  Governrate({required this.id, required this.name});

  factory Governrate.fromJson(Map<String, dynamic> json) {
    return Governrate(
      id: json['id'],
      name: json['name'],
    );
  }
}
