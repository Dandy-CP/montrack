import 'package:flutter/material.dart';
import 'package:montrack/utils/formated_currency.dart';
import 'package:montrack/widget/elements/button.dart';

enum MenuItem { detail, edit, delete }

class BudgetingCard extends StatefulWidget {
  const BudgetingCard({
    super.key,
    required this.label,
    required this.moneyValue,
    required this.progress,
  });

  final String label;
  final int moneyValue;
  final double progress;

  @override
  State<BudgetingCard> createState() => _BudgetingCardState();
}

class _BudgetingCardState extends State<BudgetingCard> {
  void handleOnDeleteBudget() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure to delete?'),
        content: Text('Your pocket will be permanently deleted'),
        actionsAlignment: MainAxisAlignment.spaceBetween,

        actions: [
          Button(
            label: 'No',
            variant: 'outlined',
            width: 130,
            onPressed: () => Navigator.pop(context),
          ),
          Button(
            label: 'Yes',
            width: 130,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Text(
                widget.label,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              PopupMenuButton<MenuItem>(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                menuPadding: EdgeInsetsGeometry.all(0),
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<MenuItem>>[
                      PopupMenuItem<MenuItem>(
                        value: MenuItem.detail,
                        child: Text('Detail'),
                      ),
                      PopupMenuItem<MenuItem>(
                        value: MenuItem.detail,
                        child: Text('Edit'),
                      ),
                      PopupMenuItem<MenuItem>(
                        value: MenuItem.detail,
                        onTap: () => handleOnDeleteBudget(),
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
          //
          // LinearProgressIndicator(
          //   color: Color(0xFF3077E3),
          //   value: widget.progress,
          //   minHeight: 8,
          //   borderRadius: BorderRadius.circular(10),
          //   backgroundColor: Colors.grey.shade200,
          // ),
        ],
      ),
    );
  }
}
