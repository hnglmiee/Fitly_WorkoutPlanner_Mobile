import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker_mini_project_mobile/screens/goal_progress.dart';
import 'package:workout_tracker_mini_project_mobile/screens/profile_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/schedule_screen.dart';
import 'package:workout_tracker_mini_project_mobile/shared/navigation_bar.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';

import '../models/user_info.dart';
import '../models/workout_plan.dart';
import '../models/workout_chart_item.dart';
import '../services/user_service.dart';
import '../services/workout_chart_service.dart';
import '../services/workout_plan_service.dart';
import 'notification_screen.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  int selectedDayIndex = 2;
  int _selectedIndex = 0;
  int unreadNotifications = 3;
  Future<List<WorkoutPlan>>? _plansFuture;
  Future<List<WorkoutChartItem>>? _chartFuture;

  late PageController _pageController;

  List<DateTime> weekDates = [];
  int weekOffset = 0;

  final ScrollController _weekScrollController = ScrollController();

  UserInfo? userInfo;
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _initWeek();
    _pageController = PageController(initialPage: 0);
    _plansFuture = WorkoutPlanService.fetchMyPlans();
    _chartFuture = WorkoutService.fetchWeeklyWorkoutChart();
    _fetchUserInfo();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCenter(selectedDayIndex);
    });
  }

  void _initWeek() {
    final now = DateTime.now();
    final monday = now.subtract(
      Duration(days: now.weekday - 1 + weekOffset * 7),
    );

    weekDates = List.generate(7, (i) => monday.add(Duration(days: i)));

    selectedDayIndex = weekDates.indexWhere(
          (d) => d.year == now.year && d.month == now.month && d.day == now.day,
    );

    if (selectedDayIndex < 0) {
      selectedDayIndex = 0;
    }
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

  void _scrollToCenter(int index) {
    if (!_weekScrollController.hasClients) return;

    const double itemWidth = 72;
    final screenWidth = MediaQuery.of(context).size.width;

    final offset = index * itemWidth - (screenWidth / 2) + (itemWidth / 2);

    _weekScrollController.animateTo(
      offset.clamp(
        _weekScrollController.position.minScrollExtent,
        _weekScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _weekScrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Future<void> _fetchUserInfo() async {
    try {
      userInfo = await UserService.getMyInfo();
    } catch (e) {
      debugPrint("Error fetching user info: $e");
    } finally {
      setState(() => isLoadingUser = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (weekDates.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      );
    }

    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        child: CustomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onNavTapped,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello,',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isLoadingUser
                              ? 'Loading...'
                              : userInfo?.fullName ?? 'User',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),

                    // NOTIFICATION & AVATAR ROW
                    Row(
                      children: [
                        Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const NotificationScreen(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.notifications_outlined,
                                size: 32,
                                color: AppTheme.primary,
                              ),
                            ),
                            // Unread badge
                            if (unreadNotifications > 0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Center(
                                    child: Text(
                                      unreadNotifications > 9
                                          ? '9+'
                                          : unreadNotifications.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => _onNavTapped(3),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.primary.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1644845225271-4cd4f76a0631?q=80&w=1172&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TRAINING PLAN CALENDAR
                    const Text(
                      'Training Plan',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        controller: _weekScrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: weekDates.length,
                        itemBuilder: (context, index) {
                          final date = weekDates[index];
                          final isSelected = index == selectedDayIndex;
                          final isToday = _isToday(date);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDayIndex = index;
                              });
                              _scrollToCenter(index);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 5,
                                  width: 5,
                                  margin: const EdgeInsets.only(bottom: 6),
                                  decoration: BoxDecoration(
                                    color:
                                    isToday
                                        ? Colors.red
                                        : isSelected
                                        ? Colors.blue
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color:
                                    isSelected
                                        ? Colors.blue
                                        : Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat('EEE').format(date),
                                          style: TextStyle(
                                            color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          width: 45,
                                          height: 45,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              40,
                                            ),
                                            border: Border.all(
                                              color:
                                              isSelected
                                                  ? Colors.blue
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                          child: Text(
                                            date.day.toString(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// PLAN PROGRESS
                    FutureBuilder<List<WorkoutPlan>>(
                      future: _plansFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 200,
                            alignment: Alignment.center,
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
                            child: CircularProgressIndicator(
                              color: AppTheme.primary,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Container(
                            padding: const EdgeInsets.all(16),
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
                                const Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 12),
                                const Text('Failed to load workout plans'),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _plansFuture =
                                          WorkoutPlanService.fetchMyPlans();
                                    });
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(24),
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
                                Icon(
                                  Icons.fitness_center,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'No workout plans yet',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final plans = snapshot.data!;

                        if (plans.length >= 2) {
                          return SizedBox(
                            height: 230,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: plans.length,
                              itemBuilder: (context, index) {
                                final plan = plans[index];
                                return Container(
                                  width: MediaQuery.of(context).size.width - 32,
                                  margin: EdgeInsets.only(
                                    right: index < plans.length - 1 ? 12 : 0,
                                  ),
                                  child: _PlanCard(plan: plan),
                                );
                              },
                            ),
                          );
                        }

                        return _PlanCard(plan: plans.first);
                      },
                    ),

                    const SizedBox(height: 10),

                    /// MY ACTIVITIES
                    const Text(
                      'My Activities',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
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
                            label: 'Bench Press',
                          ),
                          _ModernActivityChip(
                            icon: Icons.directions_run,
                            label: 'Running',
                          ),
                          _ModernActivityChip(
                            icon: Icons.accessibility_new,
                            label: 'Squat',
                          ),
                          _ModernActivityChip(
                            icon: Icons.fitness_center,
                            label: 'Deadlift',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// DAILY PROGRESS
                    const Text(
                      'Daily Progress',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: const [
                        Expanded(
                          child: _ProgressCard(
                            icon: Icons.local_fire_department,
                            label: 'Calories',
                            value: '1,024',
                            unit: 'kcal',
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _ProgressCard(
                            icon: Icons.trending_up,
                            label: 'Streaks',
                            value: '2',
                            unit: 'days',
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // WORKOUT SESSIONS CHART
                    const Text(
                      'Weekly Workout Sessions',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    FutureBuilder<List<WorkoutChartItem>>(
                      future: _chartFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            height: 280,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.primary,
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 12),
                                const Text('Failed to load chart data'),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _chartFuture = WorkoutService.fetchWeeklyWorkoutChart();
                                    });
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }

                        final chartData = snapshot.data ?? [];

                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Sessions',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${chartData.fold<int>(0, (sum, item) => sum + item.sessions)} sessions',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              _WorkoutBarChart(data: chartData),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ NEW: Extracted Plan Card Widget
class _PlanCard extends StatelessWidget {
  final WorkoutPlan plan;

  const _PlanCard({required this.plan});

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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LEFT CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// STATUS BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'WORKOUT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// PLAN TITLE
                    Text(
                      plan.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    /// NOTES
                    Text(
                      plan.notes.isNotEmpty ? plan.notes : "No notes",
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
                        'https://plus.unsplash.com/premium_photo-1661962342128-505f8032ea45?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// CONTINUE BUTTON
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              minimumSize: const Size(double.infinity, 50),
              padding: const EdgeInsets.symmetric(horizontal: 15),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GoalProgressScreen()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Continue The Workout',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutBarChart extends StatelessWidget {
  final List<WorkoutChartItem> data;

  const _WorkoutBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      );
    }

    final maxSessions = data.fold<int>(
      0,
          (max, item) => item.sessions > max ? item.sessions : max,
    );

    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((item) {
          final sessions = item.sessions;
          final day = item.label;
          final barHeight =
          maxSessions > 0 ? (sessions / maxSessions) * 140 : 0.0;
          final isToday = day == DateFormat('EEE').format(DateTime.now());

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Session count label
                  SizedBox(
                    height: 20,
                    child: sessions > 0
                        ? Text(
                      sessions.toString(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 4),
                  // Bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: barHeight < 20 && sessions > 0 ? 20 : barHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: sessions > 0
                            ? [
                          AppTheme.primary,
                          AppTheme.primary.withOpacity(0.6),
                        ]
                            : [
                          Colors.grey.shade200,
                          Colors.grey.shade200,
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Day label
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                      color: isToday ? AppTheme.primary : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// MODERN ACTIVITY CHIP
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
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
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

/// PROGRESS CARD
class _ProgressCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _ProgressCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  height: 1,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}