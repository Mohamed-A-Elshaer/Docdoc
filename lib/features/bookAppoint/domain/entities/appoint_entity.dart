class AppointEntity{
  AppointEntity({
      required this.userUID,
      required this.apiAppointID,
      required this.apiDoctorID,
      required this.apiPatientID,
      required this.startTime,
      required this.endTime,
      required this.status,
      this.notes,
      required this.appointPrice
  });

  final String userUID;
  final int apiAppointID;
  final int apiDoctorID;
  final int apiPatientID;
  final String startTime;
  final String endTime;
  final String status;
  final String? notes;
  final String appointPrice;


  Map<String,dynamic> toMap(){
    return{
      'user_uid': userUID,
      'api_appointment_id': apiAppointID,
      'api_doctor_id': apiDoctorID,
      'api_patient_id': apiPatientID,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
      'notes': notes ?? '',
      'appoint_price': appointPrice,
    };
  }
}