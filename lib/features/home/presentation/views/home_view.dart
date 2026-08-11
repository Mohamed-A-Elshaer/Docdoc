import 'package:docdoc/features/home/presentation/views/widgets/home_view_body.dart';
import 'package:docdoc/features/home/presentation/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:docdoc/features/my_appointments/presentation/views/widgets/my_appointments_view_body.dart';
import 'package:docdoc/features/profile/presentation/views/profile_view.dart';
import 'package:docdoc/features/search/presentation/views/widgets/search_view_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const routeName = 'home';
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  bool _isSearchActive = false;

  void _onItemSelected(int index) {
    setState(() {
      _isSearchActive = false;
      _selectedIndex = index;
    });
  }

  void _onSearchTap() {
    setState(() {
      _isSearchActive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeViewBody(),
      const _MainTabPlaceholder(title: 'Messages'),
      const MyAppointmentsViewBody(showBackButton: false),
      const ProfileView(),
    ];

    return Scaffold(
      body: _isSearchActive
          ? const SearchViewBody(showBackButton: false, useInTabShell: true)
          : IndexedStack(
              index: _selectedIndex,
              children: pages,
            ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        onSearchTap: _onSearchTap,
        isSearchActive: _isSearchActive,
      ),
    );
  }
}

class _MainTabPlaceholder extends StatelessWidget {
  const _MainTabPlaceholder({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text('$title feature is coming soon'),
      ),
    );
  }
}
