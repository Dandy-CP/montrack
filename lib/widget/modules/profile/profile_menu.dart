import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/providers/provider_observer.dart';
import 'package:montrack/service/api/auth_api.dart';
import 'package:montrack/widget/elements/dialog.dart';
import 'package:montrack/widget/elements/snackbar.dart';

class ProfileMenu extends ConsumerStatefulWidget {
  const ProfileMenu({super.key});

  @override
  ConsumerState<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends ConsumerState<ProfileMenu> {
  bool isPending = false;

  @override
  Widget build(BuildContext context) {
    final authRequest = ref.watch(authProvider.notifier);

    void handleLogout() async {
      setState(() {
        isPending = true;
      });

      try {
        final response = await authRequest.signOut();

        if (response != null) {
          if (context.mounted) {
            context.go('/login');

            SnackBars.show(
              context: context,
              message: 'You have been logged out',
            );
          }

          // Invalidate all providers when success logout
          ProviderObservers.invalidateAllProviders(ref);
        }
      } on DioException catch (error) {
        if (context.mounted) {
          SnackBars.show(
            context: context,
            message:
                '${error.response?.data['message'] ?? 'Ops Something Wrong'}',
            type: SnackBarsVariant.error,
          );
        }
      } finally {
        setState(() {
          isPending = false;
        });
      }
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
          Dialogs.show(
            context: context,
            title: 'Are you sure to Log Out?',
            content: 'Your wil log out from your account.',
            onYesPressed: () {
              handleLogout();
            },
          );
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
