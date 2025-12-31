import 'package:flutter/material.dart';
import '../models/schedule_plan.dart';

class SchedulePlanItem extends StatelessWidget {
  final SchedulePlan plan;

  const SchedulePlanItem({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          /// DAY LABEL
          SizedBox(
            width: 50,
            child: Text(plan.dayLabel, style: const TextStyle(fontSize: 14)),
          ),

          /// CARD
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: plan.outlined ? Colors.white : plan.backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border:
                    plan.outlined
                        ? Border.all(color: primaryColor, width: 2)
                        : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// INFO
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // ✅ Only show description if not empty
                        if (plan.description != null &&
                            plan.description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            plan.description!, // ✅ Use ! operator
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),

                  /// TAG
                  if (plan.tag != null && plan.tag!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        plan.tag!, // ✅ Use ! operator
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
