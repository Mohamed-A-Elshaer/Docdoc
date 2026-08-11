import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/backend_endpoint.dart';

/// Notifies profile/home UI to reload display name and email from Supabase.
class UserProfileDisplayNotifier extends ChangeNotifier {
  UserProfileDisplayNotifier._();

  static final UserProfileDisplayNotifier instance =
      UserProfileDisplayNotifier._();

  int _refreshGeneration = 0;

  int get refreshGeneration => _refreshGeneration;

  void notifyProfileUpdated() {
    _refreshGeneration++;
    notifyListeners();
  }

  Future<Map<String, String>> fetchProfileDisplay() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return {'name': 'Guest User', 'email': 'No email'};
    }

    final data = await Supabase.instance.client
        .from(BackendEndpoint.addUserData)
        .select('name, email')
        .eq('uid', user.id)
        .maybeSingle();

    final email =
        user.email?.trim().isNotEmpty == true ? user.email!.trim() : 'No email';
    if (data == null) {
      return {'name': 'Guest User', 'email': email};
    }

    final map = Map<String, dynamic>.from(data);
    final nameRaw = map['name'];
    final emailRaw = map['email'];
    final name = nameRaw is String && nameRaw.trim().isNotEmpty
        ? nameRaw.trim()
        : 'Guest User';
    final userEmail = emailRaw is String && emailRaw.trim().isNotEmpty
        ? emailRaw.trim()
        : email;

    return {'name': name, 'email': userEmail};
  }

  Future<String?> fetchDisplayName() async {
    final profile = await fetchProfileDisplay();
    final name = profile['name'];
    if (name == null || name.isEmpty || name == 'Guest User') {
      return 'Guest User';
    }
    return name;
  }
}
