import 'package:flutter/material.dart';

const double workoutCardHeight = 140;
const double workoutCardSpacing = 12;

class PlanProgressTimeline extends StatelessWidget {
  final int total;
  final int activeIndex;

  const PlanProgressTimeline({
    super.key,
    required this.total,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(total, (index) {
        final isActive = index <= activeIndex;

        return Column(
          children: [
            /// DOT
            _AnimatedDot(active: isActive),

            /// LINE – nối tới dot tiếp theo
            if (index != total - 1)
              Container(
                width: 1.5,
                height: workoutCardHeight + workoutCardSpacing,
                color: Colors.grey.shade300,
              ),
          ],
        );
      }),
    );
  }
}

class _AnimatedDot extends StatelessWidget {
  final bool active;
  const _AnimatedDot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      width: active ? 14 : 10,
      height: active ? 14 : 10,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: active ? Colors.blue : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }
}
