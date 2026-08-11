import 'package:flutter/material.dart';

import '../utils/app_text_styles.dart';

class CustomDropDownButtonFormField extends StatefulWidget {
  final String? value;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;

  const CustomDropDownButtonFormField(
      {super.key,
      required this.value,
      required this.onChanged,
      required this.onSaved});

  @override
  State<CustomDropDownButtonFormField> createState() =>
      _CustomDropDownButtonFormFieldState();
}

class _CustomDropDownButtonFormFieldState
    extends State<CustomDropDownButtonFormField> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.value,
      decoration: InputDecoration(
        hintText: 'Gender',
        hintStyle: TextStyles.medium14.copyWith(color: const Color(0xffC2C2C2)),
        filled: true,
        fillColor: const Color(0xffF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: ['Male', 'Female'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
              style:
                  TextStyles.medium14.copyWith(color: const Color(0xff242424))),
        );
      }).toList(),
      onChanged: widget.onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your gender';
        }
        return null;
      },
      onSaved: widget.onSaved,
    );
  }
}
