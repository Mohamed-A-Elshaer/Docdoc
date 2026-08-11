import 'package:docdoc/features/bookAppoint/presentation/views/widgets/active_step_item.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/completed_step_item.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/inActive_step_item.dart';
import 'package:flutter/cupertino.dart';

class StepItem extends StatelessWidget {
  const StepItem(
      {super.key,
      required this.index,
      required this.text,
      required this.isActive,
      required this.isCompleted,
      this.isFirst = false,
      required this.hasRightPadding});

  final String index, text;
  final bool isActive;
  final bool isCompleted;
  final bool isFirst;
  final bool hasRightPadding;

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return CompletedStepItem(
          index: index,
          text: text,
          isFirst: isFirst,
          hasRightPadding: hasRightPadding);
    } else if (isActive) {
      return ActiveStepItem(
          index: index,
          text: text,
          isFirst: isFirst,
          hasRightPadding: hasRightPadding);
    } else {
      return InActiveStepItem(
          index: index,
          text: text,
          isFirst: isFirst,
          hasRightPadding: hasRightPadding);
    }
  }
}
