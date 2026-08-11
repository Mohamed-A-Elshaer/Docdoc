import 'package:docdoc/core/widgets/custom_app_bar.dart';
import 'package:docdoc/features/profile/presentation/views/widgets/profile_settings_row_item.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  static const String routeName = 'notification';

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  static const Color _labelColor = Color(0xff242424);

  bool _docDocNotifications = true;
  bool _sound = true;
  bool _vibrate = true;
  bool _appUpdates = false;
  bool _specialOffers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notification',
        leftPadding: 65,
        onTap: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            ProfileSettingsRowItem(
              useSwitchRow: true,
              label: 'Notification from DocDoc',
              textColor: _labelColor,
              switchValue: _docDocNotifications,
              onSwitchChanged: (v) => setState(() => _docDocNotifications = v),
            ),
            const SizedBox(height: 20),
            ProfileSettingsRowItem(
              useSwitchRow: true,
              label: 'Sound',
              textColor: _labelColor,
              switchValue: _sound,
              onSwitchChanged: (v) => setState(() => _sound = v),
            ),
            const SizedBox(height: 20),
            ProfileSettingsRowItem(
              useSwitchRow: true,
              label: 'Vibrate',
              textColor: _labelColor,
              switchValue: _vibrate,
              onSwitchChanged: (v) => setState(() => _vibrate = v),
            ),
            const SizedBox(height: 20),
            ProfileSettingsRowItem(
              useSwitchRow: true,
              label: 'App Updates',
              textColor: _labelColor,
              switchValue: _appUpdates,
              onSwitchChanged: (v) => setState(() => _appUpdates = v),
            ),
            const SizedBox(height: 20),
            ProfileSettingsRowItem(
              useSwitchRow: true,
              label: 'Special Offers',
              textColor: _labelColor,
              switchValue: _specialOffers,
              onSwitchChanged: (v) => setState(() => _specialOffers = v),
            ),
          ],
        ),
      ),
    );
  }
}
