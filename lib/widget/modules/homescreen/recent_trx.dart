import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/models/transaction/transaction_model.dart';
import 'package:montrack/service/api/transaction_api.dart';
import 'package:montrack/widget/elements/skeleton.dart';
import 'package:montrack/widget/modules/homescreen/trx_card.dart';

class RecentTrx extends ConsumerWidget {
  const RecentTrx({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<TransactionListResponse> transaction = ref.watch(
      getTransactionListProvider((page: 1, limit: 5)),
    );

    Widget trxWidgetList() {
      return transaction.when(
        skipLoadingOnRefresh: false,
        data: (value) => Column(
          spacing: 15,
          children: value.data.map((trx) {
            return TrxCard(
              trxName: trx.transactionName,
              trxAmount: trx.transactionAmmount,
              trxType: trx.transactionType,
              trxDate: trx.transactionDate,
            );
          }).toList(),
        ),
        error: (err, stack) => Column(
          spacing: 15,
          children: List.generate(5, (_) {}).map((_) {
            return SkeletonBox(width: double.infinity, height: 100);
          }).toList(),
        ),
        loading: () => Column(
          spacing: 15,
          children: List.generate(5, (_) {}).map((_) {
            return SkeletonBox(width: double.infinity, height: 100);
          }).toList(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 25,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transaction',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text('All', style: TextStyle(fontSize: 16)),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ],
        ),
        trxWidgetList(),
      ],
    );
  }
}
