import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker_mini_project_mobile/screens/profile_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/schedule_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/training_screen.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';

import '../models/in_body_data.dart';
import '../services/in_body_service.dart';
import '../shared/navigation_bar.dart';
import 'add_in_body.dart';
import 'edit_in_body.dart';
import 'goal_progress.dart';
import 'in_body_history_screen.dart';

class InBodyScreen extends StatefulWidget {
  const InBodyScreen({super.key});

  @override
  State<InBodyScreen> createState() => _InBodyScreenState();
}

class _InBodyScreenState extends State<InBodyScreen> {
  Future<InBodyData?>? _latestRecordFuture;

  @override
  void initState() {
    super.initState();
    _loadLatestRecord();
  }

  void _loadLatestRecord() {
    setState(() {
      _latestRecordFuture = InBodyService.fetchLatestInBodyRecord();
    });
  }

  void _onNavTapped(int index) {
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
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _loadLatestRecord();
                },
                color: AppTheme.darkPrimary,
                backgroundColor: AppTheme.darkSecondary,
                child: FutureBuilder<InBodyData?>(
                  future: _latestRecordFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.darkPrimary,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return _buildErrorState();
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return _buildEmptyState();
                    }

                    final record = snapshot.data!;

                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        const SizedBox(height: 20),
                        _latestRecordCard(context, record),
                        const SizedBox(height: 24),
                        _statisticsSection(record),
                        const SizedBox(height: 24),
                        _exerciseSuggestion(),
                        const SizedBox(height: 24),
                        _actionButtons(context, record),
                        const SizedBox(height: 24),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        child: CustomNavigationBar(
          selectedIndex: 3,
          onItemTapped: _onNavTapped,
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                size: 20, color: AppTheme.darkText),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Text(
            'In Body',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkText,
            ),
          ),
          const Spacer(),
          FutureBuilder<List<InBodyData>>(
            future: InBodyService.fetchMyInBodyRecords(),
            builder: (context, snapshot) {
              final hasMultiple =
                  snapshot.hasData && (snapshot.data?.length ?? 0) > 1;

              if (!hasMultiple) {
                return const Opacity(
                  opacity: 0,
                  child: Icon(Icons.history, size: 20),
                );
              }

              return IconButton(
                icon: Icon(Icons.history,
                    size: 24, color: AppTheme.darkPrimary),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InBodyHistoryScreen(),
                    ),
                  );
                  // Reload if user selected a record
                  if (result != null) {
                    _loadLatestRecord();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ================= ERROR STATE =================
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            const Text(
              'Failed to load data',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadLatestRecord,
              icon: const Icon(Icons.refresh, color: AppTheme.darkBackground),
              label: const Text('Retry',
                  style: TextStyle(color: AppTheme.darkBackground)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.darkPrimary,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= EMPTY STATE =================
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center,
                size: 64, color: Colors.grey.shade600),
            const SizedBox(height: 16),
            const Text(
              'No InBody records yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "New Record" to add your first measurement',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddInBodyScreen()),
                );
                _loadLatestRecord();
              },
              icon: const Icon(Icons.add_rounded,
                  size: 22, color: AppTheme.darkBackground),
              label: const Text(
                'New Record',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkBackground,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.darkPrimary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LATEST RECORD CARD =================
  Widget _latestRecordCard(BuildContext context, InBodyData record) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.darkPrimary.withOpacity(0.15),
            AppTheme.darkPrimary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppTheme.darkPrimary.withOpacity(0.3), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigate to detail or history
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InBodyHistoryScreen()),
            );
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
                        color: AppTheme.darkPrimary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.fitness_center,
                        size: 24,
                        color: AppTheme.darkPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Latest Record',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            record.fullName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                              color: AppTheme.darkText,
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
                        color: Colors.green.shade400.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 14,
                            color: Colors.green.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade400,
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
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('MM.dd.yyyy').format(record.measuredAt),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('HH:mm').format(record.measuredAt),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade400,
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
                      value: record.height.toStringAsFixed(1),
                      unit: 'cm',
                    ),
                    const SizedBox(width: 12),
                    _modernInfoChip(
                      icon: Icons.monitor_weight_outlined,
                      label: 'Weight',
                      value: record.weight.toStringAsFixed(1),
                      unit: 'kg',
                    ),
                    const SizedBox(width: 12),
                    _modernInfoChip(
                      icon: Icons.analytics_outlined,
                      label: 'BMI',
                      value: record.bmi.toStringAsFixed(1),
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
          color: AppTheme.darkSecondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.darkThird),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppTheme.darkPrimary),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade400,
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
                    color: AppTheme.darkText,
                  ),
                ),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 2),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1),
                    child: Text(
                      unit,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
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
  Widget _statisticsSection(InBodyData record) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Body Composition',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _modernStatCard(
              icon: Icons.local_fire_department_rounded,
              title: 'Body Fat',
              value: record.bodyFatPercentage.toStringAsFixed(1),
              unit: '%',
              color: Colors.orange.shade400,
            ),
            const SizedBox(width: 12),
            _modernStatCard(
              icon: Icons.fitness_center,
              title: 'Muscle Mass',
              value: record.muscleMass.toStringAsFixed(1),
              unit: '%',
              color: Colors.blue.shade400,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _waterCard(record),
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
          color: AppTheme.darkSecondary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.darkThird),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
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
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade400,
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
                    color: AppTheme.darkText,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4, left: 2),
                  child: Text(
                    unit,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade400,
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

  Widget _waterCard(InBodyData record) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade400.withOpacity(0.15),
            Colors.blue.shade400.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Colors.blue.shade400.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.darkSecondary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.water_drop,
              color: Colors.blue.shade400,
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
                    color: AppTheme.darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Estimated from lean mass',
                  style:
                  TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                record.estimatedTotalBodyWater.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppTheme.darkText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3, left: 2),
                child: Text(
                  'L',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
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
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ModernExerciseChip(
              icon: Icons.directions_walk,
              text: 'Walking',
              color: Colors.green.shade400,
            ),
            _ModernExerciseChip(
              icon: Icons.pool,
              text: 'Swimming',
              color: Colors.blue.shade400,
            ),
            _ModernExerciseChip(
              icon: Icons.directions_run,
              text: 'Jogging',
              color: Colors.orange.shade400,
            ),
            _ModernExerciseChip(
              icon: Icons.sports_tennis,
              text: 'Tennis',
              color: Colors.purple.shade400,
            ),
          ],
        ),
      ],
    );
  }

  // ================= ACTION BUTTONS =================
  Widget _actionButtons(BuildContext context, InBodyData record) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditInBodyScreen(
                    inBodyData: {
                      'id': record.id,
                      'measuredAt': record.measuredAt,
                      'height': record.height,
                      'weight': record.weight,
                      'bodyFatPercentage': record.bodyFatPercentage,
                      'muscleMass': record.muscleMass,
                      'notes': record.notes ?? '',
                    },
                  ),
                ),
              );
              _loadLatestRecord();
            },
            icon: const Icon(Icons.edit_outlined,
                size: 20, color: AppTheme.darkText),
            label: const Text(
              'Edit Record',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.darkThird, width: 1.5),
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
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddInBodyScreen()),
              );
              _loadLatestRecord();
            },
            icon: const Icon(Icons.add_rounded,
                size: 22, color: AppTheme.darkBackground),
            label: const Text(
              'New Record',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.darkBackground,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.darkPrimary,
              elevation: 0,
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
        color: AppTheme.darkSecondary,
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
              color: color.withOpacity(0.15),
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
              color: AppTheme.darkText,
            ),
          ),
        ],
      ),
    );
  }
}