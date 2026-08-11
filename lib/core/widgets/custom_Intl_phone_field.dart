import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import 'custom_text_form_field.dart';

PhoneNumber? parsePhoneInitialValue(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;

  final e164 = trimmed.startsWith('+') ? trimmed : '+$trimmed';
  final parsed = PhoneNumber.fromCompleteNumber(completeNumber: e164);
  if (parsed.number.isEmpty && parsed.countryISOCode.isEmpty) {
    return null;
  }
  return parsed;
}

/// Normalizes a [PhoneNumber] to E.164 (e.g. `+201012345678`).
String formatPhoneE164(PhoneNumber phone) {
  final national = phone.number.replaceAll(RegExp(r'\D'), '');
  if (national.isEmpty) return '';

  final dialDigits = phone.countryCode.replaceAll(RegExp(r'\D'), '');
  if (dialDigits.isEmpty) return '+$national';

  return '+$dialDigits$national';
}

class CustomIntlPhoneField extends FormField<PhoneNumber> {
  final String hintText;
  final String? phoneInitialValue;
  final String? initialCountryCode;
  final TextStyle? style;
  final bool disableLengthCheck;
  final String? invalidNumberMessage;
  final ValueChanged<PhoneNumber>? onPhoneChanged;

  CustomIntlPhoneField({
    super.key,
    super.onSaved,
    super.validator,
    AutovalidateMode super.autovalidateMode = AutovalidateMode.disabled,
    this.hintText = 'Your number',
    this.phoneInitialValue,
    this.initialCountryCode,
    this.style,
    this.disableLengthCheck = false,
    this.invalidNumberMessage,
    this.onPhoneChanged,
  }) : super(
          initialValue: parsePhoneInitialValue(phoneInitialValue),
          builder: (FormFieldState<PhoneNumber> state) {
            final field = state.widget as CustomIntlPhoneField;
            final parsed =
                state.value ?? parsePhoneInitialValue(field.phoneInitialValue);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntlPhoneField(
                  initialCountryCode:
                      field.initialCountryCode ?? parsed?.countryISOCode,
                  initialValue: parsed?.number,
                  disableLengthCheck: field.disableLengthCheck,
                  invalidNumberMessage: field.invalidNumberMessage,
                  style: field.style,
                  onChanged: (phone) {
                    state.didChange(phone);
                    field.onPhoneChanged?.call(phone);
                  },
                  decoration: InputDecoration(
                    hintText: field.hintText,
                    hintStyle: TextStyles.medium14.copyWith(
                      color: const Color(0xffC2C2C2),
                    ),
                    filled: true,
                    fillColor: AppColors.secondryColor,
                    border: CustomTextFormField.buildOutlineInputBorder(),
                    enabledBorder:
                        CustomTextFormField.buildOutlineInputBorder(),
                    focusedBorder:
                        CustomTextFormField.buildOutlineInputBorder(),
                    errorText: state.errorText,
                  ),
                ),
              ],
            );
          },
        );
}
