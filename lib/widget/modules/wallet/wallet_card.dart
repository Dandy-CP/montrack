import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:montrack/service/api/goals_api.dart';
import 'package:montrack/service/api/pocket_api.dart';
import 'package:montrack/service/api/transaction_api.dart';
import 'package:montrack/service/api/wallet_api.dart';
import 'package:montrack/widget/elements/dialog.dart';
import 'package:montrack/widget/elements/snackbar.dart';

enum MenuItem { edit, use, delete }

class WalletCard extends ConsumerStatefulWidget {
  const WalletCard({
    super.key,
    required this.walletID,
    required this.walletName,
    required this.walletAmount,
    required this.isWalletActive,
  });

  final String walletID;
  final String walletName;
  final String walletAmount;
  final bool isWalletActive;

  @override
  ConsumerState<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends ConsumerState<WalletCard> {
  @override
  Widget build(BuildContext context) {
    final walletRequest = ref.watch(walletRequestProvider.notifier);

    void handleDeleteWallet() {
      Dialogs.show(
        context: context,
        title: 'Are you sure to delete?',
        content: 'Your wallet will be permanently deleted',
        onYesPressed: () async {
          context.loaderOverlay.show();

          try {
            final response = await walletRequest.deleteWallet({
              'walletId': widget.walletID,
            });

            if (response.statusCode == 200 && context.mounted) {
              SnackBars.show(context: context, message: 'Wallet deleted');
              ref.invalidate(walletListProvider(page: 1, limit: 10));
            }
          } on DioException catch (error) {
            if (context.mounted) {
              SnackBars.show(
                context: context,
                message:
                    '${error.response?.data['message'] ?? 'Ops Something Wrong'}',
                type: SnackBarsVariant.error,
              );
            }
          } finally {
            if (context.mounted) {
              context.loaderOverlay.hide();
            }
          }
        },
      );
    }

    void handleUseWallet() {
      Dialogs.show(
        context: context,
        title: 'Are you sure to use this Wallet?',
        onYesPressed: () async {
          context.loaderOverlay.show();

          try {
            final response = await walletRequest.useWallet({
              'walletId': widget.walletID,
              'is_wallet_active': true,
            });

            if (response.statusCode == 200 && context.mounted) {
              SnackBars.show(
                context: context,
                message: 'Success Change Active Wallet',
              );

              // Invalidate all related data
              ref.invalidate(walletListProvider(page: 1, limit: 10));
              ref.invalidate(getListPocketProvider(page: 1, limit: 10));
              ref.invalidate(getListGoalsProvider(page: 1, limit: 10));
              ref.invalidate(getActiveWalletProvider);
              ref.invalidate(transactionListRequestProvider);
              ref.invalidate(getTransactionSummaryProvider);
            }
          } on DioException catch (error) {
            if (context.mounted) {
              SnackBars.show(
                context: context,
                message:
                    '${error.response?.data['message'] ?? 'Ops Something Wrong'}',
                type: SnackBarsVariant.error,
              );
            }
          } finally {
            if (context.mounted) {
              context.loaderOverlay.hide();
            }
          }
        },
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsetsGeometry.all(18),
      decoration: BoxDecoration(
        color: widget.isWalletActive ? Color(0xFF3077E3) : Colors.white,
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
        spacing: 5,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.walletName,
                style: TextStyle(
                  color: widget.isWalletActive ? Colors.white : Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              PopupMenuButton<MenuItem>(
                color: Colors.white,
                iconColor: widget.isWalletActive ? Colors.white : Colors.black,
                borderRadius: BorderRadius.circular(20),
                menuPadding: EdgeInsetsGeometry.all(0),
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<MenuItem>>[
                      PopupMenuItem<MenuItem>(
                        value: MenuItem.edit,
                        onTap: () {
                          context.push(
                            Uri(
                              path: '/wallet/edit',
                              queryParameters: {
                                'walletId': widget.walletID,
                                'walletName': widget.walletName,
                                'walletAmount': widget.walletAmount,
                              },
                            ).toString(),
                          );
                        },
                        child: Text('Edit'),
                      ),

                      if (!widget.isWalletActive)
                        PopupMenuItem<MenuItem>(
                          value: MenuItem.use,
                          onTap: () => handleUseWallet(),
                          child: Text('Use This wallet'),
                        ),

                      if (!widget.isWalletActive)
                        PopupMenuItem<MenuItem>(
                          value: MenuItem.delete,
                          onTap: () => handleDeleteWallet(),
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                    ],
              ),
            ],
          ),

          Text(
            widget.walletAmount,
            style: TextStyle(
              color: widget.isWalletActive ? Colors.white : Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (widget.isWalletActive)
            Row(
              spacing: 10,
              children: [
                Text(
                  'This wallet is currently used',
                  style: TextStyle(color: Colors.white),
                ),
                Icon(Icons.check_circle, color: Colors.white, size: 20),
              ],
            ),
        ],
      ),
    );
  }
}
