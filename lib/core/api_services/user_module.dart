import 'dart:math';

import 'package:docdoc/core/helper_classes/api.dart';
import 'package:docdoc/core/helper_models/appointment_model.dart';
import 'package:docdoc/core/helper_models/environment.dart';
import 'package:intl_phone_field/phone_number.dart';

class UserModule {
  /// Strips country dial code from E.164, returning national digits only (for API).
  static String nationalPhoneFromE164(String? phone) {
    if (phone == null || phone.trim().isEmpty) return '';

    final trimmed = phone.trim();
    final e164 = trimmed.startsWith('+') ? trimmed : '+$trimmed';
    final parsed = PhoneNumber.fromCompleteNumber(completeNumber: e164);
    if (parsed.number.isNotEmpty) {
      return parsed.number.replaceAll(RegExp(r'\D'), '');
    }

    return trimmed.replaceAll(RegExp(r'\D'), '');
  }

  static String genderToApiValue(String? dbGender) {
    if (dbGender == 'Female') return '1';
    if (dbGender == 'Male') return '0';
    return '0';
  }

  /// Appends a random letter for the API's required intermediate email update.
  static String middleUpdateEmail(String email) {
    const letters = 'abcdefghijklmnopqrstuvwxyz';
    final index = Random().nextInt(letters.length);
    return '$email${letters[index]}';
  }

  /// Replaces the last digit with a random digit for the API's intermediate phone update.
  static String middleUpdatePhone(String phone) {
    if (phone.isEmpty) return phone;
    const digits = '0123456789';
    final lastChar = phone[phone.length - 1];

    String replacement;
    do {
      replacement = digits[Random().nextInt(digits.length)];
    } while (lastChar == replacement);

    if (phone.length == 1) return replacement;
    return phone.substring(0, phone.length - 1) + replacement;
  }

  Future<Patient> userProfile() async {
    Map<String, dynamic> apiResponse = await Api().get(
      url: '${Environment.apiBaseUrl}user/profile',
      token:
          null, // Api class will automatically use stored token from SharedPreferences
    );
    print('Body:  $apiResponse');

    // Extract the first element from the data array
    if (apiResponse.containsKey('data') && apiResponse['data'] is List) {
      final dataList = apiResponse['data'] as List;
      if (dataList.isNotEmpty && dataList[0] is Map) {
        return Patient.fromJson(dataList[0] as Map<String, dynamic>);
      }
    }

    // Fallback: try to parse the response directly (for backward compatibility)
    return Patient.fromJson(apiResponse);
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await Api().post(
      url: '${Environment.apiBaseUrl}user/update',
      body: {
        'name': name,
        'email': email,
        'phone': phone,
        'gender': gender,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      token: null,
    );

    if (response is Map<String, dynamic>) {
      print(
        'UpdateProfile response message: ${response['message'] ?? response['msg'] ?? response}',
      );
      return response;
    }

    print('UpdateProfile response message: $response');
    return <String, dynamic>{};
  }

  /// Updates the API profile with a middle request (tweaked email/phone) then
  /// the final request with real values. Used for any profile field change.
  Future<void> updateProfileWithWorkaround({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String password,
    required String passwordConfirmation,
  }) async {
    await updateProfile(
      name: name,
      email: middleUpdateEmail(email),
      phone: middleUpdatePhone(phone),
      gender: gender,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    await updateProfile(
      name: name,
      email: email,
      phone: phone,
      gender: gender,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}
