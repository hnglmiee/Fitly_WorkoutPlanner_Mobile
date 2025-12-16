import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';

import '../screens/goal_progress.dart';

class WorkoutCard extends StatelessWidget {
  final String image;
  final String title;
  final String sets;
  final String reps;
  final bool active;
  final VoidCallback? onStart;

  const WorkoutCard({
    super.key,
    required this.image,
    required this.title,
    required this.sets,
    required this.reps,
    this.active = false,
    this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              image,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    width: 48,
                    height: 48,
                    color: Colors.grey.shade300,
                  ),
            ),
          ),

          const SizedBox(width: 12),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.timer, size: 14),
                    const SizedBox(width: 4),
                    Text(sets, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 12),
                    const Icon(Icons.fitness_center, size: 14),
                    const SizedBox(width: 4),
                    Text(reps, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minimumSize: const Size(double.infinity, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GoalProgressScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Start',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      // Icon mũi tên trong hình tròn
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
