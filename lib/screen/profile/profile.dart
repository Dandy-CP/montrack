import 'package:flutter/material.dart';
import 'package:montrack/widget/modules/profile/name_card.dart';
import 'package:montrack/widget/modules/profile/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(30),
      child: Column(
        spacing: 20,
        children: [
          NameCard(),
          ProfileMenu(),
          Text('v0.1', style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
