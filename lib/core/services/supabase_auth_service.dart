import 'package:docdoc/core/errors/exceptions.dart';
import 'package:docdoc/features/auth/domain/repos/auth_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService{
  Future<User> signUpUser({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await AuthRepo.supabase.auth.signUp(
        email: email,
        password: password,
      );

      return response.user!;
    } on AuthException catch (e) {
      print(e);
      if (e.message.contains('Password should be at least 6 characters.')) {
        throw CustomException(message: 'The password provided is too weak');
      }else if (e.message.contains('already registered')) {
        throw CustomException(message: 'Account already exists for this email!');
      } else{
        throw CustomException(message: 'An error occured. Please try again later.');
      }
    } catch(e){
      print(e);
      throw CustomException(message: 'An error occured. Please try again later.');
    }

  }
}