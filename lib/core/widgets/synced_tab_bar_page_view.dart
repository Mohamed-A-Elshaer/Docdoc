import 'package:docdoc/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

/// [TabBar] and [PageView] kept in sync (same pattern as [AboutDoctorViewBody]).
class SyncedTabBarPageView extends StatefulWidget {
  const SyncedTabBarPageView({
    super.key,
    required this.tabLabels,
    required this.pageBuilder,
  });

  final List<String> tabLabels;
  final Widget Function(BuildContext context, int index) pageBuilder;

  @override
  State<SyncedTabBarPageView> createState() => _SyncedTabBarPageViewState();
}

class _SyncedTabBarPageViewState extends State<SyncedTabBarPageView>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final TabController _tabController;
  var _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(
      length: widget.tabLabels.length,
      vsync: this,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && !_isSyncing) {
        _isSyncing = true;
        _pageController
            .animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        )
            .then((_) {
          if (mounted) _isSyncing = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryColor,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: const Color(0xff9E9E9E),
          indicatorWeight: 3,
          tabs: widget.tabLabels.map((t) => Tab(text: t)).toList(),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              if (!_isSyncing && _tabController.index != index) {
                _isSyncing = true;
                _tabController.animateTo(index);
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted) _isSyncing = false;
                });
              }
            },
            itemCount: widget.tabLabels.length,
            itemBuilder: (context, index) => widget.pageBuilder(context, index),
          ),
        ),
      ],
    );
  }
}
