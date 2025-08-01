import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/config/router.dart';
import 'package:montrack/config/theme.dart';
import 'package:montrack/providers/provider_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(ProviderScope(observers: [ProviderObservers()], child: Index()));
}

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Montrack',
      theme: themeConfig,
      routerConfig: router,
    );
  }
}
