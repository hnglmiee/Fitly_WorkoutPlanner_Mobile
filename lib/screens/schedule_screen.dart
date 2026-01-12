import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/screens/profile_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/training_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/plan_progress_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/plan_history_screen.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';
import '../models/workout_schedule.dart';
import '../models/workout_plan.dart';
import '../services/workout_schedule_service.dart';
import '../services/workout_plan_service.dart';
import '../shared/navigation_bar.dart';
import '../shared/schedule_calendar.dart';
import 'add_plan.dart';
import 'goal_progress.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();
  int _selectedIndex = 1;

  List<WorkoutSchedule> schedules = [];
  List<WorkoutSchedule> filteredSchedules = [];
  List<WorkoutPlan> cachedPlans = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    try {
      final plans = await WorkoutPlanService.fetchMyPlans();
      if (mounted) {
        setState(() {
          cachedPlans = plans;
        });
      }
      debugPrint('✅ Cached ${plans.length} plans');
    } catch (e) {
      debugPrint('⚠️ Error caching plans: $e');
    }
  }

  Future<void> _loadSchedules() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await WorkoutScheduleService.getAllSchedules();

      setState(() {
        schedules = data;
        _filterSchedules();
        _isLoading = false;
      });

      debugPrint('✅ Loaded ${schedules.length} schedules');
      debugPrint('✅ Filtered to ${filteredSchedules.length} current schedules');
    } catch (e) {
      debugPrint('❌ Error loading schedules: $e');

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading schedules: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Filter schedules: only show from last week onwards
  void _filterSchedules() {
    final now = DateTime.now();
    final lastWeekStart = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7));

    filteredSchedules = schedules.where((schedule) {
      final scheduleDate = DateTime(
        schedule.scheduledDate.year,
        schedule.scheduledDate.month,
        schedule.scheduledDate.day,
      );
      return scheduleDate.isAfter(lastWeekStart) || scheduleDate.isAtSameMomentAs(lastWeekStart);
    }).toList();
  }

  void _onNavTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

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

  /// Navigate to Plan Progress Screen
  Future<void> _navigateToPlanProgress(WorkoutSchedule schedule) async {
    if (schedule.id == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid schedule ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppTheme.primary),
              const SizedBox(height: 16),
              const Text(
                'Loading plan...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      WorkoutPlan? matchedPlan;

      // ✅ Try to find in cache first
      try {
        matchedPlan = cachedPlans.firstWhere(
              (plan) => plan.title == schedule.planName,
        );
        debugPrint('✅ Found plan in cache: ${matchedPlan.title}');
      } catch (e) {
        debugPrint('⚠️ Plan not found in cache, fetching from API...');

        // Fetch from API if not in cache
        final allPlans = await WorkoutPlanService.fetchMyPlans();

        // Update cache
        if (mounted) {
          setState(() {
            cachedPlans = allPlans;
          });
        }

        matchedPlan = allPlans.firstWhere(
              (plan) => plan.title == schedule.planName,
          orElse: () => throw Exception('Plan not found: ${schedule.planName}'),
        );

        debugPrint('✅ Found plan from API: ${matchedPlan.title}');
      }

      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      // ✅ CRITICAL: Navigate with BOTH plan and scheduleId
      if (mounted) {
        debugPrint('🔵 Navigating to PlanProgressScreen');
        debugPrint('  Plan ID: ${matchedPlan.id}');
        debugPrint('  Plan Title: ${matchedPlan.title}');
        debugPrint('  Schedule ID: ${schedule.id}');

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanProgressScreen(
              plan: matchedPlan!,
              scheduleId: schedule.id,
            ),
          ),
        );

        // Reload after returning
        _loadSchedules();
      }
    } catch (e) {
      debugPrint('❌ Error loading plan: $e');

      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Failed to load plan: ${e.toString()}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.transparent,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TrainingScreen(),
                        ),
                      );
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Schedule',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // History button
                  IconButton(
                    icon: Icon(
                      Icons.history,
                      color: AppTheme.primary,
                      size: 24,
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlanHistoryScreen(),
                        ),
                      );
                      // Reload after returning from history
                      _loadSchedules();
                    },
                  ),
                ],
              ),
            ),

            /// CALENDAR
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ScheduleCalendar(
                selectedDate: selectedDate,
                currentMonth: currentMonth,
                onDateSelected: (date) {
                  setState(() => selectedDate = date);
                },
                onPrevMonth: () {
                  setState(() {
                    currentMonth = DateTime(
                      currentMonth.year,
                      currentMonth.month - 1,
                    );
                  });
                },
                onNextMonth: () {
                  setState(() {
                    currentMonth = DateTime(
                      currentMonth.year,
                      currentMonth.month + 1,
                    );
                  });
                },
              ),
            ),

            const SizedBox(height: 12),

            /// ADD PLAN HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Plans',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Material(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddPlanScreen(
                              selectedDate: selectedDate,
                            ),
                          ),
                        );

                        if (result == true) {
                          _loadSchedules();
                          _loadPlans();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Add Plan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            /// SCHEDULES LIST (Filtered)
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredSchedules.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fitness_center_outlined,
                      size: 64,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No workout plans yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap "Add Plan" to create your first plan',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: _buildSchedulesByDay(filteredSchedules),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSchedulesByDay(List<WorkoutSchedule> schedules) {
    final Map<DateTime, List<WorkoutSchedule>> grouped = {};

    for (final schedule in schedules) {
      final date = schedule.scheduledDate;
      final dateKey = DateTime(date.year, date.month, date.day);
      grouped.putIfAbsent(dateKey, () => []).add(schedule);
    }

    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return sortedDates.expand((date) {
      final daySchedules = grouped[date]!;

      return [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('EEEE, MMM dd').format(date),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        ...daySchedules.map((schedule) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _scheduleCard(schedule),
          );
        }),
      ];
    }).toList();
  }

  Widget _scheduleCard(WorkoutSchedule schedule) {
    return Dismissible(
      key: Key(schedule.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade700],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.delete_outline, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: const [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 28,
                ),
                SizedBox(width: 12),
                Text('Delete Schedule'),
              ],
            ),
            content: const Text(
              'Are you sure you want to delete this schedule?',
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        final deletedSchedule = schedule;
        final deletedIndex = filteredSchedules.indexOf(schedule);

        setState(() {
          schedules.removeWhere((s) => s.id == schedule.id);
          filteredSchedules.removeWhere((s) => s.id == schedule.id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Schedule deleted',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  schedules.add(deletedSchedule);
                  schedules.sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
                  filteredSchedules.insert(deletedIndex, deletedSchedule);
                });
              },
            ),
          ),
        );

        try {
          await WorkoutScheduleService.deleteSchedule(schedule.id);
        } catch (e) {
          debugPrint('Error deleting schedule: $e');
          if (mounted) {
            setState(() {
              schedules.add(deletedSchedule);
              schedules.sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
              filteredSchedules.insert(deletedIndex, deletedSchedule);
            });
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _navigateToPlanProgress(schedule),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.fitness_center,
                      size: 20,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schedule.planName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (schedule.scheduledTime != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('HH:mm')
                                    .format(schedule.scheduledTime!),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _statusTag(schedule.status),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusTag(String status) {
    Color tagColor;
    String displayText = status;

    switch (status.toLowerCase()) {
      case 'completed':
        tagColor = Colors.green;
        displayText = 'Completed';
        break;
      case 'pending':
        tagColor = Colors.grey;
        displayText = 'Pending';
        break;
      case 'upcoming':
        tagColor = Colors.blue;
        displayText = 'Upcoming';
        break;
      case 'skipped':
        tagColor = Colors.orange;
        displayText = 'Skipped';
        break;
      default:
        tagColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: tagColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          fontSize: 11,
          color: tagColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}