import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ActiveItem extends StatelessWidget {
  const ActiveItem({super.key, required this.logoName, this.isPng = false});
  final bool isPng;
  final String logoName;
  @override
  Widget build(BuildContext context) {
    return isPng
        ? CircleAvatar(
            radius: 15,
            backgroundColor: const Color(0xff000000).withOpacity(0.4),
            child: Opacity(
                opacity: 0.4,
                child: Image.asset(logoName, height: 24, width: 24)))
        : SvgPicture.asset(logoName);
  }
}
