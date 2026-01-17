// lib/screens/goal_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';
import '../models/goal_progress.dart';
import '../services/goal_service.dart';

class GoalDetailScreen extends StatefulWidget {
  final GoalProgress goalProgress;

  const GoalDetailScreen({super.key, required this.goalProgress});

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  late GoalProgress currentGoal;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentGoal = widget.goalProgress;
    _refreshGoalData();
  }

  Future<void> _refreshGoalData() async {
    setState(() => isLoading = true);

    try {
      final allGoals = await GoalService.fetchAllGoals();
      final updatedGoal = allGoals.firstWhere(
            (g) => g.id == currentGoal.id,
        orElse: () => currentGoal,
      );

      if (mounted) {
        setState(() {
          currentGoal = updatedGoal;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error refreshing goal: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Color get statusColor {
    switch (currentGoal.goal.status.toUpperCase()) {
      case 'COMPLETED':
        return Colors.green.shade400;
      case 'ACTIVE':
      case 'IN_PROGRESS':
        return Colors.orange.shade400;
      case 'CANCELED':
        return Colors.red.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  String get statusText {
    switch (currentGoal.goal.status.toUpperCase()) {
      case 'COMPLETED':
        return 'Completed';
      case 'ACTIVE':
        return 'Active';
      case 'IN_PROGRESS':
        return 'In Progress';
      case 'CANCELED':
        return 'Canceled';
      default:
        return currentGoal.goal.status;
    }
  }

  IconData get statusIcon {
    switch (currentGoal.goal.status.toUpperCase()) {
      case 'COMPLETED':
        return Icons.check_circle;
      case 'ACTIVE':
      case 'IN_PROGRESS':
        return Icons.access_time;
      case 'CANCELED':
        return Icons.cancel;
      default:
        return Icons.flag;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppTheme.darkBackground,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        size: 18, color: AppTheme.darkText),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Goal Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkText,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      size: 20,
                      color: isLoading
                          ? Colors.grey.shade600
                          : AppTheme.darkPrimary,
                    ),
                    onPressed: isLoading ? null : _refreshGoalData,
                  ),
                ],
              ),
            ),

            /// CONTENT
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshGoalData,
                color: AppTheme.darkPrimary,
                backgroundColor: AppTheme.darkSecondary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// GOAL HEADER CARD
                      _buildHeaderCard(),
                      const SizedBox(height: 24),

                      /// STATISTICS CARDS
                      _buildStatisticsRow(),
                      const SizedBox(height: 24),

                      /// PROGRESS SECTION
                      _buildProgressSection(),
                      const SizedBox(height: 24),

                      /// TARGET METRICS
                      _buildTargetMetrics(),
                      const SizedBox(height: 24),

                      /// TIMELINE SECTION
                      _buildTimelineSection(),

                      /// NOTES (if available)
                      if (currentGoal.goal.notes.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildNotesSection(),
                      ],

                      /// INBODY DATA (if available)
                      if (currentGoal.lastestInBody != null) ...[
                        const SizedBox(height: 24),
                        _buildInBodySection(),
                      ],

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.darkThird,
            AppTheme.darkThird.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkThird.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.darkBackground.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentGoal.goal.goalType.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      statusIcon,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            currentGoal.goal.goalName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildHeaderStat(
                Icons.calendar_today,
                '${DateFormat('MMM d').format(currentGoal.goal.startDate)} - ${DateFormat('MMM d, y').format(currentGoal.goal.endDate)}',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildHeaderStat(
                Icons.tag,
                'Goal ID: ${currentGoal.id}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsRow() {
    final duration = currentGoal.goal.endDate
        .difference(currentGoal.goal.startDate)
        .inDays;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            Icons.fitness_center,
            'Workouts',
            '${currentGoal.completedWorkouts}/${currentGoal.totalWorkouts}',
            Colors.blue.shade400,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            Icons.timer_outlined,
            'Duration',
            '$duration days',
            Colors.orange.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkSecondary,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Progress Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: AppTheme.darkText,
            ),
          ),
          const SizedBox(height: 16),

          /// Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: currentGoal.progressPercentage / 100,
              backgroundColor: AppTheme.darkThird,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.darkPrimary),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${currentGoal.progressPercentage.toStringAsFixed(1)}% Complete',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkPrimary,
                ),
              ),
              Text(
                '${currentGoal.completedWorkouts}/${currentGoal.totalWorkouts} workouts',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: AppTheme.darkThird),
          const SizedBox(height: 16),

          /// This Week Stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkPrimary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.darkPrimary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    color: AppTheme.darkPrimary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This Week',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${currentGoal.workoutSessionThisWeek} workout${currentGoal.workoutSessionThisWeek != 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkText,
                        ),
                      ),
                    ],
                  ),
                ),
                if (currentGoal.goal.targetWorkoutSessionsPerWeek != null)
                  Text(
                    'Target: ${currentGoal.goal.targetWorkoutSessionsPerWeek}/week',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetMetrics() {
    final goal = currentGoal.goal;
    final hasTargets = goal.targetWeight != null ||
        goal.targetBodyFatPercentage != null ||
        goal.targetMuscleMass != null ||
        goal.targetWorkoutSessionsPerWeek != null ||
        goal.targetCaloriesPerDay != null;

    if (!hasTargets) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Target Metrics'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.darkSecondary,
            borderRadius: BorderRadius.circular(16),
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
              if (goal.targetWeight != null)
                _buildTargetItem(
                  icon: Icons.monitor_weight,
                  label: 'Target Weight',
                  value: '${goal.targetWeight} kg',
                  color: Colors.blue.shade400,
                ),
              if (goal.targetBodyFatPercentage != null)
                _buildTargetItem(
                  icon: Icons.trending_down,
                  label: 'Target Body Fat',
                  value: '${goal.targetBodyFatPercentage}%',
                  color: Colors.orange.shade400,
                ),
              if (goal.targetMuscleMass != null)
                _buildTargetItem(
                  icon: Icons.fitness_center,
                  label: 'Target Muscle Mass',
                  value: '${goal.targetMuscleMass} kg',
                  color: Colors.green.shade400,
                ),
              if (goal.targetWorkoutSessionsPerWeek != null)
                _buildTargetItem(
                  icon: Icons.event_repeat,
                  label: 'Workouts Per Week',
                  value: '${goal.targetWorkoutSessionsPerWeek} sessions',
                  color: Colors.purple.shade400,
                ),
              if (goal.targetCaloriesPerDay != null)
                _buildTargetItem(
                  icon: Icons.local_fire_department,
                  label: 'Daily Calories',
                  value: '${goal.targetCaloriesPerDay} kcal',
                  color: Colors.red.shade400,
                  isLast: true,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineSection() {
    final goal = currentGoal.goal;
    final duration = goal.endDate.difference(goal.startDate).inDays;
    final daysLeft = goal.endDate.difference(DateTime.now()).inDays;
    final daysElapsed = DateTime.now().difference(goal.startDate).inDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Timeline'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.darkSecondary,
            borderRadius: BorderRadius.circular(16),
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
              _buildTimelineItem(
                icon: Icons.play_circle_outline,
                label: 'Start Date',
                value: DateFormat('MMM dd, yyyy').format(goal.startDate),
              ),
              _buildTimelineItem(
                icon: Icons.flag,
                label: 'End Date',
                value: DateFormat('MMM dd, yyyy').format(goal.endDate),
              ),
              _buildTimelineItem(
                icon: Icons.timelapse,
                label: 'Total Duration',
                value: '$duration days',
              ),
              if (daysLeft > 0)
                _buildTimelineItem(
                  icon: Icons.schedule,
                  label: 'Days Remaining',
                  value: '$daysLeft days',
                )
              else
                _buildTimelineItem(
                  icon: Icons.check_circle_outline,
                  label: 'Status',
                  value: 'Goal period ended',
                ),
              if (daysElapsed >= 0)
                _buildTimelineItem(
                  icon: Icons.history,
                  label: 'Days Elapsed',
                  value:
                  '${daysElapsed > duration ? duration : daysElapsed} days',
                  isLast: true,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Notes'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade900.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amber.shade700.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.sticky_note_2_outlined,
                size: 20,
                color: Colors.amber.shade400,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  currentGoal.goal.notes,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.darkText,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInBodySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Latest InBody Measurement'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.darkSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.darkThird),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.monitor_heart_outlined,
                size: 20,
                color: AppTheme.darkPrimary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'InBody data available',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white.withOpacity(0.9)),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      IconData icon,
      String label,
      String value,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkSecondary,
        borderRadius: BorderRadius.circular(16),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: AppTheme.darkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.darkPrimary, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppTheme.darkText,
      ),
    );
  }
}