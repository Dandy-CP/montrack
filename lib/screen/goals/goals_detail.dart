import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/models/goals/goals_detail_model.dart';
import 'package:montrack/service/api/goals_api.dart';
import 'package:montrack/utils/formated_currency.dart';
import 'package:montrack/widget/elements/skeleton.dart';
import 'package:montrack/widget/modules/app_bar.dart';
import 'package:montrack/widget/modules/empty_state.dart';
import 'package:montrack/widget/modules/homescreen/trx_card.dart';

class GoalsDetailScreen extends ConsumerWidget {
  const GoalsDetailScreen({super.key, required this.goalsId});

  final String goalsId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GoalsDetailResponse> goalsDetail = ref.watch(
      getGoalsDetailProvider(goalsId: goalsId),
    );

    Future<void> handleRefresh() async {
      ref.invalidate(getGoalsDetailProvider(goalsId: goalsId));
    }

    Widget goalsDetailWidget() {
      return goalsDetail.when(
        skipLoadingOnRefresh: false,
        data: (value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            if (value.data.goalsAttachment.isNotEmpty)
              Image.network(
                value.data.goalsAttachment,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 10),
            Text(
              value.data.goalsName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(value.data.goalsDescription),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  formattedCurrency(value.data.goalsAmount),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                LinearProgressIndicator(
                  color: Color(0xFF3077E3),
                  value: value.data.goalsAmount / value.data.goalsSetAmount,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: Colors.grey.shade200,
                ),
                Row(
                  spacing: 3,
                  children: [
                    Text(
                      '${formattedCurrency(value.data.goalsAmount)} of',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${formattedCurrency(value.data.goalsSetAmount)} Reached',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        error: (err, stack) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            SkeletonBox(width: 200, height: 15),
            SkeletonBox(width: 150, height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                SkeletonBox(width: 200, height: 30),
                SkeletonBox(width: double.infinity, height: 15),
                Row(
                  spacing: 3,
                  children: [SkeletonBox(width: 200, height: 15)],
                ),
              ],
            ),
          ],
        ),
        loading: () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            SkeletonBox(width: 200, height: 15),
            SkeletonBox(width: 150, height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                SkeletonBox(width: 200, height: 30),
                SkeletonBox(width: double.infinity, height: 15),
                Row(
                  spacing: 3,
                  children: [SkeletonBox(width: 200, height: 15)],
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget trxList() {
      return goalsDetail.when(
        skipLoadingOnRefresh: false,
        data: (value) {
          if (value.data.goalsHistory.isEmpty) {
            return SizedBox(
              width: double.infinity,
              child: EmptyState(message: 'No transaction yet for now'),
            );
          }

          return Column(
            spacing: 15,
            children: value.data.goalsHistory
                .map(
                  (data) => TrxCard(
                    trxName: data.transactionName,
                    trxAmount: data.transactionAmmount,
                    trxType: data.transactionType,
                    trxDate: data.transactionDate,
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
        title: 'Goals Details',
        showLeading: true,
        onBack: () {
          context.pop();
        },
      ),
      body: RefreshIndicator(
        onRefresh: () => handleRefresh(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsetsGeometry.directional(
            top: 20,
            start: 15,
            end: 15,
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              goalsDetailWidget(),
              SizedBox(height: 20),
              Text(
                'Goal Money Record Activities',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              trxList(),
            ],
          ),
        ),
      ),
    );
  }
}
