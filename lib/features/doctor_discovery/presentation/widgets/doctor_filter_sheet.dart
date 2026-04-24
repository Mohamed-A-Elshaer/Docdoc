import 'package:docdoc/core/widgets/custom_pop_up_action_card.dart';
import 'package:flutter/material.dart';

typedef DoctorFilterDone = void Function(
  String? selectedSpeciality,
  String? selectedRating,
);

class DoctorFilterSheet {
  static Future<void> show(
    BuildContext context, {
    required DoctorFilterDone onDone,
    String title = 'Sort By',
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xff242424).withOpacity(0.3),
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) => CustomPopUpActionCard(
        title: title,
        onDone: onDone,
      ),
    );
  }
}
