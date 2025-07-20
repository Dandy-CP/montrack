import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key, required this.tabIndex, required this.onTabChange});

  final int tabIndex;
  final void Function(int) onTabChange;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: tabIndex,
      indicatorColor: Color(0xFF3077E3),
      onDestinationSelected: (value) {
        onTabChange(value);
      },
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_filled, color: Colors.white),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore, color: Colors.white),
          label: 'Budgeting',
        ),
        NavigationDestination(
          icon: Icon(Icons.flag_outlined),
          selectedIcon: Icon(Icons.flag, color: Colors.white),
          label: 'Goals',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person, color: Colors.white),
          label: 'Profile',
        ),
      ],
    );
  }
}
