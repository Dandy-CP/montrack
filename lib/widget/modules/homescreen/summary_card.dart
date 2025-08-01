import 'package:flutter/material.dart';

class SummaryCard extends StatefulWidget {
  const SummaryCard({
    super.key,
    required this.label,
    required this.emoji,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final Widget value;
  final void Function() onTap;

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 136,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            widget.onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsetsGeometry.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.emoji, style: TextStyle(fontSize: 30)),
                Text(widget.label, style: TextStyle(fontSize: 15)),
                widget.value,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
