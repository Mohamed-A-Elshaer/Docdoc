import 'package:docdoc/core/services/user_profile_display_notifier.dart';
import 'package:docdoc/core/utils/app_colors.dart';
import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/core/widgets/custom_pressable_list.dart';
import 'package:docdoc/features/profile/presentation/views/personal_information_view.dart';
import 'package:docdoc/features/profile/presentation/views/settings_view.dart';
import 'package:docdoc/features/profile/presentation/views/medical_record_view.dart';
import 'package:docdoc/features/profile/presentation/views/payment_view.dart';
import 'package:docdoc/features/profile/presentation/views/widgets/profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final profileNotifier = UserProfileDisplayNotifier.instance;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: ProfileAppBar(
        onActionTap: () {
          Navigator.pushNamed(context, SettingsView.routeName);
        },
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 620,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 78),
                      ListenableBuilder(
                        listenable: profileNotifier,
                        builder: (context, _) {
                          return FutureBuilder<Map<String, String>>(
                            key: ValueKey(profileNotifier.refreshGeneration),
                            future: profileNotifier.fetchProfileDisplay(),
                            builder: (context, snapshot) {
                              final data = snapshot.data;
                              final name = data?['name'] ?? '...';
                              final email = data?['email'] ?? '...';
                              return Column(
                                children: [
                                  Text(
                                    name,
                                    style: TextStyles.semiBold20.copyWith(
                                      color: const Color(0xff121212),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    email,
                                    style: TextStyles.regular14.copyWith(
                                      color: const Color(0xff757575),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: 327,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xffF8F8F8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'My Appointment',
                                style: TextStyles.regular12.copyWith(
                                  color: const Color(0xff242424),
                                ),
                              ),
                            ),
                            Container(
                              width: 1.2,
                              height: 40,
                              color: const Color(0xffEDEDED),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                MedicalRecordView.routeName,
                              ),
                              child: Text(
                                'Medical records',
                                style: TextStyles.regular12.copyWith(
                                  color: const Color(0xff242424),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomPressableList(
                        image: Assets.imagesPersonalInfoIcon,
                        text: 'Personal Information',
                        isSelected: false,
                        showSelectionControl: false,
                        onTap: () => Navigator.pushNamed(
                          context,
                          PersonalInformationView.routeName,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomPressableList(
                        image: Assets.imagesMyTestIcon,
                        text: 'My Test & Diagnostic',
                        isSelected: false,
                        showSelectionControl: false,
                        onTap: () => Navigator.pushNamed(
                          context,
                          MedicalRecordView.routeName,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomPressableList(
                        image: Assets.imagesPaymentIcon,
                        text: 'Payment',
                        isSelected: false,
                        showSelectionControl: false,
                        onTap: () => Navigator.pushNamed(
                          context,
                          PaymentView.routeName,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 6),
                        image: const DecorationImage(
                          image: AssetImage(Assets.imagesUserAvatarPlaceholder),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 96,
                      right: 6,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 30.55,
                          height: 30.55,
                          decoration: BoxDecoration(
                            color: const Color(0xffF8F8F8),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            Assets.imagesModifyAvatarIcon,
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
