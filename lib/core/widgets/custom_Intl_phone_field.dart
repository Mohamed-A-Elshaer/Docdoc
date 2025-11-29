import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../generated/app_colors.dart';
import '../generated/app_text_styles.dart';
import 'custom_text_form_field.dart';

class CustomIntlPhoneField extends FormField<PhoneNumber> {
  CustomIntlPhoneField({
    super.key,
    super.onSaved,
    super.validator,
    AutovalidateMode super.autovalidateMode = AutovalidateMode.disabled,
  }) : super(
    builder: (FormFieldState<PhoneNumber> state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntlPhoneField(
            initialCountryCode: 'EG',
            onChanged: (phone) {
              state.didChange(phone);
            },
            decoration: InputDecoration(
              hintText: 'Your number',
              hintStyle: TextStyles.medium14.copyWith(
                  color: const Color(0xffC2C2C2)),
              filled: true,
              fillColor: AppColors.secondryColor,
              border: CustomTextFormField.buildOutlineInputBorder(),
              enabledBorder: CustomTextFormField.buildOutlineInputBorder(),
              focusedBorder: CustomTextFormField.buildOutlineInputBorder(),
              errorText: state.errorText,
            ),
          ),
        ],
      );
    },
  );
}
