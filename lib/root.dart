import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/providers/storage/secure_storage_provider.dart';
import 'package:montrack/providers/storage/shared_prefs_provider.dart';

class Root extends ConsumerStatefulWidget {
  const Root({super.key});

  @override
  RootState createState() => RootState();
}

class RootState extends ConsumerState<Root> {
  Future<Timer> handleInitialStartUp() async {
    // get token value and any prefs value
    final tokenValue = await ref
        .watch(secureStorageProvider)
        .get('access_token');

    final bool? isHasOnBoarding = await ref
        .watch(sharedPrefsProvider)
        .getBool('hasOnBoarding');

    // Set timeout 5 second to show splash screen
    // then replace screen on each meet condition
    // TODO: Make function to handle check token validation over backend
    return Timer(const Duration(seconds: 5), () {
      if (tokenValue != null) {
        context.replace('/home');
        return;
      }

      if (isHasOnBoarding != null && isHasOnBoarding) {
        context.replace('/login');
        return;
      }

      context.replace('/onboarding');
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => handleInitialStartUp());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          Image.asset(
            'assets/images/MontrackLogo.png',
            width: double.infinity,
            height: 50,
          ),

          CircularProgressIndicator(color: Color(0xFF3077E3)),
        ],
      ),
    );
  }
}
