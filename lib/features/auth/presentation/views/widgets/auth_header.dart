import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:flutter/cupertino.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader(
      {super.key,
      required this.title,
      required this.desc,
      required this.height});
  final String title;
  final String desc;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height,
        ),
        Text(
          title,
          style: TextStyles.bold24,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          desc,
          style: TextStyles.regular14,
        )
      ],
    );
  }
}
