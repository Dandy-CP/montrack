import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/models/wallet/active_wallet_model.dart';
import 'package:montrack/service/api/wallet_api.dart';
import 'package:montrack/utils/formated_currency.dart';
import 'package:montrack/widget/elements/skeleton.dart';

class Overview extends ConsumerWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ActiveWalletResponse> activeWallet = ref.watch(
      getActiveWalletProvider,
    );

    Widget walletOverview() {
      return activeWallet.when(
        skipLoadingOnRefresh: false,
        data: (value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(
              value.data.walletName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              formattedCurrency(value.data.walletAmount),
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        loading: () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            SkeletonBox(width: 100, height: 20),
            SkeletonBox(width: 230, height: 40),
          ],
        ),
        error: (error, stack) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            SkeletonBox(width: 100, height: 20),
            SkeletonBox(width: 230, height: 40),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff3077e3), Color(0xff5a96e3)],
          stops: [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.directional(top: 40, start: 20, end: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 30,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/MontrackLogoWhite.png',
                  height: 29.44,
                ),
                Row(
                  spacing: 20,
                  children: [
                    Icon(Icons.notifications, color: Colors.white),
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade400,
                      child: const Text(
                        'DC',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            walletOverview(),
          ],
        ),
      ),
    );
  }
}
