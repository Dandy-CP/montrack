import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/service/api/transaction_api.dart';
import 'package:montrack/service/api/wallet_api.dart';
import 'package:montrack/widget/modules/homescreen/overview.dart';
import 'package:montrack/widget/modules/homescreen/recent_trx.dart';
import 'package:montrack/widget/modules/homescreen/summary.dart';

class Homescreen extends ConsumerWidget {
  const Homescreen({super.key, required this.onTabChange});

  final void Function(int) onTabChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> handleOnRefresh() async {
      ref.invalidate(getActiveWalletProvider);
      ref.invalidate(transactionListRequestProvider);
      ref.invalidate(getTransactionSummaryProvider);
    }

    return RefreshIndicator(
      onRefresh: () => handleOnRefresh(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Overview(onTabChange: onTabChange),
            Padding(
              padding: EdgeInsetsGeometry.directional(
                top: 20,
                start: 20,
                end: 20,
                bottom: 150,
              ),
              child: Column(
                spacing: 20,
                children: [
                  Summary(onTabChange: onTabChange),
                  RecentTrx(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
