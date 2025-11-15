import 'package:docdoc/core/generated/app_colors.dart';
import 'package:docdoc/core/generated/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget{
  const CustomTextFormField({super.key, required this.hintText, required this.textInputType,this.suffixIcon, this.onSaved});
final String hintText;
final TextInputType textInputType;
final Widget? suffixIcon;
final void Function(String?)? onSaved;
  @override
  Widget build(BuildContext context) {
   return TextFormField(
validator: (value){
       if (value==null||value.isEmpty) {
         return 'Please fill this field';
       }
return null;
     },
onSaved:onSaved ,
keyboardType: textInputType,
decoration: InputDecoration(
  hintText: hintText,
  hintStyle: TextStyles.medium14.copyWith(color: Color(0xffC2C2C2)),
  filled: true,
  fillColor: AppColors.secondryColor,
  border: buildOutlineInputBorder(),
  enabledBorder: buildOutlineInputBorder(),
  focusedBorder: buildOutlineInputBorder(),
  suffixIcon: suffixIcon
),


   );
  }

 static OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
borderRadius: BorderRadius.circular(16),
borderSide: const BorderSide(
width: 1,
color: Color(0xffEDEDED) 
),
);
  }


}