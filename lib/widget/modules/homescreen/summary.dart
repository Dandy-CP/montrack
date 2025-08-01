import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/models/wallet/active_wallet_model.dart';
import 'package:montrack/service/api/wallet_api.dart';
import 'package:montrack/utils/formated_currency.dart';
import 'package:montrack/widget/elements/skeleton.dart';
import 'package:montrack/widget/modules/homescreen/summary_card.dart';

class Summary extends ConsumerWidget {
  const Summary({super.key, required this.onTabChange});

  final void Function(int) onTabChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ActiveWalletResponse> activeWallet = ref.watch(
      getActiveWalletProvider,
    );

    final AsyncValue<int> income = activeWallet.whenData(
      (value) => value.data.summary.income,
    );

    final AsyncValue<int> expense = activeWallet.whenData(
      (value) => value.data.summary.expense,
    );

    final AsyncValue<int> pocketLength = activeWallet.whenData(
      (value) => value.data.userPocket.length,
    );

    final AsyncValue<int> goalsLength = activeWallet.whenData(
      (value) => value.data.userGoals.length,
    );

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
              SummaryCard(
                label: 'Income',
                emoji: '📉',
                onTap: () => context.push('/income'),
                value: income.when(
                  data: (value) => Text(
                    formattedCurrency(value),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  error: (error, stack) => SkeletonBox(width: 100, height: 20),
                  loading: () => SkeletonBox(width: 100, height: 20),
                  skipLoadingOnRefresh: false,
                ),
              ),

              SummaryCard(
                label: 'Expense',
                emoji: '📈',
                onTap: () => context.push('/expense'),
                value: expense.when(
                  data: (value) => Text(
                    formattedCurrency(value),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  error: (error, stack) => SkeletonBox(width: 100, height: 20),
                  loading: () => SkeletonBox(width: 100, height: 20),
                  skipLoadingOnRefresh: false,
                ),
              ),

              SummaryCard(
                label: 'Pockets',
                emoji: '💰',
                onTap: () => onTabChange(1),
                value: pocketLength.when(
                  data: (value) => Text(
                    '$value',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  error: (error, stack) => SkeletonBox(width: 100, height: 20),
                  loading: () => SkeletonBox(width: 100, height: 20),
                  skipLoadingOnRefresh: false,
                ),
              ),

              SummaryCard(
                label: 'Goals',
                emoji: '🎯',
                onTap: () => onTabChange(2),
                value: goalsLength.when(
                  data: (value) => Text(
                    '$value',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  error: (error, stack) => SkeletonBox(width: 100, height: 20),
                  loading: () => SkeletonBox(width: 100, height: 20),
                  skipLoadingOnRefresh: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
