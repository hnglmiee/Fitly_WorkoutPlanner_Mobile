import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/screens/plan_progress_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/profile_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/training_screen.dart';
import '../models/schedule_plan.dart';
import '../shared/navigation_bar.dart';
import '../shared/schedule_calendar.dart';
import '../shared/schedule_plan_item.dart';
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
    plans = _mockPlans();
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
        transitionDuration: Duration.zero, // 🚫 không animation
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => nextScreen,
      ),
    );
  }

  List<SchedulePlan> _mockPlans() {
    return [
      SchedulePlan(
        date: DateTime(currentMonth.year, currentMonth.month, 10),
        title: 'Lose weight, gain muscle',
        description: 'High intensity workout for fat reduction',
        tag: 'Cardio',
        backgroundColor: const Color(0xFFE9F9EE),
        dayLabel: '',
      ),
      SchedulePlan(
        date: DateTime(currentMonth.year, currentMonth.month, 11),
        title: 'Fat Loss Plan',
        description: 'High intensity workout for fat reduction',
        tag: 'Cardio',
        backgroundColor: const Color(0xFFEAF3FF),
        outlined: true,
        dayLabel: '',
      ),
      SchedulePlan(
        date: DateTime(currentMonth.year, currentMonth.month, 12),
        title: 'High intensity workout',
        description: 'High intensity workout for fat reduction',
        tag: 'Cardio',
        backgroundColor: const Color(0xFFF1EFFF),
        dayLabel: '',
      ),
    ];
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
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

              const SizedBox(height: 16),

              /// CALENDAR
              ScheduleCalendar(
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

              const SizedBox(height: 16),

              /// ADD PLAN
              Row(
                children: const [
                  Text(
                    'Add plan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.add),
                ],
              ),

              const SizedBox(height: 16),

              /// PLANS
              Expanded(
                child:
                    filteredPlans.isNotEmpty
                        ? ListView.builder(
                          itemCount: filteredPlans.length,
                          itemBuilder: (context, index) {
                            final plan = filteredPlans[index];

                            return Column(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                PlanProgressScreen(plan: plan),
                                      ),
                                    );
                                  },
                                  child: SchedulePlanItem(plan: plan),
                                ),
                                if (index != filteredPlans.length - 1)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Divider(
                                      height: 1,
                                      thickness: 0.8,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                              ],
                            );
                          },
                        )
                        : ListView(children: _buildPlansByDay(plans)),
              ),
            ],
          ),
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

      return dayPlans.map((plan) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dayLabel(
              DateFormat('EEE').format(date),
              DateFormat('dd').format(date),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlanProgressScreen(plan: plan),
                    ),
                  );
                },
                child: SchedulePlanItem(plan: plan),
              ),
            ),
          ],
        );
      });
    }).toList();
  }

  Widget _dayLabel(String day, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 12),
      child: SizedBox(
        width: 28,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(day, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
