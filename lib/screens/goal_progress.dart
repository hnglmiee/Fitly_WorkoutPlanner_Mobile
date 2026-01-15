// lib/screens/goal_progress_screen.dart

import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/screens/profile_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/schedule_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/training_screen.dart';
import 'package:workout_tracker_mini_project_mobile/shared/percentage_progress_bar.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';

import '../models/goal_progress.dart';
import '../models/goal.dart';
import '../services/goal_service.dart';
import '../shared/navigation_bar.dart';
import 'create_goal_screen.dart';
import 'edit_goal_screen.dart';
import 'history_goal.dart';

class GoalProgressScreen extends StatefulWidget {
  const GoalProgressScreen({super.key});

  @override
  State<GoalProgressScreen> createState() => _GoalProgressScreenState();
}

class _GoalProgressScreenState extends State<GoalProgressScreen> {
  int _selectedIndex = 2; // Statistics active
  late Future<GoalProgress?> _goalFuture;

  @override
  void initState() {
    super.initState();
    _goalFuture = GoalService.fetchGoalProgress();
  }

  // ✅ Helper methods for formatting
  String _formatDouble(double? value, {int decimals = 1}) {
    return value?.toStringAsFixed(decimals) ?? "-";
  }

  String _formatDoubleWithUnit(double? value, String unit, {int decimals = 1}) {
    if (value == null) return "-";
    return "${value.toStringAsFixed(decimals)}$unit";
  }

  String _formatTarget(double? target, String unit) {
    if (target == null) return "";
    return "Target: ${target.toStringAsFixed(1)}$unit";
  }

