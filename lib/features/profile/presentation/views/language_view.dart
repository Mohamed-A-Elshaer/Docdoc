import 'package:docdoc/core/widgets/custom_app_bar.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/features/profile/presentation/views/widgets/profile_settings_row_item.dart';
import 'package:flutter/material.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  static const String routeName = 'language';

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  static const Color _labelColor = Color(0xff242424);

  /// `ar`, `en` (default), `de`
  String _selectedCode = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Language',
        leftPadding: 67,
        onTap: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            ProfileSettingsRowItem(
              useRadioRow: true,
              label: 'Arabic',
              textColor: _labelColor,
              radioSelected: _selectedCode == 'ar',
              onRadioTap: () => setState(() => _selectedCode = 'ar'),
            ),
            const SizedBox(height: 10),
            ProfileSettingsRowItem(
              useRadioRow: true,
              label: 'English',
              textColor: _labelColor,
              radioSelected: _selectedCode == 'en',
              onRadioTap: () => setState(() => _selectedCode = 'en'),
            ),
            const SizedBox(height: 10),
            ProfileSettingsRowItem(
              useRadioRow: true,
              label: 'German',
              textColor: _labelColor,
              radioSelected: _selectedCode == 'de',
              onRadioTap: () => setState(() => _selectedCode = 'de'),
            ),
            const Spacer(),
            Center(
              child: CustomButton(
                text: 'Save',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
