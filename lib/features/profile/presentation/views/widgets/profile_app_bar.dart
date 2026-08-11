import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key, this.onActionTap});

  final VoidCallback? onActionTap;

  @override
  Size get preferredSize => const Size.fromHeight(78);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      toolbarHeight: 78,
      centerTitle: true,
      title: Text(
        'Profile',
        style: TextStyles.semiBold18.copyWith(color: Colors.white),
      ),
      actions: [
        IconButton(
          onPressed: onActionTap,
          icon: SvgPicture.asset(
            Assets.imagesSettingsProfBtn,
            height: 24,
            width: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
