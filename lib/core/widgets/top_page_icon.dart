import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class TopPageIcon extends StatelessWidget {
  final ScrollController scrollController;

  const TopPageIcon({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null, // important when reused across pages
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      shape: const CircleBorder(), // force perfect circle
      onPressed: () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
      child: const Icon(
        CupertinoIcons.up_arrow,
        size: 22,
      ),
    );
  }
}
