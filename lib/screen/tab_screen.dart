import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/screen/goals/goals.dart';
import 'package:montrack/screen/homescreen.dart';
import 'package:montrack/screen/pocket/pocket.dart';
import 'package:montrack/screen/profile/profile.dart';
import 'package:montrack/widget/modules/app_bar.dart';
import 'package:montrack/widget/modules/navbar.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _tabIndex = 0;

  void onTabChange(int tabValue) {
    setState(() {
      _tabIndex = tabValue;
    });
  }

  void onActionButtonTap() {
    if (_tabIndex == 0) context.push('/create-transaction');
    if (_tabIndex == 1) context.push('/pocket/create');
    if (_tabIndex == 2) context.push('/goals/create');
  }

  AppBarWidget? renderAppBar() {
    if (_tabIndex != 0) {
      if (_tabIndex == 1) return AppBarWidget(title: 'Pocket');
      if (_tabIndex == 2) return AppBarWidget(title: 'Goals');
      if (_tabIndex == 3) return AppBarWidget(title: 'Profile');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screen = [
      Homescreen(onTabChange: onTabChange),
      PocketScreen(),
      GoalsScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: EdgeInsetsGeometry.directional(bottom: 20),
        child: screen[_tabIndex],
      ),
      appBar: renderAppBar(),
      bottomNavigationBar: Navbar(
        tabIndex: _tabIndex,
        onTabChange: onTabChange,
      ),
      floatingActionButton: _tabIndex != 3
          ? FloatingActionButton(
              backgroundColor: Color(0xFF3077E3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () => onActionButtonTap(),
              child: Icon(Icons.add, color: Colors.white, size: 28),
            )
          : null,
    );
  }
}
