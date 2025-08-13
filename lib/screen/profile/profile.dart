import 'package:flutter/material.dart';
import 'package:montrack/widget/modules/profile/name_card.dart';
import 'package:montrack/widget/modules/profile/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(spacing: 40, children: [NameCard(), ProfileMenu()]),
          Text('v1.0', style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
