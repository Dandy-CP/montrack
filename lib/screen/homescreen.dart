import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/service/api/transaction_api.dart';
import 'package:montrack/service/api/wallet_api.dart';
import 'package:montrack/widget/modules/homescreen/overview.dart';
import 'package:montrack/widget/modules/homescreen/recent_trx.dart';
import 'package:montrack/widget/modules/homescreen/summary.dart';

class Homescreen extends ConsumerWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> handleOnRefresh() async {
      ref.invalidate(getActiveWalletProvider);
      ref.invalidate(getTransactionListProvider((page: 1, limit: 5)));
    }

    return RefreshIndicator(
      onRefresh: () => handleOnRefresh(),
      child: SingleChildScrollView(
        padding: EdgeInsetsGeometry.directional(bottom: 20),
        child: Column(
          children: [
            Overview(),
            Padding(
              padding: EdgeInsetsGeometry.directional(
                top: 20,
                start: 20,
                end: 20,
              ),
              child: Column(spacing: 20, children: [Summary(), RecentTrx()]),
            ),
          ],
        ),
      ),
    );
  }
}
