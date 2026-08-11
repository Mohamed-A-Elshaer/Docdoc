import 'package:flutter/foundation.dart';

/// Signals [MyAppointmentsViewBody] to reload when appointments change
/// (e.g. after booking), without requiring an app restart.
class AppointmentsRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}
