import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/screens/profile_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/schedule_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/training_screen.dart';
import 'package:workout_tracker_mini_project_mobile/shared/percentage_progress_bar.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';

import '../shared/navigation_bar.dart';
import 'history_goal.dart';

class GoalProgressScreen extends StatefulWidget {
  const GoalProgressScreen({super.key});

  @override
  State<GoalProgressScreen> createState() => _GoalProgressScreenState();
}

class _GoalProgressScreenState extends State<GoalProgressScreen> {
  int _selectedIndex = 2; // Statistics active

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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Enter your note...",
                    filled: true,
                    fillColor: AppTheme.third,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
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
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ===== Header =====
              SizedBox(
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    /// Title - luôn ở giữa
                    const Text(
                      "Goal",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    /// Back button - bên trái
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    /// History button - bên phải
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
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
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ===== Goal Progress =====
              const Text(
                "Goal Progress",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.third,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    /// LEFT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Cardio",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Lose weight, gain muscle",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Heavy weight for strength",
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "In progress",
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: PercentageProgressBar(percent: 30),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// IMAGE
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: NetworkImage(
                            "https://plus.unsplash.com/premium_photo-1661265933107-85a5dbd815af?q=80&w=1118&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ===== My Activities =====
              const Text(
                "My Activities",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _ActivityChip(
                      icon: Icons.fitness_center,
                      label: "Bench Press",
                    ),
                    _ActivityChip(icon: Icons.directions_run, label: "Running"),
                    _ActivityChip(
                      icon: Icons.accessibility_new,
                      label: "Squat",
                    ),
                    _ActivityChip(
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Row(
                children: const [
                  Expanded(
                    child: _StatCard(
                      title: "Workout Sessions",
                      value: "2",
                      sub: "/week",
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(child: _StatCard(title: "Weight", value: "75kg")),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: const [
                  _MiniTarget(label: "Body Fat", value: "17%"),
                  _MiniTarget(label: "Muscle Mass", value: "17%"),
                  _MiniTarget(label: "Calories", value: "1700"),
                ],
              ),

              const SizedBox(height: 24),

              /// ===== Notes =====
              const Text(
                "Notes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.third,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Oatmeal with Egg",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "160 kcal / day",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showAddNoteDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Add New Notes",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showAddNoteDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Delete",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===== Components =====

class _ActivityChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActivityChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppTheme.third,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? sub;

  const _StatCard({required this.title, required this.value, this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.third,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (sub != null)
                  TextSpan(text: sub, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniTarget extends StatelessWidget {
  final String label;
  final String value;

  const _MiniTarget({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.third,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
