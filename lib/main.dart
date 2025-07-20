import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/config/router.dart';
import 'package:montrack/config/theme.dart';

void main() async {
  runApp(ProviderScope(child: Index()));
}

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Montrack',
      theme: themeConfig,
      routerConfig: routerList,
    );
  }
}
