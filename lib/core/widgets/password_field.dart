import 'package:flutter/material.dart';
import 'custom_text_form_field.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.onSaved
  });
  final void Function(String?)? onSaved;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obsecureText=true;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      obsecureText: obsecureText,
      onSaved:widget.onSaved,
      hintText: 'Password',
      textInputType: TextInputType.visiblePassword,
      suffixIcon: GestureDetector(
        onTap: (){
          obsecureText=!obsecureText;
          setState(() {});
        },
        child: obsecureText? const Icon(
          Icons.visibility,
          color: Color(0xffC2C2C2),)
        : const Icon(
          Icons.visibility_off,
          color: Color(0xffC2C2C2),),
      ),);
  }
}