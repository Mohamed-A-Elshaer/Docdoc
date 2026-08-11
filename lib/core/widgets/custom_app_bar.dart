import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final void Function()? onTap;
  final void Function()? onActionTap;
  final double leftPadding;
  final bool showLeading;
  final bool showAction;
  final IconData actionIcon;
  const CustomAppBar({
    super.key,
    required this.title,
    this.onTap,
    this.onActionTap,
    required this.leftPadding,
    this.showLeading = true,
    this.showAction = false,
    this.actionIcon = CupertinoIcons.barcode_viewfinder,
  });

  @override
  Size get preferredSize => const Size.fromHeight(78);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 78,
      leadingWidth: showLeading ? 78 : 0,
      leading: showLeading
          ? GestureDetector(
              onTap: onTap,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: const Color(0xffEDEDED), width: 1),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(CupertinoIcons.back,
                      color: Colors.black, size: 24),
                ),
              ),
            )
          : const SizedBox.shrink(),
      title: Padding(
        padding: EdgeInsets.only(left: leftPadding),
        child: Text(
          title,
          style: TextStyles.semiBold18.copyWith(color: const Color(0xff242424)),
        ),
      ),
      actions: showAction
          ? [
              GestureDetector(
                onTap: onActionTap,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: const Color(0xffEDEDED), width: 1),
                    ),
                    alignment: Alignment.center,
                    child: Icon(actionIcon, color: Colors.black, size: 24),
                  ),
                ),
              ),
            ]
          : null,
    );
  }
}
