import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
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
