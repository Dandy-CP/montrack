import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/models/transaction/transaction_model.dart';
import 'package:montrack/service/api/transaction_api.dart';
import 'package:montrack/utils/get_date.dart';
import 'package:montrack/widget/elements/date_range_picker.dart';
import 'package:montrack/widget/elements/skeleton.dart';
import 'package:montrack/widget/modules/empty_state.dart';
import 'package:montrack/widget/modules/homescreen/trx_card.dart';

class RecentTrx extends ConsumerStatefulWidget {
  const RecentTrx({super.key});

  @override
  ConsumerState<RecentTrx> createState() => _RecentTrxState();
}

class _RecentTrxState extends ConsumerState<RecentTrx> {
  DateTimeRange? selectedDateRange;
  String? startDate;
  String? endDate;
  String selectedFilter = 'All Time';

  @override
  Widget build(BuildContext context) {
    final AsyncValue<TransactionListResponse> transaction = ref.watch(
      transactionListRequestProvider(
        query: TransactionQuery(startDate: startDate, endDate: endDate),
      ),
    );

    Widget trxWidgetList() {
      return transaction.when(
        skipLoadingOnRefresh: false,
        data: (value) {
          if (value.data.isEmpty) {
            return SizedBox(
              height: 200,
              child: EmptyState(
                message:
                    'No transaction yet for now, please click the " + " to create a new transaction.',
              ),
            );
          }

          return Column(
            spacing: 15,
            children: value.data.map((trx) {
              return TrxCard(
                trxName: trx.transactionName,
                trxAmount: trx.transactionAmmount,
                trxType: trx.transactionType,
                trxDate: trx.transactionDate,
              );
            }).toList(),
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
        trxWidgetList(),
      ],
    );
  }
}
