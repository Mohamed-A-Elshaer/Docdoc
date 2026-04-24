import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../errors/exceptions.dart';
import '../helper_classes/api.dart';
import '../helper_models/environment.dart';
import '../services/shared_preferences_singelton.dart';

class AuthModule{
  Future<void> signUpUserApi({required UserEntity user,required String password,required User supaUser})async {
    // Register user via API
    try {
      // Validate required fields
      if (user.name == null || user.name!.isEmpty) {
        throw Exception('Name is required for API registration');
      }
      if (user.email.isEmpty) {
        throw Exception('Email is required for API registration');
      }
      if (password.isEmpty) {
        throw Exception('Password is required for API registration');
      }

      final apiResponse = await Api().post(
        url: '${Environment.apiBaseUrl}auth/register',
        body: {
          'name': user.name ?? '',
          'email': user.email,
          'phone': user.phone ?? '',
          'gender': user.gender == 'Male' ? '0' : (user.gender == 'Female' ? '1' : ''),
          'password': password,
          'password_confirmation': password,
        },
        token: null, // No token needed for registration
      );

      if (apiResponse is Map) {

        // Extract and store API token if present in response
        extractToken(apiResponse: apiResponse);

      }

      // Password is kept permanently in SharedPreferences for future API sign-ins
      // (especially important for OAuth users who can't remember their generated password)
      // This allows users to re-authenticate with API when tokens expire

    } catch (apiError) {
      log('Exception in API registration: ${apiError.toString()}');
      // Re-throw to be handled by submitProfile
      throw CustomException(message: 'Failed to register user in API: ${apiError.toString()}');
    }
  }

  Future<void> signInUserApi({required String email, required String password}) async {
    // Sign in user via API
    try {
      // Validate required fields
      if (email.isEmpty) {
        throw Exception('Email is required for API login');
      }
      if (password.isEmpty) {
        throw Exception('Password is required for API login');
      }

      final apiResponse = await Api().post(
        url: '${Environment.apiBaseUrl}auth/login',
        body: {
          'email': email,
          'password': password,
        },
        token: null, // No token needed for login
      );

      // Extract and store API token from response
      if (apiResponse is Map) {
        extractToken(apiResponse: apiResponse);
      }
    } catch (apiError) {
      log('Exception in API login: ${apiError.toString()}');
      throw CustomException(message: 'Failed to login user in API: ${apiError.toString()}');
    }
  }


  Future<void> extractToken({required dynamic apiResponse}) async{
    String? apiToken;

    // Check if token is in data object (current response structure)
    if (apiResponse.containsKey('data') && apiResponse['data'] is Map) {
      final data = apiResponse['data'] as Map;
      if (data.containsKey('token')) {
        apiToken = data['token'] as String?;
        log('API token extracted from data.token');
      }
    }

    // Fallback checks for different response structures
    if (apiToken == null) {
      if (apiResponse.containsKey('token')) {
        apiToken = apiResponse['token'] as String?;
        log('API token extracted from root token');
      } else if (apiResponse.containsKey('access_token')) {
        apiToken = apiResponse['access_token'] as String?;
        log('API token extracted from access_token');
      }
    }

    if (apiToken != null && apiToken.isNotEmpty) {
      await Prefs.setString('api_token', apiToken);
      log('API token stored successfully');
      // Verify token was stored
      final storedToken = Prefs.getString('api_token');
      log('Token verification: ${storedToken != null ? "Token stored successfully (length: ${storedToken.length})" : "ERROR: Token not found in storage"}');
    } else {
      throw Exception('Token not found in the response');
    }
  }

}