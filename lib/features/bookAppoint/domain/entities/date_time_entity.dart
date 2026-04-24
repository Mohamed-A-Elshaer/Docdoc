class DateTimeEntity{
  final String date;
  final String time;
  final String appointType;
  bool? isAvailableTimeChosen;

  DateTimeEntity({
    required this.date,
    required this.time,
    required this.appointType,
    this.isAvailableTimeChosen,
  });


  String dateTimeToString() {
    return '$date\n$time';
  }

  String appointTypeToString() {
    return appointType;
  }
}