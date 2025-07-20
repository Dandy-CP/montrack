import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/models/wallet/active_wallet_model.dart';
import 'package:montrack/service/api/wallet_api.dart';
import 'package:montrack/utils/formated_currency.dart';
import 'package:montrack/widget/elements/skeleton.dart';

class SummaryCard extends ConsumerStatefulWidget {
  const SummaryCard({super.key, required this.label, required this.emoji});

  final String label;
  final String emoji;

  @override
  ConsumerState<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends ConsumerState<SummaryCard> {
  String getSummaryTypeValue(int pocketLength, int goalsLength) {
    switch (widget.label) {
      case 'Income':
        return formattedCurrency(8000000);
      case 'Expense':
        return formattedCurrency(8000000);
      case 'Pockets':
        return '$pocketLength Pocket';
      case 'Goals':
        return '$goalsLength Goals';
    }

    return '0';
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ActiveWalletResponse> activeWallet = ref.watch(
      getActiveWalletProvider,
    );

    Widget summaryValue() {
      return activeWallet.when(
        data: (value) => Text(
          getSummaryTypeValue(
            value.data.userPocket.length,
            value.data.userGoals.length,
          ),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        error: (error, stack) => Text('Error'),
        loading: () => SkeletonBox(width: 100, height: 20),
        skipLoadingOnRefresh: false,
      );
    }

    return Container(
      width: 180,
      height: 136,
      padding: EdgeInsetsGeometry.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(149, 157, 165, 0.2),
            blurRadius: 24,
            spreadRadius: 0,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.emoji, style: TextStyle(fontSize: 30)),
          Text(widget.label, style: TextStyle(fontSize: 15)),
          summaryValue(),
        ],
      ),
    );
  }
}
