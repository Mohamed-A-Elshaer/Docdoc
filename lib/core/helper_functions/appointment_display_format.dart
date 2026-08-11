import 'package:intl/intl.dart';

/// Example: `Wed, 17 May | 08.30 AM`
String formatAppointmentCardDateLine(DateTime dt) {
  final local = dt.toLocal();
  final datePart = DateFormat('EEE, d MMM').format(local);
  final timePart = DateFormat('hh.mm a').format(local);
  return '$datePart | $timePart';
}
