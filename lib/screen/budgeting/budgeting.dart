import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/models/pocket/pocket_list_model.dart';
import 'package:montrack/service/api/pocket_api.dart';
import 'package:montrack/widget/elements/button.dart';
import 'package:montrack/widget/elements/skeleton.dart';
import 'package:montrack/widget/modules/budgeting/budgeting_card.dart';

class BudgetingScreen extends ConsumerWidget {
  const BudgetingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PocketListResponse> pocketList = ref.watch(
      getListPocketProvider((page: 1, limit: 10)),
    );

    Future<void> handleOnRefresh() async {
      ref.invalidate(getListPocketProvider((page: 1, limit: 10)));
    }

    Widget listWidgetPocket() {
      return pocketList.when(
        skipLoadingOnRefresh: false,
        data: (value) => Column(
          spacing: 15,
          children: value.data
              .map(
                (data) => BudgetingCard(
                  label: data.pocketName,
                  moneyValue: data.pocketAmmount,
                  progress: 0.5,
                ),
              )
              .toList(),
        ),
        error: (error, trace) => Column(
          spacing: 15,
          children: List.generate(5, (_) {}).map((_) {
            return SkeletonBox(width: double.infinity, height: 120);
          }).toList(),
        ),
        loading: () => Column(
          spacing: 15,
          children: List.generate(5, (_) {}).map((_) {
            return SkeletonBox(width: double.infinity, height: 120);
          }).toList(),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => handleOnRefresh(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsGeometry.directional(top: 20, start: 15, end: 15),
        child: Column(
          spacing: 10,
          children: [
            listWidgetPocket(),
            Button(
              label: 'Add New Pocket',
              onPressed: () => context.go('/create-pocket'),
            ),
          ],
        ),
      ),
    );
  }
}
