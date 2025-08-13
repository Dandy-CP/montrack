import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:montrack/service/api/goals_api.dart';
import 'package:montrack/utils/formated_currency.dart';
import 'package:montrack/widget/elements/dialog.dart';
import 'package:montrack/widget/elements/snackbar.dart';

enum MenuItem { detail, edit, delete }

class GoalsCard extends ConsumerStatefulWidget {
  const GoalsCard({
    super.key,
    required this.goalsId,
    required this.label,
    required this.moneyValue,
    required this.initialAmount,
    required this.description,
    required this.progress,
  });

  final String goalsId;
  final String label;
  final int moneyValue;
  final int initialAmount;
  final String description;
  final double progress;

  @override
  PocketCardState createState() => PocketCardState();
}

class PocketCardState extends ConsumerState<GoalsCard> {
  @override
  Widget build(BuildContext context) {
    final goalsRequest = ref.watch(goalsRequestProvider.notifier);

    void onDeleteGoals() async {
      context.loaderOverlay.show();

      try {
        final response = await goalsRequest.deleteGoals(
          goalsId: widget.goalsId,
        );

        if (response.statusCode == 200) {
          if (context.mounted) {
            Navigator.pop(context);
          }

          ref.invalidate(getListGoalsProvider(page: 1, limit: 10));
        }
      } on DioException catch (error) {
        if (context.mounted) {
          Navigator.pop(context);

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  Text(widget.label, style: TextStyle(fontSize: 15)),
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
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
                            path: '/goals/detail',
                            queryParameters: {'goalsId': widget.goalsId},
                          ).toString(),
                        ),
                        child: Text('Detail'),
                      ),
                      PopupMenuItem<MenuItem>(
                        value: MenuItem.detail,
                        onTap: () => context.push(
                          Uri(
                            path: '/goals/edit',
                            queryParameters: {'goalsId': widget.goalsId},
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
                              onDeleteGoals();
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
            '${formattedCurrency(widget.moneyValue)} of ${formattedCurrency(widget.initialAmount)} Reached',
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
