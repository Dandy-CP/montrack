import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/models/pocket/pocket_detail_model.dart';
import 'package:montrack/models/transaction/transaction_model.dart';
import 'package:montrack/service/api/pocket_api.dart';
import 'package:montrack/utils/formated_currency.dart';
import 'package:montrack/widget/elements/skeleton.dart';
import 'package:montrack/widget/modules/app_bar.dart';
import 'package:montrack/widget/modules/empty_state.dart';
import 'package:montrack/widget/modules/homescreen/trx_card.dart';

class PocketDetailScreen extends ConsumerWidget {
  const PocketDetailScreen({super.key, required this.pocketId});

  final String pocketId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PocketDetailResponse> pocket = ref.watch(
      getPocketDetailProvider(pocketId),
    );

    final AsyncValue<List<TransactionListData>> transactionList = pocket
        .whenData((value) => value.data.pocketHistory);

    Future<void> handleOnRefresh() async {
      ref.invalidate(getPocketDetailProvider(pocketId));
    }

    Widget pocketDetailCard() {
      return pocket.when(
        skipLoadingOnRefresh: false,
        data: (value) {
          return Container(
            width: double.infinity,
            padding: EdgeInsetsGeometry.all(18),
            decoration: BoxDecoration(
              color: Color(0xFFCCE1FF),
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
              spacing: 10,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Text(
                      value.data.pocketEmoji,
                      style: TextStyle(fontSize: 40),
                    ),
                    Text(
                      value.data.pocketName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                Row(
                  spacing: 5,
                  children: [
                    Text(
                      formattedCurrency(value.data.pocketAmmount),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '/',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      formattedCurrency(value.data.pocketSetAmount),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  value.data.pocketDescription,
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                LinearProgressIndicator(
                  color: Color(0xFF3077E3),
                  value: 0.5,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: Colors.grey.shade200,
                ),
              ],
            ),
          );
        },
        error: (err, stack) => SkeletonBox(width: double.infinity, height: 180),
        loading: () => SkeletonBox(width: double.infinity, height: 180),
      );
    }

    Widget trxList() {
      return transactionList.when(
        skipLoadingOnRefresh: false,
        data: (value) {
          if (value.isEmpty) {
            return SizedBox(
              width: double.infinity,
              child: EmptyState(message: 'No transaction yet for now'),
            );
          }

          return Column(
            children: value
                .map(
                  (value) => TrxCard(
                    trxName: value.transactionName,
                    trxAmount: value.transactionAmmount,
                    trxType: value.transactionType,
                    trxDate: value.transactionDate,
                    cardColor: 0xFFFFFFFF,
                    showShadow: true,
                  ),
                )
                .toList(),
          );
        },
        error: (err, stack) => Column(
          spacing: 15,
          children: List.generate(3, (_) {}).map((_) {
            return SkeletonBox(width: double.infinity, height: 100);
          }).toList(),
        ),
        loading: () => Column(
          spacing: 15,
          children: List.generate(3, (_) {}).map((_) {
            return SkeletonBox(width: double.infinity, height: 100);
          }).toList(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Pocket Details',
        showLeading: true,
        onBack: () {
          context.pop();
        },
      ),
      body: RefreshIndicator(
        onRefresh: () => handleOnRefresh(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsetsGeometry.directional(top: 20, start: 15, end: 15),
          child: Column(
            spacing: 20,
            children: [
              pocketDetailCard(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Text(
                    'Transaction History',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  trxList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
