import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/service/api/auth_api.dart';

class Root extends ConsumerStatefulWidget {
  const Root({super.key});

  @override
  RootState createState() => RootState();
}

class RootState extends ConsumerState<Root> {
  @override
  void initState() {
    super.initState();

    // init startup app with checking authorization
    ref.read(initialStartUpProvider);
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
