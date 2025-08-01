import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/models/transaction/transaction_model.dart';
import 'package:montrack/service/api/transaction_api.dart';
import 'package:montrack/widget/elements/skeleton.dart';
import 'package:montrack/widget/modules/app_bar.dart';
import 'package:montrack/widget/modules/empty_state.dart';
import 'package:montrack/widget/modules/homescreen/trx_card.dart';

class ExpenseScreen extends ConsumerWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<TransactionListResponse> transactionData = ref.watch(
      transactionListRequestProvider(
        query: TransactionQuery(transactionType: 'EXPENSE'),
      ),
    );

    final TransactionListRequest transactionRequest = ref.watch(
      transactionListRequestProvider(
        query: TransactionQuery(transactionType: 'EXPENSE'),
      ).notifier,
    );

    Future<void> handleOnRefresh() async {
      ref.invalidate(transactionListRequestProvider);
    }

    Widget renderTrxWidgetList() {
      return transactionData.when(
        data: (value) {
          return Column(
            spacing: 15,
            children: [
              Column(
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

              if (value.data.isEmpty) EmptyState(message: 'No transaction yet'),

              if (!value.meta.isLastPage && value.data.length <= 10)
                Column(
                  spacing: 15,
                  children: List.generate(2, (_) {}).map((_) {
                    return SkeletonBox(width: double.infinity, height: 100);
                  }).toList(),
                ),
            ],
          );
        },
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

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Expense',
        showLeading: true,
        onBack: () {
          context.pop();
        },
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          double currentPosition = scrollInfo.metrics.pixels;
          double maxScrollPosition = scrollInfo.metrics.maxScrollExtent;

          if (currentPosition == maxScrollPosition) {
            transactionRequest.loadNextPage();
          }

          return false;
        },
        child: RefreshIndicator(
          onRefresh: () => handleOnRefresh(),
          child: SingleChildScrollView(
            padding: EdgeInsetsGeometry.directional(bottom: 20),
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsetsGeometry.directional(
                top: 20,
                start: 20,
                end: 20,
              ),
              child: Column(
                spacing: 20,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text('All', style: TextStyle(fontSize: 16)),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ],
                  ),
                  renderTrxWidgetList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
