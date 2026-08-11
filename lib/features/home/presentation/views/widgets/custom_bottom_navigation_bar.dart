import 'package:docdoc/core/utils/app_colors.dart';
import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/features/home/domain/entities/bottom_navigation_bar_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'navigation_bar_item.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onSearchTap,
    this.isSearchActive = false,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onSearchTap;
  final bool isSearchActive;

  @override
  Widget build(BuildContext context) {
    final items = BottomNavigationBarEntity.bottomNavigationBarItems;
    final middleIndex =
        items.length ~/ 2; // Split items into left and right sides

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 77,
          width: 375,
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: const RoundedRectangleBorder(),
              shadows: [
                BoxShadow(
                    color: const Color(0xff000000).withOpacity(0.05),
                    blurRadius: 30,
                    offset: const Offset(0, -2),
                    spreadRadius: 0)
              ]),
          child: Row(
            children: [
              // Left side items
              ...items.sublist(0, middleIndex).asMap().entries.map((entry) {
                final index = entry.key;
                final e = entry.value;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onItemSelected(index);
                    },
                    child: NavigationBarItem(
                      isSelected: !isSearchActive && selectedIndex == index,
                      bottomNavigationBarEntity: e,
                    ),
                  ),
                );
              }),
              // Spacer for the middle button
              const SizedBox(width: 60),
              // Right side items
              ...items.sublist(middleIndex).asMap().entries.map((entry) {
                final index = entry.key + middleIndex;
                final e = entry.value;
                final isLastItem = index == items.length - 1;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onItemSelected(index);
                    },
                    child: NavigationBarItem(
                      isSelected: !isSearchActive && selectedIndex == index,
                      bottomNavigationBarEntity: e,
                      isPng: isLastItem,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        // Circular button in the middle
        Positioned(
          top: -30, // Extends above the navigation bar
          child: GestureDetector(
            onTap: () {
              onSearchTap();
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(27.92),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      Assets.imagesSearchIcon,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
