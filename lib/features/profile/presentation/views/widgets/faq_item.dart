import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Expandable FAQ row: question + chevron, optional answer, spacing, divider.
class FaqItem extends StatefulWidget {
  const FaqItem({
    super.key,
    required this.title,
    required this.subText,
  });

  final String title;
  final String subText;

  static const Color _titleColor = Color(0xff242424);
  static const Color _arrowColor = Color(0xff242424);
  static const Color _subTextColor = Color(0xff757575);

  static const Widget _divider = Padding(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: Divider(
      thickness: 1,
      height: 2,
      color: Color(0xffEDEDED),
    ),
  );

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyles.regular14.copyWith(
                    color: FaqItem._titleColor,
                  ),
                ),
              ),
              InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: FaqItem._arrowColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              widget.subText,
              style: TextStyles.regular14.copyWith(
                color: FaqItem._subTextColor,
              ),
            ),
          ),
        ],
        const SizedBox(height: 15),
        FaqItem._divider,
      ],
    );
  }
}
