import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class MedicalRecordView extends StatelessWidget {
  const MedicalRecordView({super.key});

  static const String routeName = 'medical_record';

  static const String _bloodAnalysisDescription =
      'red blood cell : 4.10 million cells/mcL\n'
      'hemogoblin : 142 grams/L\n'
      'hematocrit : 33.6%\n'
      'white blood cells : 3.850 cells/mcL';

  static const List<_MedicalRecordMonthData> _months = [
    _MedicalRecordMonthData(
      monthName: 'This Month',
      entries: [
        _MedicalRecordEntryData(
          date: 'Feb 25',
          title: 'End of observation',
        ),
        _MedicalRecordEntryData(
          date: 'Feb 25',
          title: 'Blood Analysis',
          description: _bloodAnalysisDescription,
        ),
        _MedicalRecordEntryData(
          date: 'Feb 25',
          title: 'Blood Analysis',
          description: _bloodAnalysisDescription,
        ),
      ],
    ),
    _MedicalRecordMonthData(
      monthName: 'January',
      entries: [
        _MedicalRecordEntryData(
          date: 'Feb 25',
          title: 'End of observation',
        ),
        _MedicalRecordEntryData(
          date: 'Feb 25',
          title: 'Blood Analysis',
          description: _bloodAnalysisDescription,
        ),
        _MedicalRecordEntryData(
          date: 'Feb 25',
          title: 'Blood Analysis',
          description: _bloodAnalysisDescription,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final monthSections = <Widget>[];
    for (var i = 0; i < _months.length; i++) {
      if (i > 0) {
        monthSections.add(const SizedBox(height: 32));
      }
      monthSections.add(_MedicalRecordMonthSection(month: _months[i]));
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Medical Record',
        leftPadding: 41,
        onTap: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                ...monthSections,
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MedicalRecordMonthSection extends StatelessWidget {
  const _MedicalRecordMonthSection({required this.month});

  final _MedicalRecordMonthData month;

  @override
  Widget build(BuildContext context) {
    final entryWidgets = <Widget>[];
    for (var i = 0; i < month.entries.length; i++) {
      if (i > 0) {
        entryWidgets.add(const SizedBox(height: 16));
      }
      entryWidgets.add(_MedicalRecordObservationItem(entry: month.entries[i]));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          month.monthName,
          style: TextStyles.semiBold16.copyWith(
            color: const Color(0xff242424),
          ),
        ),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: entryWidgets,
        ),
      ],
    );
  }
}

class _MedicalRecordObservationItem extends StatelessWidget {
  const _MedicalRecordObservationItem({required this.entry});

  final _MedicalRecordEntryData entry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.date,
              style: TextStyles.regular14.copyWith(
                color: const Color(0xff757575),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                entry.title,
                style: TextStyles.semiBold14.copyWith(
                  color: const Color(0xff242424),
                ),
              ),
            ),
          ],
        ),
        if (entry.description != null) ...[
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 71),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: entry.description!
                      .split('\n')
                      .map(
                        (line) => Text(
                          line,
                          softWrap: false,
                          style: TextStyles.regular12.copyWith(
                            color: const Color(0xff757575),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _MedicalRecordMonthData {
  const _MedicalRecordMonthData({
    required this.monthName,
    required this.entries,
  });

  final String monthName;
  final List<_MedicalRecordEntryData> entries;
}

class _MedicalRecordEntryData {
  const _MedicalRecordEntryData({
    required this.date,
    required this.title,
    this.description,
  });

  final String date;
  final String title;
  final String? description;
}
