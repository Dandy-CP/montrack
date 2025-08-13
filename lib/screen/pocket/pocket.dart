import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/models/pocket/pocket_list_model.dart';
import 'package:montrack/service/api/pocket_api.dart';
import 'package:montrack/widget/elements/skeleton.dart';
import 'package:montrack/widget/modules/empty_state.dart';
import 'package:montrack/widget/modules/error_view.dart';
import 'package:montrack/widget/modules/pocket/pocket_card.dart';

class PocketScreen extends ConsumerWidget {
  const PocketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PocketListResponse> pocketList = ref.watch(
      getListPocketProvider(page: 1, limit: 10),
    );

    Future<void> handleOnRefresh() async {
      ref.invalidate(getListPocketProvider(page: 1, limit: 10));
    }

    Widget listWidgetPocket() {
      return pocketList.when(
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
                        'No pocket yet for now, please click the " + " to create a new pocket.',
                  ),
                ],
              ),
            );
          }

          return Column(
            spacing: 15,
            children: value.data
                .map(
                  (data) => PocketCard(
                    pocketId: data.pocketId,
                    label: data.pocketName,
                    emoji: data.pocketEmoji,
                    initialAmount: data.pocketSetAmount,
                    moneyValue: data.pocketAmmount,
                    description: data.pocketDescription,
                    progress: data.pocketAmmount / data.pocketSetAmount,
                  ),
                )
                .toList(),
          );
        },
        error: (error, trace) => ErrorView(onTap: () => handleOnRefresh()),
        loading: () => Column(
          spacing: 15,
          children: List.generate(5, (_) {}).map((_) {
            return SkeletonBox(width: double.infinity, height: 230);
          }).toList(),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => handleOnRefresh(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsGeometry.directional(top: 20, start: 15, end: 15),
        child: Column(spacing: 10, children: [listWidgetPocket()]),
      ),
    );
  }
}
