import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/core/widgets/custom_app_bar.dart';
import 'package:docdoc/features/profile/presentation/views/faq_view.dart';
import 'package:docdoc/features/profile/presentation/views/language_view.dart';
import 'package:docdoc/features/profile/presentation/views/notification_view.dart';
import 'package:docdoc/features/profile/presentation/views/security_view.dart';
import 'package:docdoc/features/profile/presentation/views/widgets/profile_settings_row_item.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  static const String routeName = 'settings';

  static const Color _defaultLabelColor = Color(0xff242424);
  static const Color _logoutLabelColor = Color(0xffFF4C5E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        leftPadding: 73,
        onTap: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            ProfileSettingsRowItem(
              iconAssetPath: Assets.imagesNotificationIcon,
              label: 'Notification',
              textColor: _defaultLabelColor,
              onTap: () => Navigator.pushNamed(
                context,
                NotificationView.routeName,
              ),
            ),
            const SizedBox(height: 25),
            ProfileSettingsRowItem(
              iconAssetPath: Assets.imagesFAQIcon,
              label: 'FAQ',
              textColor: _defaultLabelColor,
              onTap: () => Navigator.pushNamed(
                context,
                FaqView.routeName,
              ),
            ),
            const SizedBox(height: 25),
            ProfileSettingsRowItem(
              iconAssetPath: Assets.imagesSecurityIcon,
              label: 'Security',
              textColor: _defaultLabelColor,
              onTap: () => Navigator.pushNamed(
                context,
                SecurityView.routeName,
              ),
            ),
            const SizedBox(height: 25),
            ProfileSettingsRowItem(
              iconAssetPath: Assets.imagesLanguageIcon,
              label: 'Language',
              textColor: _defaultLabelColor,
              onTap: () => Navigator.pushNamed(
                context,
                LanguageView.routeName,
              ),
            ),
            const SizedBox(height: 25),
            ProfileSettingsRowItem(
              iconAssetPath: Assets.imagesLogoutIcon,
              label: 'Logout',
              textColor: _logoutLabelColor,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
