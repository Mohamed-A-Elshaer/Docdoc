import 'dart:io';

import 'package:docdoc/core/utils/app_colors.dart';
import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/features/auth/presentation/views/widgets/social_login_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_text_styles.dart';
import '../../cubits/signin_cubits/signin_cubit.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter(
      {super.key,
      required this.text1,
      required this.text2,
      required this.text3,
      this.gestureRecognizer});

  final String text1;
  final String text2;
  final String text3;
  final GestureRecognizer? gestureRecognizer;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Row(
          children: [
            const Expanded(
              child: Divider(
                color: Color(0xFFE0E0E0),
                thickness: 1,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "Or sign in with",
              style:
                  TextStyles.regular12.copyWith(color: const Color(0xff9E9E9E)),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Divider(
                color: Color(0xFFE0E0E0),
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 35,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialLoginButton(
              imageName: Assets.imagesGoogleLogo,
              height: 34,
              onTap: () {
                context.read<SigninCubit>().signInWithGoogle();
              },
            ),
            const SizedBox(
              width: 35,
            ),
            SocialLoginButton(
              imageName: Assets.imagesFacebookLogo,
              height: 36,
              onTap: () {
                context.read<SigninCubit>().signInWithFacebook();
              },
            ),
            const SizedBox(
              width: 35,
            ),
            Platform.isIOS
                ? SocialLoginButton(
                    imageName: Assets.imagesAppleLogo,
                    height: 31,
                    onTap: () {},
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(
          height: 35,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              style:
                  TextStyles.regular12.copyWith(color: const Color(0xff9E9E9E)),
              children: [
                TextSpan(text: text1),
                TextSpan(
                  text: "Terms & Conditions ",
                  style: TextStyles.medium12
                      .copyWith(color: const Color(0xff242424)),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: "and "),
                TextSpan(
                  text: "PrivacyPolicy.",
                  style: TextStyles.medium12
                      .copyWith(color: const Color(0xff242424)),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                )
              ]),
        ),
        const SizedBox(
          height: 25,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              style:
                  TextStyles.regular12.copyWith(color: const Color(0xff242424)),
              children: [
                TextSpan(text: text2),
                TextSpan(
                  text: text3,
                  style: TextStyles.semiBold12
                      .copyWith(color: AppColors.primaryColor),
                  recognizer: gestureRecognizer,
                ),
              ]),
        ),
      ],
    );
  }
}
