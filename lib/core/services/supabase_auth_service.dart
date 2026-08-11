import 'dart:developer';
import 'package:docdoc/core/errors/exceptions.dart';
import 'package:docdoc/features/auth/domain/repos/auth_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants.dart';

class SupabaseAuthService {
  static const String _googleServerClientId =
      '419174052737-gvt0gpbpibvrlrjhuod1ni5d0m22ifd7.apps.googleusercontent.com';
  static const String _iosClientId =
      '419174052737-strpgnhoqmhlj9u7ro4p20hafpfku343.apps.googleusercontent.com';

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
      log("Exception in SupabaseAuthService.signUpUser: ${e.toString()} and ${e.message}");
      if (e.message.contains('Password should be at least 6 characters.')) {
        throw CustomException(
            message:
                'The password provided is too weak. Should be at least 6 characters ');
      } else if (e.message.contains('already registered')) {
        throw CustomException(
            message: 'Account already exists for this email!');
      } else if (e.message
          .contains('Unable to validate email address: invalid format')) {
        throw CustomException(message: 'invalid email format!');
      } else {
        throw CustomException(
            message: 'An error occured. Please try again later.');
      }
    } catch (e) {
      log("Exception in SupabaseAuthService.signUpUser: ${e.toString()}");
      throw CustomException(
          message: 'An error occured. Please try again later.');
    }
  }

  Future<User> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response =
          await AuthRepo.supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user!;
    } on AuthException catch (e) {
      log("Exception in SupabaseAuthService.signInUser: ${e.toString()} and ${e.message}");
      if (e.message.contains('Invalid login credentials')) {
        throw CustomException(message: 'Invalid email or password!');
      } else {
        throw CustomException(
            message: 'An error occured. Please try again later.');
      }
    } catch (e) {
      log("Exception in SupabaseAuthService.signInUser: ${e.toString()}");
      throw CustomException(
          message: 'An error occured. Please try again later.');
    }
  }

  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      scopes: <String>['email', 'profile'],
      serverClientId: _googleServerClientId,
      clientId:
          defaultTargetPlatform == TargetPlatform.iOS ? _iosClientId : null,
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw CustomException(message: 'Google sign-in was cancelled.');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final idToken = googleAuth.idToken;
    if (idToken == null) {
      throw CustomException(
          message:
              'Unable to retrieve Google ID token. Check your OAuth client configuration.');
    }

    final AuthResponse response =
        await AuthRepo.supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: googleAuth.accessToken,
    );

    if (response.user == null) {
      throw CustomException(
          message: 'Failed to complete Google sign-in. Please try again.');
    }

    return response.user!;
  }

  Future<User> signInWithFacebook() async {
    await AuthRepo.supabase.auth.signInWithOAuth(
      OAuthProvider.facebook,
      redirectTo: kIsWeb ? null : redirectUrl,
      authScreenLaunchMode:
          kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
    );

    final authState = await AuthRepo.supabase.auth.onAuthStateChange
        .firstWhere(
      (event) => event.session?.user != null,
    )
        .timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw CustomException(message: 'Facebook sign-in timed out.');
      },
    );

    final session = authState.session;
    if (session?.user == null) {
      throw CustomException(
        message: 'Failed to complete Facebook sign-in. Please try again.',
      );
    }

    return session!.user;
  }

  Future deleteUser({required userId}) async {
    final supabase = SupabaseClient('https://kmzdvodtliieskcpjrzd.supabase.co',
        'sb_secret_IU3ydlgPC-ROP37taVRKqw_USbu-0hQ');
    await supabase.auth.admin.deleteUser(userId);
  }
}
