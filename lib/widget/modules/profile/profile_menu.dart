import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/providers/storage/secure_storage_provider.dart';
import 'package:montrack/widget/elements/button.dart';

class ProfileMenu extends ConsumerWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(secureStorageProvider);

    void handleLogout() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure to Log Out?'),
          content: Text('Your wil log out from your account.'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            Button(
              label: 'No',
              variant: 'outlined',
              width: 130,
              onPressed: () => Navigator.pop(context),
            ),
            Button(
              label: 'Yes',
              width: 130,
              onPressed: () async => {
                await storage.delete('access_token'),
                await storage.delete('refresh_token'),

                if (context.mounted) context.go('/login'),
              },
            ),
          ],
        ),
      );
    }

    final List<Widget> profileMenu = [
      InkWell(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Language',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'About Us',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Help Center',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () {
          handleLogout();
        },
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Log Out',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsetsGeometry.all(0),
          itemCount: profileMenu.length,
          itemBuilder: (BuildContext context, int index) {
            return profileMenu[index];
          },
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 13),
        ),
      ],
    );
  }
}
