import 'package:supabase_flutter/supabase_flutter.dart';
import 'database_service.dart';

class SupabaseDatabaseService implements DatabaseService {
  @override
  Future<void> addUserDataToDatabase({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    // Use upsert so we can create or update the same record by uid
    await Supabase.instance.client.from(path).upsert(data, onConflict: 'uid');
  }

  @override
  Future<Map<String, dynamic>?> getUserData({
    required String path,
    required String uid,
  }) async {
    final response = await Supabase.instance.client
        .from(path)
        .select()
        .eq('uid', uid)
        .maybeSingle();
    if (response == null) {
      return null;
    }
    return Map<String, dynamic>.from(response);
  }
}