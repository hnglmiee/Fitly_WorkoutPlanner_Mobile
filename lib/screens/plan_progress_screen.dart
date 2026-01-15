import 'package:flutter/material.dart';

import '../models/WorkoutMock.dart';
import '../models/exercise_log.dart';
import '../models/workout_log.dart';
import '../models/workout_plan.dart';
import '../services/workout_exercise_service.dart';
import '../services/workout_log_service.dart';
import '../shared/workout_card.dart';
import '../theme/app_theme.dart';
import 'plan_history_screen.dart';
import 'edit_plan_screen.dart';

class PlanProgressScreen extends StatefulWidget {
  final WorkoutPlan plan;
  final int scheduleId;

  const PlanProgressScreen({
    super.key,
    required this.plan,
    required this.scheduleId,
  });

  @override
  State<PlanProgressScreen> createState() => _PlanProgressScreenState();
}

class _PlanProgressScreenState extends State<PlanProgressScreen> {
  int activeWorkoutIndex = 0;
  List<WorkoutMock> workouts = [];
  Set<int> completedWorkouts = {};
  Map<int, ExerciseLog?> exerciseLogs = {};
  Map<int, int> exerciseIdMap = {};

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    debugPrint('🔵 PlanProgressScreen initialized');
    debugPrint('  Plan ID: ${widget.plan.id}');
    debugPrint('  Schedule ID: ${widget.scheduleId}');
    _loadExercises();
  }

  /// Load exercises và tạo mapping
  Future<void> _loadExercises() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final allExercises = await WorkoutExerciseService.fetchMyWorkoutExercises();
      final planExercises = WorkoutExerciseService.filterExercisesByPlanId(
        allExercises,
        widget.plan.id,
      );

      // ✅ LOAD EXISTING LOGS FROM API
      final logsFromAPI = await WorkoutLogService.fetchLogsBySchedule(widget.scheduleId);
      debugPrint('✅ Loaded ${logsFromAPI.length} existing logs from API for schedule ${widget.scheduleId}');

      // Convert và tạo mapping
      final List<WorkoutMock> loadedWorkouts = [];
      exerciseIdMap.clear();
      exerciseLogs.clear();
      completedWorkouts.clear();

      for (int i = 0; i < planExercises.length; i++) {
        final exercise = planExercises[i];

        loadedWorkouts.add(WorkoutMock(
          image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSh4_YJj0WHX1lBkMo9uY5jytsD6VjEFXy41Q&s',
          title: exercise.exerciseName,
          sets: '${exercise.sets} sets',
          reps: '${exercise.reps} reps',
        ));

        debugPrint('=== Exercise $i Debug ===');
        debugPrint('  workoutExerciseId: ${exercise.workoutExerciseId}');
        debugPrint('  exerciseId (MASTER): ${exercise.exerciseId}');
        debugPrint('  exerciseName: ${exercise.exerciseName}');

        // ✅ Map index -> exerciseId (MASTER TABLE ID)
        exerciseIdMap[i] = exercise.exerciseId;

        // ✅ CHECK IF THIS EXERCISE HAS EXISTING LOG
        if (logsFromAPI.containsKey(exercise.exerciseId)) {
          final apiLog = logsFromAPI[exercise.exerciseId]!;

          // 🔥 IMPORTANT: Store actual log ID from API
          exerciseLogs[i] = ExerciseLog(
            sets: apiLog.actualSets,
            reps: apiLog.actualReps,
            weight: apiLog.actualWeight,
            notes: apiLog.notes,
            loggedAt: apiLog.loggedAt,
            logId: apiLog.id, // 🔥 Use actual ID from API
          );

          completedWorkouts.add(i);
          debugPrint('  ✅ Exercise $i already logged:');
          debugPrint('     Name: ${exercise.exerciseName}');
          debugPrint('     Sets: ${apiLog.actualSets}, Reps: ${apiLog.actualReps}, Weight: ${apiLog.actualWeight}kg');
          debugPrint('     📌 LOG ID FROM API: ${apiLog.id}');
        }
      }

      setState(() {
        workouts = loadedWorkouts;
        isLoading = false;
      });

      debugPrint('✅ Loaded ${workouts.length} exercises for plan ID: ${widget.plan.id}');
      debugPrint('✅ Completed: ${completedWorkouts.length} exercises');
    } catch (e) {
      debugPrint('❌ Error loading exercises: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load exercises: $e';
        workouts = [];
      });
    }
  }

  int get completedCount => completedWorkouts.length;
  int get totalWorkouts => workouts.length;
  double get progressPercentage =>
      totalWorkouts > 0 ? (completedCount / totalWorkouts) * 100 : 0;

  /// ✅ Log exercise - UPDATE nếu đã có log, CREATE nếu chưa
  Future<void> _logExercise({
    required int index,
    required int sets,
    required int reps,
    required double weight,
    required String notes,
  }) async {
    try {
      // Show loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Saving workout log...'),
              ],
            ),
            duration: const Duration(seconds: 30),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      final exerciseId = exerciseIdMap[index];
      if (exerciseId == null) {
        throw Exception('Exercise ID not found for index $index');
      }

      debugPrint('🔵 ========================================');
      debugPrint('🔵 Logging exercise at index $index');
      debugPrint('  Schedule ID: ${widget.scheduleId}');
      debugPrint('  Exercise ID (master): $exerciseId');
      debugPrint('  New values: Sets=$sets, Reps=$reps, Weight=$weight kg');

      final existingLog = exerciseLogs[index];

      // 🔥 FIX: Check both existingLog AND logId are not null
      final isUpdate = existingLog != null && existingLog.logId != null && existingLog.logId! > 0;

      debugPrint('🔵 ========== UPDATE CHECK ==========');
      debugPrint('🔵 Exercise index: $index');
      debugPrint('🔵 Existing log: ${existingLog != null ? "EXISTS" : "NULL"}');
      if (existingLog != null) {
        debugPrint('🔵 Existing log ID: ${existingLog.logId}');
        debugPrint('🔵 Existing sets: ${existingLog.sets}, reps: ${existingLog.reps}, weight: ${existingLog.weight}');
      }
      debugPrint('🔵 Is update operation: $isUpdate');
      debugPrint('🔵 ==================================');

      if (isUpdate) {
        // 🔥 UPDATE existing log
        final logId = existingLog.logId!;

        debugPrint('🔥 ========== UPDATING EXISTING LOG ==========');
        debugPrint('🔥 HTTP Method: PUT');
        debugPrint('🔥 Endpoint: /workout-logs/$logId');
        debugPrint('🔥 Log ID: $logId');
        debugPrint('🔥 Schedule ID: ${widget.scheduleId}');
        debugPrint('🔥 Exercise ID: $exerciseId');
        debugPrint('🔥 New Sets: $sets, Reps: $reps, Weight: $weight kg');
        debugPrint('🔥 Notes: $notes');
        debugPrint('🔥 ==========================================');

        await WorkoutLogService.updateWorkoutLog(
          logId: logId,
          scheduleId: widget.scheduleId,
          exerciseId: exerciseId,
          actualSets: sets,
          actualReps: reps,
          actualWeight: weight,
          notes: notes,
        );

        debugPrint('✅ Workout log UPDATED successfully');
      } else {
        // 🔥 CREATE new log
        debugPrint('🔥 ========== CREATING NEW LOG ==========');
        debugPrint('🔥 HTTP Method: POST');
        debugPrint('🔥 Endpoint: /workout-logs');
        debugPrint('🔥 Schedule ID: ${widget.scheduleId}');
        debugPrint('🔥 Exercise ID: $exerciseId');
        debugPrint('🔥 Sets: $sets, Reps: $reps, Weight: $weight kg');
        debugPrint('🔥 Notes: $notes');
        debugPrint('🔥 =====================================');

        await WorkoutLogService.logWorkout(
          scheduleId: widget.scheduleId,
          exerciseId: exerciseId,
          actualSets: sets,
          actualReps: reps,
          actualWeight: weight,
          notes: notes,
        );

        debugPrint('✅ Workout log CREATED successfully');
      }

      // Hide loading snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      // 🔥 CRITICAL: Reload logs từ API để lấy ID chính xác
      debugPrint('🔵 Reloading logs from API to get correct ID...');
      final updatedLogs = await WorkoutLogService.fetchLogsBySchedule(widget.scheduleId);
      final updatedLog = updatedLogs[exerciseId];

      debugPrint('🔵 Updated log for exerciseId $exerciseId:');
      debugPrint('   ID: ${updatedLog?.id}');
      debugPrint('   Sets: ${updatedLog?.actualSets}, Reps: ${updatedLog?.actualReps}');

      // Update local state with correct ID
      setState(() {
        if (updatedLog != null) {
          exerciseLogs[index] = ExerciseLog(
            sets: updatedLog.actualSets,
            reps: updatedLog.actualReps,
            weight: updatedLog.actualWeight,
            notes: updatedLog.notes,
            loggedAt: updatedLog.loggedAt,
            logId: updatedLog.id, // 🔥 Get CORRECT ID from fresh API call
          );
          debugPrint('✅ Stored correct log ID: ${updatedLog.id}');
        } else {
          debugPrint('⚠️ Could not reload log from API');
        }
        completedWorkouts.add(index);

        // Move to next exercise
        if (index < workouts.length - 1) {
          activeWorkoutIndex = index + 1;
        }
      });

      debugPrint('🔵 ========================================');

      // Show success
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Text('Exercise logged successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ ========================================');
      debugPrint('❌ Error logging exercise: $e');
      debugPrint('❌ ========================================');

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to log exercise: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  /// Dialog để log exercise
  void _showExerciseLogDialog(int index, {ExerciseLog? existingLog}) {
    final setsController = TextEditingController(
      text: existingLog?.sets.toString() ?? '',
    );
    final repsController = TextEditingController(
      text: existingLog?.reps.toString() ?? '',
    );
    final weightController = TextEditingController(
      text: existingLog?.weight.toString() ?? '',
    );
    final notesController = TextEditingController(
      text: existingLog?.notes ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              existingLog == null
                                  ? 'Log Exercise'
                                  : 'Edit Exercise Log',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              workouts[index].title,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Form fields
                  _dialogLabel('Actual Sets'),
                  _dialogNumberInput(
                    controller: setsController,
                    hint: 'e.g. 3',
                    suffix: 'sets',
                  ),
                  const SizedBox(height: 16),

                  _dialogLabel('Actual Reps'),
                  _dialogNumberInput(
                    controller: repsController,
                    hint: 'e.g. 12',
                    suffix: 'reps',
                  ),
                  const SizedBox(height: 16),

                  _dialogLabel('Weight (kg)'),
                  _dialogNumberInput(
                    controller: weightController,
                    hint: 'e.g. 20',
                    suffix: 'kg',
                  ),
                  const SizedBox(height: 16),

                  _dialogLabel('Notes (Optional)'),
                  const SizedBox(height: 5),
                  TextField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Add any notes about this exercise...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.all(14),
                      enabledBorder: _dialogBorder(Colors.grey.shade300),
                      focusedBorder: _dialogBorder(AppTheme.primary),
                      errorBorder: _dialogBorder(Colors.red),
                      focusedErrorBorder: _dialogBorder(Colors.red),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Validation
                        if (setsController.text.isEmpty ||
                            repsController.text.isEmpty ||
                            weightController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                              const Text('Please fill all required fields'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                          return;
                        }

                        // Close dialog first
                        Navigator.pop(context);

                        // Call API to log exercise
                        await _logExercise(
                          index: index,
                          sets: int.parse(setsController.text),
                          reps: int.parse(repsController.text),
                          weight: double.parse(weightController.text),
                          notes: notesController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        existingLog == null ? 'Save Record' : 'Update Record',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dialogLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  OutlineInputBorder _dialogBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  Widget _dialogNumberInput({
    required TextEditingController controller,
    String? hint,
    String? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        suffixText: suffix,
        suffixStyle: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.all(14),
        enabledBorder: _dialogBorder(Colors.grey.shade300),
        focusedBorder: _dialogBorder(AppTheme.primary),
        errorBorder: _dialogBorder(Colors.red),
        focusedErrorBorder: _dialogBorder(Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Plan Progress",
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
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditPlanScreen(plan: widget.plan),
                        ),
                      );

                      // Reload nếu plan đã được update
                      if (result == true && mounted) {
                        _loadExercises();
                      }
                    },
                    tooltip: 'Edit Plan',
                  ),
                ],
              ),
            ),

            /// CONTENT
            Expanded(
              child: isLoading
                  ? _buildLoadingState()
                  : errorMessage != null
                  ? _buildErrorState()
                  : workouts.isEmpty
                  ? _buildEmptyState()
                  : _buildContentState(),
            ),
          ],
        ),
      ),
    );
  }

  /// Loading State
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppTheme.primary),
          const SizedBox(height: 16),
          Text(
            'Loading exercises...',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  /// Error State
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'Unknown error',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadExercises,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label:
              const Text('Retry', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty State
  Widget _buildEmptyState() {
    return Center(
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
            'No exercises in this plan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add exercises to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  /// Content State
  Widget _buildContentState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// PLAN INFO CARD
          Container(
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
                Row(
                  children: [
                    /// ICON
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.fitness_center,
                        color: AppTheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),

                    /// PLAN NAME
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.plan.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.plan.notes.isNotEmpty
                                ? widget.plan.notes
                                : "No description",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// PROGRESS BAR
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Progress",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          "$completedCount / $totalWorkouts exercises",
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
                      child: LinearProgressIndicator(
                        value: progressPercentage / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.primary),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// SECTION TITLE WITH COUNTER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Exercises',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${activeWorkoutIndex + 1} / ${workouts.length}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// WORKOUT CARDS
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              final isCompleted = completedWorkouts.contains(index);
              final isActive = index == activeWorkoutIndex;
              final log = exerciseLogs[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: WorkoutCard(
                  image: workout.image,
                  title: workout.title,
                  sets: workout.sets,
                  reps: workout.reps,
                  active: isActive,
                  completed: isCompleted,
                  exerciseNumber: index + 1,
                  loggedData: log,
                  onStart: () {
                    if (isActive && !isCompleted) {
                      _showExerciseLogDialog(index);
                    } else if (!isCompleted) {
                      setState(() {
                        activeWorkoutIndex = index;
                      });
                    }
                  },
                  onEdit: log != null
                      ? () {
                    _showExerciseLogDialog(index, existingLog: log);
                  }
                      : null,
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          /// COMPLETE BUTTON
          if (completedWorkouts.length == workouts.length &&
              workouts.isNotEmpty)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Workout completed! 🎉'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check_circle, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Complete Workout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}