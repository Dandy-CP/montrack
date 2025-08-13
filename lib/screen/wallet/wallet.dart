import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/models/wallet/wallet_list_model.dart';
import 'package:montrack/service/api/wallet_api.dart';
import 'package:montrack/utils/formated_currency.dart';
import 'package:montrack/widget/elements/button.dart';
import 'package:montrack/widget/elements/skeleton.dart';
import 'package:montrack/widget/modules/app_bar.dart';
import 'package:montrack/widget/modules/wallet/wallet_card.dart';

enum MenuItem { edit, use, delete }

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<WalletListResponse> walletList = ref.watch(
      walletListProvider(page: 1, limit: 10),
    );

    final walletRequest = ref.watch(
      walletListProvider(page: 1, limit: 10).notifier,
    );

    Future<void> handleRefresh() async {
      ref.invalidate(walletListProvider(page: 1, limit: 10));
    }

    Widget listWallet() {
      return walletList.when(
        skipLoadingOnRefresh: false,
        data: (value) {
          return Column(
            spacing: 15,
            children: [
              Column(
                spacing: 15,
                children: value.data
                    .map(
                      (data) => WalletCard(
                        walletID: data.walletId,
                        walletName: data.walletName,
                        walletAmount: formattedCurrency(data.walletAmount),
                        isWalletActive: data.isWalletActive,
                      ),
                    )
                    .toList(),
              ),
              Button(
                label: 'Add New Wallet',
                onPressed: () => context.push('/wallet/create'),
              ),
            ],
          );
        },
        error: (error, trace) => Column(
          spacing: 15,
          children: List.generate(5, (_) {}).map((_) {
            return SkeletonBox(width: double.infinity, height: 150);
          }).toList(),
        ),
        loading: () => Column(
          spacing: 15,
          children: List.generate(5, (_) {}).map((_) {
            return SkeletonBox(width: double.infinity, height: 150);
          }).toList(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Wallet',
        showLeading: true,
        onBack: () => context.pop(),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          double currentPosition = scrollInfo.metrics.pixels;
          double maxScrollPosition = scrollInfo.metrics.maxScrollExtent;

          if (currentPosition == maxScrollPosition) {
            walletRequest.loadNextPage();
          }

          return false;
        },
        child: RefreshIndicator(
          onRefresh: () => handleRefresh(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsetsGeometry.directional(
              top: 20,
              start: 15,
              end: 15,
            ),
            child: listWallet(),
          ),
        ),
      ),
    );
  }
}
