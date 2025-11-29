abstract class DatabaseService {
  Future<void> addUserDataToDatabase({
    required String path,
    required Map<String, dynamic> data,
  });

  Future<Map<String, dynamic>?> getUserData({
    required String path,
    required String uid,
  });
}