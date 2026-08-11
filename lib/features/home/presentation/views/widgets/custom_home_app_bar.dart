import 'package:docdoc/core/services/user_profile_display_notifier.dart';
import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomHomeAppBar extends StatelessWidget {
  const CustomHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final profileNotifier = UserProfileDisplayNotifier.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListenableBuilder(
                listenable: profileNotifier,
                builder: (context, _) {
                  return FutureBuilder<String?>(
                    key: ValueKey(profileNotifier.refreshGeneration),
                    future: profileNotifier.fetchDisplayName(),
                    builder: (context, snapshot) {
                      final name = snapshot.data;
                      final greeting = (name == null) ? 'Hi!' : 'Hi, $name!';
                      return Text(greeting, style: TextStyles.bold18);
                    },
                  );
                },
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'How Are you Today?',
                style: TextStyles.regular11.copyWith(color: Color(0xff616161)),
              ),
            ],
          ),
          const Spacer(),
          CircleAvatar(
            backgroundColor: const Color(0xffF5F5F5),
            radius: 28,
            child: SvgPicture.asset(Assets.imagesNotificationIcon),
          )
        ],
      ),
    );
  }
}
