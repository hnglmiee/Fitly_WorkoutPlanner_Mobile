import 'package:flutter/material.dart';
import '../models/goal_history_item.dart';

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
      backgroundColor: Colors.white,

      /// ===== AppBar =====
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "History",
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      /// ===== Body =====
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Previous Goals",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                itemCount: goals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return GoalHistoryCard(goal: goals[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================
/// 🔹 Goal History Card
/// =======================

class GoalHistoryCard extends StatelessWidget {
  final GoalHistoryItem goal;

  const GoalHistoryCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: goal.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          /// LEFT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TYPE CHIP
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    goal.type,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),

                const SizedBox(height: 8),

                /// TITLE
                Text(
                  goal.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 6),

                /// STATUS
                Text(
                  goal.statusText,
                  style: TextStyle(fontSize: 12, color: goal.statusColor),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// IMAGE
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              image: DecorationImage(
                image: NetworkImage(goal.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
