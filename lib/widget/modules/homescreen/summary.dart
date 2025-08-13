import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/models/transaction/transaction_model.dart';
import 'package:montrack/models/wallet/active_wallet_model.dart';
import 'package:montrack/service/api/transaction_api.dart';
import 'package:montrack/service/api/wallet_api.dart';
import 'package:montrack/utils/formated_currency.dart';
import 'package:montrack/utils/get_date.dart';
import 'package:montrack/widget/elements/date_range_picker.dart';
import 'package:montrack/widget/elements/skeleton.dart';
import 'package:montrack/widget/modules/homescreen/summary_card.dart';

class Summary extends ConsumerStatefulWidget {
  const Summary({super.key, required this.onTabChange});

  final void Function(int) onTabChange;

  @override
  ConsumerState<Summary> createState() => _SummaryState();
}

class _SummaryState extends ConsumerState<Summary> {
  DateTimeRange? selectedDateRange;
  String? startDate;
  String? endDate;
  String selectedFilter = 'All Time';

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ActiveWalletResponse> activeWallet = ref.watch(
      getActiveWalletProvider,
    );

    final AsyncValue<TransactionSummaryResponse> summary = ref.watch(
      getTransactionSummaryProvider(startDate: startDate, endDate: endDate),
    );

    final AsyncValue<int> income = summary.whenData(
      (value) => value.data.income,
    );

    final AsyncValue<int> expense = summary.whenData(
      (value) => value.data.expense,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            PopupMenuButton(
              icon: Row(
                children: [
                  Text(selectedFilter, style: TextStyle(fontSize: 16)),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  value: 0,
                  child: Text('All Time'),
                  onTap: () {
                    setState(() {
                      selectedFilter = 'All Time';
                      selectedDateRange = null;
                      startDate = null;
                      endDate = null;
                    });
                  },
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text('This Week'),
                  onTap: () => GetDate.thisWeek(
                    onSelected: (value) {
                      setState(() {
                        selectedFilter = 'This Week';
                        startDate = value['startDate'].toString().split(' ')[0];
                        endDate = value['endDate'].toString().split(' ')[0];
                      });
                    },
                  ),
                ),
                PopupMenuItem(
                  value: 0,
                  child: Text('This Month'),
                  onTap: () => GetDate.thisMonth(
                    onSelected: (value) {
                      setState(() {
                        selectedFilter = 'This Month';
                        startDate = value['startDate'].toString().split(' ')[0];
                        endDate = value['endDate'].toString().split(' ')[0];
                      });
                    },
                  ),
                ),
                PopupMenuItem(
                  value: 0,
                  child: Text('Custom Date'),
                  onTap: () => DateRangePicker.show(
                    context: context,
                    selectedDateRange: selectedDateRange,
                    onDatePicked: (value) {
                      setState(() {
                        selectedDateRange = value;
                        startDate = value.start.toString().split(' ')[0];
                        endDate = value.end.toString().split(' ')[0];
                        selectedFilter = 'Custom Date';
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
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
                onTap: () => context.push(
                  Uri(
                    path: '/spending',
                    queryParameters: {'transactionType': 'INCOME'},
                  ).toString(),
                ),
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
                onTap: () => context.push(
                  Uri(
                    path: '/spending',
                    queryParameters: {'transactionType': 'EXPENSE'},
                  ).toString(),
                ),
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
                onTap: () => widget.onTabChange(1),
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
                onTap: () => widget.onTabChange(2),
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
