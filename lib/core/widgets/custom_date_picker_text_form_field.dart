import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import 'custom_text_form_field.dart';

class CustomDatePickerTextFormField extends StatefulWidget {
  const CustomDatePickerTextFormField(
      {super.key, this.onSaved, this.onDateChanged});

  final void Function(String?)? onSaved;
  final ValueChanged<DateTime?>? onDateChanged;

  @override
  State<CustomDatePickerTextFormField> createState() =>
      CustomDatePickerTextFormFieldState();
}

class CustomDatePickerTextFormFieldState
    extends State<CustomDatePickerTextFormField> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final DateTime initialDate =
        _selectedDate ?? DateTime(now.year - 18, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
      widget.onDateChanged?.call(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      onTap: _pickDate,
      onSaved: widget.onSaved,
      decoration: InputDecoration(
        hintText: 'Date of Birth',
        hintStyle: TextStyles.medium14.copyWith(color: const Color(0xffC2C2C2)),
        filled: true,
        fillColor: AppColors.secondryColor,
        border: CustomTextFormField.buildOutlineInputBorder(),
        enabledBorder: CustomTextFormField.buildOutlineInputBorder(),
        focusedBorder: CustomTextFormField.buildOutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today, color: Color(0xffC2C2C2)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill this field';
        }
        return null;
      },
    );
  }
}
