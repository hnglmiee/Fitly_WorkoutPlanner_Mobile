import 'package:flutter/material.dart';

class PercentageProgressBar extends StatelessWidget {
  final double percent; // 0 → 100

  const PercentageProgressBar({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    final double progressValue = (percent / 100).clamp(0.0, 1.0);

    return Stack(
      alignment: Alignment.centerRight,
      children: [
        /// Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progressValue,
            minHeight: 15,
            backgroundColor: Colors.white,
            valueColor: const AlwaysStoppedAnimation(Colors.blue),
          ),
        ),

        /// Percentage text (top-right)
        Positioned(
          right: 8,
          top: -1.5,
          child: Text(
            "${percent.toInt()}%",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
