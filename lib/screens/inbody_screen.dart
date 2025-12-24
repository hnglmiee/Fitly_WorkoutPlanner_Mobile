import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/screens/profile_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/schedule_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/training_screen.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';

import '../shared/navigation_bar.dart';
import 'add_in_body.dart';
import 'edit_in_body.dart';
import 'goal_progress.dart';

class InBodyScreen extends StatelessWidget {
  const InBodyScreen({super.key});

  void _onNavTapped(BuildContext context, int index) {
    Widget nextScreen;

    switch (index) {
      case 0:
        nextScreen = const TrainingScreen();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 20),
                  _latestRecordCard(context),
                  const SizedBox(height: 24),
                  _statisticsSection(),
                  const SizedBox(height: 24),
                  _exerciseSuggestion(),
                  const SizedBox(height: 24),
                  _actionButtons(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        child: CustomNavigationBar(
          selectedIndex: 3,
          onItemTapped: (index) => _onNavTapped(context, index),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Text('In Body', style: textTheme.headlineMedium),
          const Spacer(),
          const Opacity(
            opacity: 0,
            child: Icon(Icons.arrow_back_ios, size: 20),
          ),
        ],
      ),
    );
  }

  // ================= LATEST RECORD CARD =================
  Widget _latestRecordCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.third.withOpacity(0.1),
            AppTheme.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigate to detail
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.fitness_center,
                        size: 24,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Latest Record',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Lose Fat & Gain Muscle',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.trending_up,
                            size: 14,
                            color: Colors.green,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '05.30.2025',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '11:30',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _modernInfoChip(
                      icon: Icons.height_rounded,
                      label: 'Height',
                      value: '170',
                      unit: 'cm',
                    ),
                    const SizedBox(width: 12),
                    _modernInfoChip(
                      icon: Icons.monitor_weight_outlined,
                      label: 'Weight',
                      value: '40',
                      unit: 'kg',
                    ),
                    const SizedBox(width: 12),
                    _modernInfoChip(
                      icon: Icons.person_outline_rounded,
                      label: 'Gender',
                      value: 'Female',
                      unit: '',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _modernInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppTheme.primary),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 2),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1),
                    child: Text(
                      unit,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= STATISTICS =================
  Widget _statisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Body Composition',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _modernStatCard(
              icon: Icons.local_fire_department_rounded,
              title: 'Body Fat',
              value: '14',
              unit: '%',
              color: Colors.orange,
            ),
            const SizedBox(width: 12),
            _modernStatCard(
              icon: Icons.fitness_center,
              title: 'Muscle Mass',
              value: '75',
              unit: '%',
              color: Colors.blue,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _waterCard(),
      ],
    );
  }

  Widget _modernStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
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
                fontSize: 13,
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
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                    height: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4, left: 2),
                  child: Text(
                    unit,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _waterCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade50, Colors.blue.shade100.withOpacity(0.3)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.water_drop,
              color: Colors.blue.shade600,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Body Water',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hydration level',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '28.1',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3, left: 2),
                child: Text(
                  'L',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= EXERCISE SUGGESTION =================
  Widget _exerciseSuggestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended Exercises',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _ModernExerciseChip(
              icon: Icons.directions_walk,
              text: 'Walking',
              color: Colors.green,
            ),
            _ModernExerciseChip(
              icon: Icons.pool,
              text: 'Swimming',
              color: Colors.blue,
            ),
            _ModernExerciseChip(
              icon: Icons.directions_run,
              text: 'Jogging',
              color: Colors.orange,
            ),
            _ModernExerciseChip(
              icon: Icons.sports_tennis,
              text: 'Tennis',
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  // ================= ACTION BUTTONS =================
  Widget _actionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => const EditInBodyScreen(
                        inBodyData: {
                          'id': 1,
                          // 'date': DateTime.now(),
                          // 'time': TimeOfDay.now(),
                          'goal': 'Build Muscle',
                          'height': 170.0,
                          'weight': 65.0,
                          'gender': 'Male',
                          'bodyFatPercentage': 14.0,
                          'muscleMass': 75.0,
                          'totalBodyWater': 28.1,
                          'notes': 'Feeling great!',
                          'uploadedFileName': null,
                        },
                      ),
                ),
              ).then((result) {
                // Handle update or delete result
                if (result != null) {
                  if (result['deleted'] == true) {
                    // Handle delete
                    print('Record deleted: ${result['id']}');
                  } else {
                    // Handle update
                    print('Record updated: $result');
                  }
                }
              });
            },
            icon: const Icon(Icons.edit_outlined, size: 20),
            label: const Text(
              'Edit Record',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black87,
              side: BorderSide(color: Colors.grey.shade300, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddInBodyScreen()),
              );
            },
            icon: const Icon(Icons.add_rounded, size: 22),
            label: const Text(
              'New Record',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: AppTheme.primary.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

// ================= MODERN EXERCISE CHIP =================
class _ModernExerciseChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _ModernExerciseChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: (width - 56) / 2,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}
