import 'dart:math';

class DoctorModel{
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

  DoctorModel({
      required this.id,
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
    return DoctorModel(
      id:   json['id'],
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
      ratingModel: RatingModel.generateFake(),
      specialization: Specialization.fromJson(json['specialization']),
      city: City.fromJson(json['city']),
    );
  }


}

class RatingModel
{
  final double rate;
  final int count;

  RatingModel({required this.rate,required this.count});

  factory RatingModel.generateFake(){
    final double value = 1 + Random().nextDouble() * 4;
    return RatingModel(
        rate: double.parse(value.toStringAsFixed(1)),
        count: 20 + Random().nextInt(231),
    );
  }
}

class Specialization{
  final int id;
  final String name;

  Specialization({required this.id,required this.name});

  factory Specialization.fromJson(Map<String,dynamic> json){
    return Specialization(
        id: json['id'],
        name: json['name']
    );
  }
}

class City{
  final int id;
  final String name;
  final Governrate governrate;

  City({required this.id,required this.name,required this.governrate});

  factory City.fromJson(Map<String,dynamic> json){
    return City(
    id: json['id'],
    name: json['name'],
    governrate: Governrate.fromJson(json['governrate']),
    );


  }
}

class Governrate{
  final int id;
  final String name;

  Governrate({required this.id,required this.name});

  factory Governrate.fromJson(Map<String,dynamic> json){
    return Governrate(
      id: json['id'],
      name: json['name'],
    );
  }
  }