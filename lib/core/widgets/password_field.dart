import 'package:flutter/material.dart';
import 'custom_text_form_field.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.onSaved,
    this.hintText = 'Password',
    this.controller,
    this.validator,
    this.style,
  });

  final void Function(String?)? onSaved;
  final String hintText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextStyle? style;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obsecureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: widget.controller,
      validator: widget.validator,
      style: widget.style,
      obsecureText: obsecureText,
      onSaved: widget.onSaved,
      hintText: widget.hintText,
      textInputType: TextInputType.visiblePassword,
      suffixIcon: GestureDetector(
        onTap: () {
          obsecureText = !obsecureText;
          setState(() {});
        },
        child: obsecureText
            ? const Icon(
                Icons.visibility,
                color: Color(0xffC2C2C2),
              )
            : const Icon(
                Icons.visibility_off,
                color: Color(0xffC2C2C2),
              ),
      ),
    );
  }
}
