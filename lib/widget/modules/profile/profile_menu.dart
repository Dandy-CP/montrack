import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:montrack/models/auth/auth_model.dart';
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
  @override
  Widget build(BuildContext context) {
    final AsyncValue<GetLoggedInUserResponse> user = ref.watch(
      getLoggedUserProvider,
    );
    final authRequest = ref.watch(authProvider.notifier);
    final isHasSetPin = ref.watch(getUserPinStorageProvider);

    void handleLogout() async {
      context.loaderOverlay.show();

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
        if (context.mounted) context.loaderOverlay.hide();
      }
    }

    void handleResetAccount() async {
      context.loaderOverlay.show();

      try {
        final response = await authRequest.resetAccount();

        if (response.statusCode == 201) {
          if (context.mounted) {
            SnackBars.show(context: context, message: 'Success Reset Account');
          }

          // Invalidate all providers when success reset account
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
        if (context.mounted) context.loaderOverlay.hide();
      }
    }

    void handleDeleteAccount() async {
      context.loaderOverlay.show();

      try {
        final response = await authRequest.deleteAccount();

        if (response.statusCode == 201) {
          if (context.mounted) {
            context.go('/login');

            SnackBars.show(context: context, message: 'Success Delete Account');
          }

          // Invalidate all providers when success delete account
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
        if (context.mounted) context.loaderOverlay.hide();
      }
    }

    final List<Widget> profileMenu = [
      InkWell(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        onTap: () => context.push(
          Uri(
            path: '/input-pin',
            queryParameters: {
              'title': isHasSetPin.when(
                data: (value) => value != null
                    ? 'Input your pin to disabled'
                    : 'Please input pin to setup',
                error: (err, stack) => '',
                loading: () => '',
              ),
              'type': isHasSetPin.when(
                data: (value) => value != null ? 'disabled' : 'setup',
                error: (err, stack) => '',
                loading: () => '',
              ),
            },
          ).toString(),
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isHasSetPin.when(
                  data: (value) => value != null ? 'Disable Pin' : 'Setup Pin',
                  error: (err, stack) => '',
                  loading: () => '',
                ),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
      InkWell(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        onTap: () => context.push(
          Uri(
            path: '/2fa',
            queryParameters: {
              'type': user.when(
                data: (value) => value.data.is2FAActive ? 'disabled' : 'setup',
                error: (err, stack) => '',
                loading: () => '',
              ),
            },
          ).toString(),
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user.when(
                  data: (value) =>
                      value.data.is2FAActive ? 'Disable 2FA' : 'Enable 2FA',
                  error: (err, stack) => '',
                  loading: () => '',
                ),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
      InkWell(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        onTap: () {
          Dialogs.show(
            context: context,
            title: 'Are you sure to reset this account?',
            content: 'Your wallet, pocket, and transaction will be deleted',
            onYesPressed: () => handleResetAccount(),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reset Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.red,
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
      InkWell(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        onTap: () {
          Dialogs.show(
            context: context,
            title: 'Are you sure to delete this account?',
            content: 'Your data will be deleted',
            onYesPressed: () => handleDeleteAccount(),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.red,
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
      InkWell(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        onTap: () {
          Dialogs.show(
            context: context,
            title: 'Are you sure to Log Out?',
            content: 'Your will log out from your account.',
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.red,
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    ];

    return ListView.separated(
      shrinkWrap: true,
      itemCount: profileMenu.length,
      itemBuilder: (BuildContext context, int index) {
        return profileMenu[index];
      },
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 10),
    );
  }
}
