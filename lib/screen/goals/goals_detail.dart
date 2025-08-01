import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/widget/modules/app_bar.dart';

class GoalsDetailScreen extends StatelessWidget {
  const GoalsDetailScreen({super.key, required this.goalsId});

  final String goalsId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Goals Details',
        showLeading: true,
        onBack: () {
          context.pop();
        },
      ),
      body: Column(children: [Text('Goals Detail Screen $goalsId')]),
    );
  }
}
