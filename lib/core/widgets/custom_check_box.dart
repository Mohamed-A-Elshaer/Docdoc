import 'package:docdoc/core/utils/app_colors.dart';
import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget{
  const CustomCheckBox({super.key, this.text});
 final String? text;
  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
   bool isChecked=false;
  @override
  Widget build(BuildContext context) {
    return Row(
      
    children: [
      Checkbox(
          activeColor: AppColors.primaryColor,
          value: isChecked,
          side: const BorderSide(
            width: 2,
            color: Color(0xffA9B2B9)
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onChanged: (value) {
           isChecked=value!;
           setState(() {});
}),
      Transform.translate(
          offset: Offset(MediaQuery.of(context).size.width * -0.02, 0),
          child: Text(widget.text!,style: TextStyles.regular12.copyWith(color: const Color(0xff9E9E9E)),))

    ],
  );
  }
}