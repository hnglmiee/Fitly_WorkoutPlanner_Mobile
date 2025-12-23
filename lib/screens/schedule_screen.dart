import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/screens/plan_progress_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/profile_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/training_screen.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';
import '../models/schedule_plan.dart';
import '../services/schedule_service.dart';
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

  late List<SchedulePlan> plans;

  @override
  void initState() {
    super.initState();
    plans = [];
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    final data = await ScheduleService.fetchMyPlans();
    setState(() {
      plans = data;
    });
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
      case 2:
        nextScreen = const GoalProgressScreen();
        break;
      case 3:
        nextScreen = const ProfileScreen();
        break;
      case 1:
        nextScreen = const ScheduleScreen();
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
    final filteredPlans =
        plans
            .where(
              (p) =>
                  p.date.year == selectedDate.year &&
                  p.date.month == selectedDate.month &&
                  p.date.day == selectedDate.day,
            )
            .toList();

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
              color: Colors.white,
              child: Row(
                children: const [
                  Icon(Icons.arrow_back_ios_new, size: 18),
                  Expanded(
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
                  SizedBox(width: 24),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddPlanScreen(),
                          ),
                        );
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

            /// PLANS
            Expanded(
              child:
                  filteredPlans.isNotEmpty
                      ? ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredPlans.length,
                        itemBuilder: (context, index) {
                          final plan = filteredPlans[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _modernPlanCard(plan),
                          );
                        },
                      )
                      : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: _buildPlansByDay(plans),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modernPlanCard(SchedulePlan plan) {
    // Safely handle missing fields with fallbacks
    final title = plan.title;
    final description = plan.description ?? '';
    final tag = plan.tag ?? '';

    return Container(
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PlanProgressScreen(plan: plan)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            plan.backgroundColor?.withOpacity(0.1) ??
                            AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.fitness_center,
                        size: 20,
                        color: plan.backgroundColor ?? AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (description.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (tag.isNotEmpty) _customTag(tag),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customTag(String tag) {
    Color tagColor;

    switch (tag.toLowerCase()) {
      case 'completed':
        tagColor = Colors.green;
        break;
      case 'in progress':
        tagColor = Colors.orange;
        break;
      case 'upcoming':
        tagColor = Colors.blue;
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
        tag,
        style: TextStyle(
          fontSize: 11,
          color: tagColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<Widget> _buildPlansByDay(List<SchedulePlan> plans) {
    final Map<DateTime, List<SchedulePlan>> grouped = {};

    for (final plan in plans) {
      final dateKey = DateTime(plan.date.year, plan.date.month, plan.date.day);
      grouped.putIfAbsent(dateKey, () => []).add(plan);
    }

    final sortedDates = grouped.keys.toList()..sort();

    return sortedDates.expand((date) {
      final dayPlans = grouped[date]!;

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
        ...dayPlans.map((plan) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _modernPlanCard(plan),
          );
        }),
      ];
    }).toList();
  }
}
