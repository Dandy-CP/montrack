import 'package:flutter/material.dart';
import 'package:montrack/widget/modules/homescreen/summary_card.dart';

class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 25,
      children: [
        Text(
          'Summary',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 10,
            children: [
              SummaryCard(label: 'Income', emoji: '📉'),
              SummaryCard(label: 'Expense', emoji: '📈'),
              SummaryCard(label: 'Pockets', emoji: '💰'),
              SummaryCard(label: 'Goals', emoji: '🎯'),
            ],
          ),
        ),
      ],
    );
  }
}
