import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class InActiveStepItem extends StatelessWidget {
  const InActiveStepItem(
      {super.key,
      this.isFirst = false,
      required this.index,
      required this.text,
      this.hasRightPadding = false});

  final bool isFirst;
  final String index;
  final String text;
  final bool hasRightPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: hasRightPadding ? 8 : 0),
      child: Row(
        children: [
          if (!isFirst)
            const SizedBox(
              width: 49,
              child: Divider(
                thickness: 2,
                height: 2,
                color: Color(0xffEDEDED),
              ),
            ),
          const SizedBox(
            width: 20,
          ),
          Column(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xffE0E0E0),
                child: Text(
                  index,
                  style: TextStyles.medium12.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                text,
                style: TextStyles.regular10
                    .copyWith(color: const Color(0xff9E9E9E)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
