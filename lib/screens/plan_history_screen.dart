import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/workout_plan.dart';
import '../models/workout_exercise.dart';
import '../network/dio_client.dart';
import '../services/workout_plan_service.dart';
import '../theme/app_theme.dart';

class PlanHistoryScreen extends StatefulWidget {
  const PlanHistoryScreen({super.key});

  @override
  State<PlanHistoryScreen> createState() => _PlanHistoryScreenState();
}

class _PlanHistoryScreenState extends State<PlanHistoryScreen> {
  List<WorkoutPlan> allPlans = [];
  Map<int, List<WorkoutExercise>> planExercisesMap = {};
  Map<int, bool> expandedMap = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Load plans and exercises in parallel
      await Future.wait([
        _loadPlans(),
        _loadExercises(),
      ]);
    } catch (e) {
      debugPrint('❌ Error loading data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Failed to load data: ${e.toString()}',
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
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadPlans() async {
    try {
      final plans = await WorkoutPlanService.fetchMyPlans();

      if (mounted) {
        setState(() {
          allPlans = plans;
        });
      }

      debugPrint('✅ Loaded ${plans.length} workout plans');
    } catch (e) {
      debugPrint('❌ Error loading plans: $e');
      rethrow;
    }
  }

  Future<void> _loadExercises() async {
    try {
      final response = await DioClient.dio.get('/workout-exercise/my-workout-exercise');

      debugPrint('📡 Response status: ${response.statusCode}');
      debugPrint('📦 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        // Check API response code
        final code = data['code'];
        if (code != null && code != 0 && code != 1000) {
          debugPrint('❌ API error: ${data['message']}');
          throw Exception(data['message'] ?? 'Failed to load exercises');
        }

        final List<dynamic> result = data['result'] ?? [];

        debugPrint('✅ Found ${result.length} workout exercises');

        // Group exercises by planId
        final Map<int, List<WorkoutExercise>> tempMap = {};

        for (var exerciseJson in result) {
          final exercise = WorkoutExercise.fromJson(exerciseJson);
          final planId = exerciseJson['planId'] as int;

          tempMap.putIfAbsent(planId, () => []).add(exercise);
        }

        if (mounted) {
          setState(() {
            planExercisesMap = tempMap;
          });
        }

        debugPrint('✅ Grouped exercises for ${planExercisesMap.length} plans');
        planExercisesMap.forEach((planId, exercises) {
          debugPrint('  Plan ID $planId: ${exercises.length} exercises');
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading exercises: $e');
      rethrow;
    }
  }

  Future<void> _deletePlan(WorkoutPlan plan) async {
    try {
      await WorkoutPlanService.deletePlan(plan.id);

      if (mounted) {
        setState(() {
          allPlans.removeWhere((p) => p.id == plan.id);
          planExercisesMap.remove(plan.id);
        });
      }

      debugPrint('✅ Plan deleted successfully');
    } catch (e) {
      debugPrint('❌ Error deleting plan: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Plans History',
          style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        )
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.refresh, color: Colors.black),
        //     onPressed: _loadData,
        //   ),
        // ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : allPlans.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No Workout Plans',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first workout plan to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: _buildPlansByMonth(allPlans),
        ),
      ),
    );
  }

  List<Widget> _buildPlansByMonth(List<WorkoutPlan> plans) {
    final Map<String, List<WorkoutPlan>> grouped = {};

    // Sort plans by date
    final sortedPlans = List<WorkoutPlan>.from(plans)
      ..sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));

    // Group by month
    for (final plan in sortedPlans) {
      final date = plan.createdAt ?? DateTime.now();
      final monthKey = DateFormat('MMMM yyyy').format(date);
      grouped.putIfAbsent(monthKey, () => []).add(plan);
    }

    // Build widgets
    return grouped.entries.expand((entry) {
      final month = entry.key;
      final monthPlans = entry.value;

      return [
        // Month Header
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 20,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                month,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primary.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Plans
        ...monthPlans.map((plan) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _planCard(plan),
          );
        }),
      ];
    }).toList();
  }

  Widget _planCard(WorkoutPlan plan) {
    final exercises = planExercisesMap[plan.id] ?? [];
    final isExpanded = expandedMap[plan.id] ?? false;
    final hasExercises = exercises.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main Card Content
          Dismissible(
            key: Key('plan_${plan.id}'),
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
                      Text('Delete Plan'),
                    ],
                  ),
                  content: Text(
                    'Are you sure you want to delete "${plan.title}"?',
                    style: const TextStyle(fontSize: 15),
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
              final deletedPlan = plan;
              final deletedIndex = allPlans.indexOf(plan);

              setState(() {
                allPlans.removeWhere((p) => p.id == plan.id);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Plan deleted',
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
                        allPlans.insert(deletedIndex, deletedPlan);
                      });
                    },
                  ),
                ),
              );

              try {
                await _deletePlan(plan);
              } catch (e) {
                debugPrint('Error deleting plan: $e');
                if (mounted) {
                  setState(() {
                    allPlans.insert(deletedIndex, deletedPlan);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete plan: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: hasExercises
                    ? () {
                  setState(() {
                    expandedMap[plan.id] = !isExpanded;
                  });
                }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Icon container
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primary.withOpacity(0.1),
                              AppTheme.primary.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.fitness_center,
                          size: 24,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            if (plan.notes.isNotEmpty) ...[
                              Text(
                                plan.notes,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                            ],
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 13,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('MMM dd, yyyy').format(
                                    plan.createdAt ?? DateTime.now(),
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (hasExercises) ...[
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.fitness_center,
                                    size: 13,
                                    color: AppTheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${exercises.length} exercise${exercises.length > 1 ? 's' : ''}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),
                      if (hasExercises)
                        Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.grey.shade400,
                          size: 24,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Expandable Exercise Details
          if (isExpanded && hasExercises)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Divider(height: 1, color: Colors.grey.shade200),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.list_alt,
                              size: 18,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Exercise Details',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...exercises.asMap().entries.map((entry) {
                          final index = entry.key;
                          final exercise = entry.value;
                          return _exerciseCard(exercise, index + 1);
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _exerciseCard(WorkoutExercise exercise, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise Name with Index
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  exercise.exerciseName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Stats Row
          Row(
            children: [
              _statChip(
                icon: Icons.repeat,
                label: 'Sets',
                value: '${exercise.sets}',
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              _statChip(
                icon: Icons.numbers,
                label: 'Reps',
                value: '${exercise.reps}',
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              _statChip(
                icon: Icons.fitness_center,
                label: 'Weight',
                value: exercise.weight != null ? '${exercise.weight}kg' : '-',
                color: Colors.orange,
              ),
            ],
          ),

          // Comments
          if (exercise.comments != null && exercise.comments!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      exercise.comments!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}