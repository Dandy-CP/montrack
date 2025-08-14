import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/models/goals/goals_list_model.dart';
import 'package:montrack/service/api/goals_api.dart';
import 'package:montrack/widget/elements/skeleton.dart';
import 'package:montrack/widget/modules/empty_state.dart';
import 'package:montrack/widget/modules/error_view.dart';
import 'package:montrack/widget/modules/goals/goal_card.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GoalsListResponse> goalsList = ref.watch(
      getListGoalsProvider(page: 1, limit: 10),
    );

    Future<void> handleOnRefresh() async {
      ref.invalidate(getListGoalsProvider(page: 1, limit: 10));
    }

    Widget listWidgetGoals() {
      return goalsList.when(
        skipLoadingOnRefresh: false,
        data: (value) {
          if (value.data.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 230,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmptyState(
                    message:
                        'No goals yet for now, please click the " + " to create a new goal.',
                  ),
                ],
              ),
            );
          }

          return Column(
            spacing: 15,
            children: value.data
                .map(
                  (data) => GoalsCard(
                    goalsId: data.goalsId,
                    label: data.goalsName,
                    initialAmount: data.goalsSetAmount,
                    moneyValue: data.goalsAmount,
                    description: data.goalsDescription,
                    progress: data.goalsAmount / data.goalsSetAmount,
                  ),
                )
                .toList(),
          );
        },
        error: (error, trace) => ErrorView(onTap: () => handleOnRefresh()),
        loading: () => Column(
          spacing: 15,
          children: List.generate(5, (_) {}).map((_) {
            return SkeletonBox(width: double.infinity, height: 150);
          }).toList(),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => handleOnRefresh(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsGeometry.directional(
          top: 20,
          start: 15,
          end: 15,
          bottom: 150,
        ),
        child: Column(spacing: 10, children: [listWidgetGoals()]),
      ),
    );
  }
}
