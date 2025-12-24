import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';
import '../models/goal_history_item.dart';
import 'goal_detail_screen.dart';

class GoalHistoryScreen extends StatelessWidget {
  const GoalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GoalHistoryItem> goals = [
      GoalHistoryItem(
        title: "Lose weight, gain muscle",
        type: "Cardio",
        status: GoalStatus.completed,
        imageUrl:
            "https://plus.unsplash.com/premium_photo-1661265933107-85a5dbd815af",
      ),
      GoalHistoryItem(
        title: "Gain muscle",
        type: "Cardio",
        status: GoalStatus.canceled,
        imageUrl:
            "https://plus.unsplash.com/premium_photo-1661265933107-85a5dbd815af",
      ),
      GoalHistoryItem(
        title: "Lose weight, gain muscle",
        type: "Cardio",
        status: GoalStatus.completed,
        imageUrl:
            "https://plus.unsplash.com/premium_photo-1661265933107-85a5dbd815af",
      ),
      GoalHistoryItem(
        title: "Lose weight, gain muscle",
        type: "Cardio",
        status: GoalStatus.completed,
        imageUrl:
            "https://plus.unsplash.com/premium_photo-1661265933107-85a5dbd815af",
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.lightBackground,

      /// ===== Body with Custom Header =====
      body: SafeArea(
        child: Column(
          children: [
            /// ===== Header =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.transparent,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "History",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),

            /// ===== Content =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Section Header
                    const Text(
                      "Previous Goals",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Goals List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: goals.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return GoalHistoryCard(goal: goals[index]);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoalHistoryCard extends StatelessWidget {
  final GoalHistoryItem goal;

  const GoalHistoryCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GoalDetailScreen(goal: goal)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEFT CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TYPE BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      goal.type.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// TITLE
                  Text(
                    goal.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  /// STATUS with icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: goal.statusColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          goal.status == GoalStatus.completed
                              ? Icons.check_circle
                              : Icons.cancel,
                          size: 14,
                          color: goal.statusColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        goal.statusText,
                        style: TextStyle(
                          fontSize: 13,
                          color: goal.statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            /// RIGHT IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(goal.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
