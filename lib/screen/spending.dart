import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/models/transaction/transaction_model.dart';
import 'package:montrack/service/api/transaction_api.dart';
import 'package:montrack/utils/get_date.dart';
import 'package:montrack/widget/elements/date_range_picker.dart';
import 'package:montrack/widget/elements/skeleton.dart';
import 'package:montrack/widget/modules/app_bar.dart';
import 'package:montrack/widget/modules/empty_state.dart';
import 'package:montrack/widget/modules/homescreen/trx_card.dart';

class SpendingScreen extends ConsumerStatefulWidget {
  const SpendingScreen({super.key, required this.transactionType});

  final String transactionType;

  @override
  ConsumerState<SpendingScreen> createState() => _SpendingScreenState();
}

class _SpendingScreenState extends ConsumerState<SpendingScreen> {
  DateTimeRange? selectedDateRange;
  String? startDate;
  String? endDate;
  String selectedFilter = 'All Time';

  @override
  Widget build(BuildContext context) {
    final AsyncValue<TransactionListResponse> transactionData = ref.watch(
      transactionListRequestProvider(
        query: TransactionQuery(
          transactionType: widget.transactionType,
          startDate: startDate,
          endDate: endDate,
        ),
      ),
    );

    final TransactionListRequest transactionRequest = ref.watch(
      transactionListRequestProvider(
        query: TransactionQuery(
          transactionType: widget.transactionType,
          startDate: startDate,
          endDate: endDate,
        ),
      ).notifier,
    );

    Future<void> handleOnRefresh() async {
      ref.invalidate(
        transactionListRequestProvider(
          query: TransactionQuery(
            transactionType: widget.transactionType,
            startDate: startDate,
            endDate: endDate,
          ),
        ),
      );
    }

    Widget renderTrxWidgetList() {
      return transactionData.when(
        skipLoadingOnRefresh: false,
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

              if (!value.meta.isLastPage)
                Column(
                  spacing: 15,
                  children: List.generate(2, (_) {}).map((_) {
                    return SkeletonBox(width: double.infinity, height: 100);
                  }).toList(),
                ),

              if (value.meta.isLastPage && value.data.length > 10)
                Text(
                  'End of transaction',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
            ],
          );
        },
        error: (err, stack) => Column(
          spacing: 15,
          children: List.generate(10, (_) {}).map((_) {
            return SkeletonBox(width: double.infinity, height: 100);
          }).toList(),
        ),
        loading: () => Column(
          spacing: 15,
          children: List.generate(10, (_) {}).map((_) {
            return SkeletonBox(width: double.infinity, height: 100);
          }).toList(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBarWidget(
        title:
            widget.transactionType.split('')[0].toUpperCase() +
            widget.transactionType.substring(1).toLowerCase(),
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
                      PopupMenuButton(
                        icon: Row(
                          children: [
                            Text(
                              selectedFilter,
                              style: TextStyle(fontSize: 16),
                            ),
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
                                  startDate = value['startDate']
                                      .toString()
                                      .split(' ')[0];
                                  endDate = value['endDate'].toString().split(
                                    ' ',
                                  )[0];
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
                                  startDate = value['startDate']
                                      .toString()
                                      .split(' ')[0];
                                  endDate = value['endDate'].toString().split(
                                    ' ',
                                  )[0];
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
                                  startDate = value.start.toString().split(
                                    ' ',
                                  )[0];
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
