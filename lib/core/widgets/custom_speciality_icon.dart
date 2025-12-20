import 'package:docdoc/core/generated/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomSpecialityIcon extends StatelessWidget{
  const CustomSpecialityIcon({super.key,
    required this.imageName,
    required this.speciality,
    required this.radius,
    required this.imageSize,
    required this.textStyle,
  });
final String imageName;
final String speciality;
final double radius;
final double imageSize;
final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
   return Column(
     mainAxisSize: MainAxisSize.min,
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
       CircleAvatar(
         radius: radius,
         backgroundColor: const Color(0xffF4F8FF),
         child: Image.asset(imageName, height: imageSize, width: imageSize),
       ),
        const SizedBox(height: 8),
        Flexible(
          child: FittedBox(
            fit: BoxFit.none,
            child: Text(
              speciality,
              style: textStyle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
     ],
   );
  }

}