  void _confirmDeleteGoal(BuildContext context, int goalId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Delete Goal",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text(
            "Are you sure you want to delete this goal?\nThis action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);

                try {
                  await GoalService.deleteGoal(goalId);

                  if (!mounted) return;

                  setState(() {
                    _goalFuture = GoalService.fetchGoalProgress();
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Goal deleted successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Failed to delete goal"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }


  // ✅ Calculate progress percentage
  double _calculateProgress(GoalProgress goalProgress) {
    final inBody = goalProgress.lastestInBody;
    final goal = goalProgress.goal;

    if (inBody == null || goal.targetWeight == null) {
      return 0;
    }

    final start = goal.startDate;
    final end = goal.endDate;

    // Calculate days
    final totalDays = end.difference(start).inDays;
    final daysPassed = DateTime.now().difference(start).inDays;

    if (totalDays <= 0) return 0;

    // Time-based progress
    final timeProgress = (daysPassed / totalDays * 100).clamp(0, 100).toDouble();
    return timeProgress;
  }

  void _onNavTapped(int index) {
    if (index == _selectedIndex) return;

    Widget nextScreen;

    switch (index) {
      case 0:
        nextScreen = TrainingScreen();
        break;
      case 1:
        nextScreen = const ScheduleScreen();
        break;
      case 2:
        nextScreen = const GoalProgressScreen();
        break;
      case 3:
        nextScreen = const ProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => nextScreen,
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add Note",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Enter your note...",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: AppTheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final note = noteController.text.trim();
                          if (note.isEmpty) return;
                          // TODO: save note
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        child: CustomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onNavTapped,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// ===== Header =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 22,
                      color: AppTheme.primary,
                    ),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateGoalScreen(),
                        ),
                      );

                      // Reload if goal was created
                      if (result == true && mounted) {
                        setState(() {
                          _goalFuture = GoalService.fetchGoalProgress();
                        });
                      }
                    },
                    tooltip: 'Create Goal',
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Goal Progress",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 22,
                      color: AppTheme.primary,
                    ),
                    onPressed: () async {
                      // Get current goal data
                      final currentGoal = await _goalFuture;
                      if (currentGoal != null) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditGoalScreen(goal: currentGoal),
                          ),
                        );
                        // Reload after editing
                        setState(() {
                          _goalFuture = GoalService.fetchGoalProgress();
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.history, size: 22),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GoalHistoryScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ===== Goal Progress Card =====
                    const Text(
                      "Current Goal",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    FutureBuilder<GoalProgress?>(
                      future: _goalFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 200,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: CircularProgressIndicator(
                              color: AppTheme.primary,
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          // ✅ EMPTY STATE WITH CREATE GOAL BUTTON
                          return Container(
                            padding: const EdgeInsets.all(32),
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Empty state icon
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.flag_outlined,
                                    size: 48,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Title
                                const Text(
                                  'No Active Goal',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Description
                                Text(
                                  'Create your first fitness goal to start\ntracking your progress',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 28),

                                // Create Goal Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                          const CreateGoalScreen(),
                                        ),
                                      );

                                      // Reload if goal was created successfully
                                      if (result == true && mounted) {
                                        setState(() {
                                          _goalFuture =
                                              GoalService.fetchGoalProgress();
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.add_circle_outline,
                                        color: Colors.white, size: 22),
                                    label: const Text(
                                      'Create Goal',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 0,
                                      shadowColor:
                                      AppTheme.primary.withOpacity(0.3),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Secondary info
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Set targets for weight, body fat, and more',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }

                        final goal = snapshot.data!;
                        final progressPercent = _calculateProgress(goal);

                        return Container(
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
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// LEFT CONTENT
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        /// STATUS BADGE
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primary,
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            goal.status,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 12),

                                        /// GOAL NAME
                                        Text(
                                          goal.goal.goalName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.3,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        /// NOTES
                                        Text(
                                          goal.goal.notes.isNotEmpty
                                              ? goal.goal.notes
                                              : "No notes",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
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
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            "https://plus.unsplash.com/premium_photo-1661265933107-85a5dbd815af",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              /// PROGRESS BAR
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Progress",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        "${progressPercent.toStringAsFixed(0)}%",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      height: 15,
                                      child: PercentageProgressBar(
                                        percent: progressPercent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    /// ===== My Activities =====
                    const Text(
                      "My Activities",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 48,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          _ModernActivityChip(
                            icon: Icons.fitness_center,
                            label: "Bench Press",
                          ),
                          _ModernActivityChip(
                            icon: Icons.directions_run,
                            label: "Running",
                          ),
                          _ModernActivityChip(
                            icon: Icons.accessibility_new,
                            label: "Squat",
                          ),
                          _ModernActivityChip(
                            icon: Icons.fitness_center,
                            label: "Deadlift",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// ===== Statistics =====
                    const Text(
                      "Statistics",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ✅ Use real data from API
                    FutureBuilder<GoalProgress?>(
                      future: _goalFuture,
                      builder: (context, snapshot) {
                        final goalProgress = snapshot.data;
                        final inBody = goalProgress?.lastestInBody;
                        final goal = goalProgress?.goal;

                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _ModernStatCard(
                                    title: "Workout Sessions",
                                    value: goalProgress?.workoutSessionThisWeek
                                        .toString() ??
                                        "-",
                                    sub: goal?.targetWorkoutSessionsPerWeek !=
                                        null
                                        ? "/${goal!.targetWorkoutSessionsPerWeek}"
                                        : "/week",
                                    icon: Icons.fitness_center,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _ModernStatCard(
                                    title: "Weight",
                                    value: _formatDouble(inBody?.weight),
                                    unit: "kg",
                                    icon: Icons.monitor_weight_outlined,
                                    color: Colors.orange,
                                    subtitle: goal?.targetWeight != null
                                        ? _formatTarget(
                                        goal!.targetWeight, "kg")
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _MiniTarget(
                                  label: "Body Fat",
                                  value: _formatDoubleWithUnit(
                                      inBody?.bodyFatPercentage, "%"),
                                  icon: Icons.local_fire_department,
                                  color: Colors.orange,
                                  target: goal?.targetBodyFatPercentage,
                                ),
                                _MiniTarget(
                                  label: "Muscle",
                                  value: _formatDoubleWithUnit(
                                      inBody?.muscleMass, "%"),
                                  icon: Icons.fitness_center,
                                  color: Colors.blue,
                                  target: goal?.targetMuscleMass,
                                ),
                                _MiniTarget(
                                  label: "Calories",
                                  value: goal?.targetCaloriesPerDay
                                      ?.toString() ??
                                      "-",
                                  icon: Icons.restaurant,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    /// ===== Notes =====
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     const Text(
                    //       "Notes",
                    //       style: TextStyle(
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.w700,
                    //         letterSpacing: -0.5,
                    //       ),
                    //     ),
                    //     TextButton.icon(
                    //       onPressed: () => _showAddNoteDialog(context),
                    //       icon: Icon(
                    //         Icons.add,
                    //         size: 18,
                    //         color: AppTheme.primary,
                    //       ),
                    //       label: Text(
                    //         "Add Note",
                    //         style: TextStyle(
                    //           color: AppTheme.primary,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 12),

                    // Container(
                    //   width: double.infinity,
                    //   padding: const EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(16),
                    //     border: Border.all(color: Colors.grey.shade200),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.black.withOpacity(0.02),
                    //         blurRadius: 8,
                    //         offset: const Offset(0, 2),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Container(
                    //         padding: const EdgeInsets.all(10),
                    //         decoration: BoxDecoration(
                    //           color: Colors.orange.withOpacity(0.1),
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //         child: const Icon(
                    //           Icons.restaurant,
                    //           color: Colors.orange,
                    //           size: 20,
                    //         ),
                    //       ),
                    //       const SizedBox(width: 12),
                    //       Expanded(
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             const Text(
                    //               "Oatmeal with Egg",
                    //               style: TextStyle(
                    //                 fontWeight: FontWeight.w600,
                    //                 fontSize: 14,
                    //               ),
                    //             ),
                    //             const SizedBox(height: 4),
                    //             Text(
                    //               "160 kcal / day",
                    //               style: TextStyle(
                    //                 fontSize: 12,
                    //                 color: Colors.grey.shade600,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       IconButton(
                    //         icon: const Icon(Icons.more_vert, size: 20),
                    //         onPressed: () {},
                    //         color: Colors.grey.shade600,
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // const SizedBox(height: 24),

                    /// ===== Delete Button =====
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final goalProgress = await _goalFuture;
                          if (goalProgress == null) return;

                          _confirmDeleteGoal(context, goalProgress.goal.id);
                        },
                        icon: const Icon(Icons.delete_outline, size: 20),
                        label: const Text(
                          "Delete Goal",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side:
                          const BorderSide(color: Colors.red, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
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

/// ===== Components =====

class _ModernActivityChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ModernActivityChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ModernStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? sub;
  final String? unit;
  final String? subtitle;
  final IconData icon;
  final Color color;

  _ModernStatCard({
    required this.title,
    required this.value,
    this.sub,
    this.unit,
    this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  letterSpacing: -1,
                ),
              ),
              if (sub != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2, left: 2),
                  child: Text(
                    sub!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (unit != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2, left: 2),
                  child: Text(
                    unit!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniTarget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final double? target;

  const _MiniTarget({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.target,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            if (target != null) ...[
              const SizedBox(height: 2),
              Text(
                "→ ${target!.toStringAsFixed(1)}%",
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}