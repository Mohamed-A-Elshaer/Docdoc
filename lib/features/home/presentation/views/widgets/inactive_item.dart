import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InActiveItem extends StatelessWidget {
  const InActiveItem({super.key, required this.logoName, this.isPng = false});
  final bool isPng;
  final String logoName;
  @override
  Widget build(BuildContext context) {
    return isPng
        ? CircleAvatar(
            radius: 15,
            // backgroundColor: Colors.white,
            child: Image.asset(
              logoName,
              height: 24,
              width: 24,
            ))
        : SvgPicture.asset(logoName);
  }
}
