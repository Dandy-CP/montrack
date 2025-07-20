import 'package:flutter/material.dart';
import 'package:montrack/utils/formated_currency.dart';
import 'package:montrack/utils/formated_date.dart';

class TrxCard extends StatefulWidget {
  const TrxCard({
    super.key,
    required this.trxName,
    required this.trxAmount,
    required this.trxType,
    required this.trxDate,
  });

  final String trxName;
  final int trxAmount;
  final String trxDate;
  final String trxType;

  @override
  State<TrxCard> createState() => _TrxCardState();
}

class _TrxCardState extends State<TrxCard> {
  @override
  Widget build(BuildContext context) {
    final dateString = formattedDate(widget.trxDate);
    final amount =
        '${widget.trxType == 'INCOME' ? '+' : '-'} ${formattedCurrency(widget.trxAmount)}';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFE5F0FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(
                  widget.trxName,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  dateString,
                  style: TextStyle(fontSize: 14, color: Color(0xFFABA4A4)),
                ),
              ],
            ),
            Text(
              amount,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.trxType == 'INCOME'
                    ? Colors.green
                    : Color(0xFFF45454),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
