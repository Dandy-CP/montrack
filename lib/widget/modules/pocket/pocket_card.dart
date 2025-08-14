import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:montrack/service/api/pocket_api.dart';
import 'package:montrack/utils/formated_currency.dart';
import 'package:montrack/widget/elements/dialog.dart';
import 'package:montrack/widget/elements/snackbar.dart';

enum MenuItem { detail, edit, delete }

class PocketCard extends ConsumerStatefulWidget {
  const PocketCard({
    super.key,
    required this.pocketId,
    required this.label,
    required this.emoji,
    required this.moneyValue,
    required this.initialAmount,
    required this.description,
    required this.progress,
  });

  final String pocketId;
  final String label;
  final String emoji;
  final int moneyValue;
  final int initialAmount;
  final String description;
  final double progress;

  @override
  PocketCardState createState() => PocketCardState();
}

class PocketCardState extends ConsumerState<PocketCard> {
  @override
  Widget build(BuildContext context) {
    final pocketRequest = ref.watch(pocketRequestProvider.notifier);

    void onDeletePocket() async {
      context.loaderOverlay.show();

      try {
        final response = await pocketRequest.deletePocket(widget.pocketId);

        if (response != null) {
          ref.invalidate(getListPocketProvider(page: 1, limit: 10));
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
        if (context.mounted) context.loaderOverlay.hide();
      }
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsetsGeometry.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.emoji, style: TextStyle(fontSize: 30)),
              PopupMenuButton<MenuItem>(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                menuPadding: EdgeInsetsGeometry.all(0),
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<MenuItem>>[
                      PopupMenuItem<MenuItem>(
                        value: MenuItem.detail,
                        onTap: () => context.push(
                          Uri(
                            path: '/pocket/detail',
                            queryParameters: {'pocketId': widget.pocketId},
                          ).toString(),
                        ),
                        child: Text('Detail'),
                      ),
                      PopupMenuItem<MenuItem>(
                        value: MenuItem.detail,
                        onTap: () => context.push(
                          Uri(
                            path: '/pocket/edit',
                            queryParameters: {'pocketId': widget.pocketId},
                          ).toString(),
                        ),
                        child: Text('Edit'),
                      ),
                      PopupMenuItem<MenuItem>(
                        value: MenuItem.detail,
                        onTap: () => {
                          Dialogs.show(
                            context: context,
                            title: 'Are you sure to delete?',
                            content: 'Your pocket will be permanently deleted',
                            onYesPressed: () {
                              onDeletePocket();
                            },
                          ),
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
              ),
            ],
          ),
          Text(widget.label, style: TextStyle(fontSize: 14)),
          Text(
            formattedCurrency(widget.moneyValue),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          LinearProgressIndicator(
            color: Color(0xFF3077E3),
            value: widget.progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.grey.shade200,
          ),
          Text(
            '${formattedCurrency(widget.moneyValue)} of ${formattedCurrency(widget.initialAmount)} Used',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            widget.description,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
