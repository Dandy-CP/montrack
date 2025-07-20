import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/providers/storage/shared_prefs_provider.dart';
import 'package:montrack/widget/elements/button.dart';

class Onboarding extends ConsumerWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsStorage = ref.watch(sharedPrefsProvider);

    void handleUserHasOnBoarding() {
      prefsStorage.setBool('hasOnBoarding', true);
      if (context.mounted) context.go('/login');
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30,
            children: [
              Image.asset('assets/images/MontrackLogo.png', height: 57),
              Text(
                'Hi, welcome to the Montrack. Please click the button below to get started.',
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
              Button(
                label: 'Get Started',
                onPressed: () {
                  handleUserHasOnBoarding();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
