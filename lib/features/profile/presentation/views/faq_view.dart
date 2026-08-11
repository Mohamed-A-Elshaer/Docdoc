import 'package:docdoc/core/widgets/custom_app_bar.dart';
import 'package:docdoc/features/profile/presentation/views/widgets/faq_item.dart';
import 'package:flutter/material.dart';

class FaqView extends StatelessWidget {
  const FaqView({super.key});

  static const String routeName = 'faq';

  static const List<({String title, String subText})> _entries = [
    (
      title: "What should I expect during a doctor's appointment?",
      subText:
          "During a doctor's appointment, you can expect to discuss your medical history, current symptoms or concerns, and any medications or treatments you are taking. The doctor will likely perform a physical exam and may order additional tests or procedures if necessary.",
    ),
    (
      title: "What should I bring to my doctor's appointment?",
      subText:
          "Bring a valid photo ID, your insurance card, a list of current medications with dosages, any recent test results or imaging reports, and a short list of questions you want to ask. If you track symptoms at home, bring those notes as well.",
    ),
    (
      title: 'What if I need to cancel or reschedule my appointment?',
      subText:
          "Open My Appointments in the app, select the visit, and choose reschedule or cancel. Please try to do this at least 24 hours in advance when possible so the slot can be offered to another patient.",
    ),
    (
      title: 'How do I make an appointment with a doctor?',
      subText:
          "Search for a doctor or speciality from the home screen, open the profile you prefer, then tap Book Appointment. Pick a date and time that work for you, confirm your details, and submit the booking request.",
    ),
    (
      title: "How early should I arrive for my doctor's appointment?",
      subText:
          "Plan to arrive about 10 to 15 minutes before your scheduled time to complete check-in, update paperwork, and settle any copay. If the clinic asks for labs first, follow the instructions in your confirmation message.",
    ),
    (
      title: "How long will my doctor's appointment take?",
      subText:
          "Routine visits often last 15 to 30 minutes, but new-patient or complex visits can run longer. Your confirmation may include an estimated duration; allow extra time in case the doctor orders tests or discusses a care plan in detail.",
    ),
    (
      title: "How much will my doctor's appointment cost?",
      subText:
          "Cost depends on your insurance plan, deductible, copay, and whether the visit is in-network. You can usually find copay information on your insurance card; contact your insurer or the clinic billing office for exact estimates.",
    ),
    (
      title: 'What should I look for in a good doctor?',
      subText:
          "Look for clear communication, respect for your questions, appropriate board certification, convenient location and hours, and a clinic that explains treatment options and follow-up steps in a way you understand.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      const SizedBox(height: 8),
      FaqItem(
        title: _entries[0].title,
        subText: _entries[0].subText,
      ),
    ];

    for (var i = 1; i < _entries.length; i++) {
      children
        ..add(const SizedBox(height: 25))
        ..add(
          FaqItem(
            title: _entries[i].title,
            subText: _entries[i].subText,
          ),
        );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'FAQ',
        leftPadding: 85,
        onTap: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}
