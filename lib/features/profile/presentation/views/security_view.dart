import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/core/widgets/custom_app_bar.dart';
import 'package:docdoc/features/profile/presentation/views/widgets/profile_settings_row_item.dart';
import 'package:flutter/material.dart';

class SecurityView extends StatefulWidget {
  const SecurityView({super.key});

  static const String routeName = 'security';

  @override
  State<SecurityView> createState() => _SecurityViewState();
}

class _SecurityViewState extends State<SecurityView> {
  static const Color _labelColor = Color(0xff242424);

  bool _rememberPassword = true;
  bool _faceId = false;
  bool _pin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Security',
        leftPadding: 73,
        onTap: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            ProfileSettingsRowItem(
              useSwitchRow: true,
              label: 'Remember password',
              textColor: _labelColor,
              switchValue: _rememberPassword,
              onSwitchChanged: (v) => setState(() => _rememberPassword = v),
            ),
            const SizedBox(height: 25),
            ProfileSettingsRowItem(
              useSwitchRow: true,
              label: 'Face ID',
              textColor: _labelColor,
              switchValue: _faceId,
              onSwitchChanged: (v) => setState(() => _faceId = v),
            ),
            const SizedBox(height: 25),
            ProfileSettingsRowItem(
              useSwitchRow: true,
              label: 'PIN',
              textColor: _labelColor,
              switchValue: _pin,
              onSwitchChanged: (v) => setState(() => _pin = v),
            ),
            const SizedBox(height: 25),
            ProfileSettingsRowItem(
              isLeadingIconActive: false,
              iconAssetPath: Assets.imagesGoogleLogo,
              label: 'Google Authenticator',
              textColor: _labelColor,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
