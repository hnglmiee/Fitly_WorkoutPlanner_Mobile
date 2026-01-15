import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';
import '../models/exercise_form.dart';
import '../models/workout_plan.dart';
import '../services/workout_exercise_service.dart';

class EditPlanScreen extends StatefulWidget {
  final WorkoutPlan plan;

  const EditPlanScreen({super.key, required this.plan});

  @override
  State<EditPlanScreen> createState() => _EditPlanScreenState();
}

class _EditPlanScreenState extends State<EditPlanScreen> {
  /// FORM STATE
  late TextEditingController titleController;
  late TextEditingController notesController;

  bool everyDay = true;
  bool isLoading = false;

  /// EXERCISE DATA WITH PROPER IDs
  /// Structure: categoryId -> category name -> list of exercises with IDs
  final Map<int, Map<String, dynamic>> categoryMap = {
    1: {
      'name': 'Chest',
      'exercises': [
        {'id': 1, 'name': 'Bench Press'},
        {'id': 3, 'name': 'Push Up'},
        {'id': 5, 'name': 'Chest Fly'},
      ],
    },
    2: {
      'name': 'Legs',
      'exercises': [
        {'id': 2, 'name': 'Squat'},
        {'id': 4, 'name': 'Lunges'},
        {'id': 6, 'name': 'Leg Press'},
      ],
    },
    3: {
      'name': 'Back',
      'exercises': [
        {'id': 7, 'name': 'Pull Up'},
        {'id': 8, 'name': 'Deadlift'},
        {'id': 9, 'name': 'Lat Pulldown'},
      ],
    },
    4: {
      'name': 'Core',
      'exercises': [
        {'id': 10, 'name': 'Plank'},
        {'id': 11, 'name': 'Crunch'},
        {'id': 12, 'name': 'Russian Twist'},
      ],
    },
  };

  /// DAYS
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final Set<String> selectedDays = {};

  /// WEIGHT CONFIG
  final Map<String, double> muscleMaxWeight = {
    'Chest': 200,
    'Back': 300,
    'Legs': 500,
    'Core': 100,
  };

  /// REMINDER
  String reminder = 'Before 1 day';

  final List<String> reminderOptions = [
    'Before 1 day',
    'Before 2 days',
    'Before 3 days',
    'Before 1 week',
  ];

  List<ExerciseForm> exercises = [ExerciseForm()];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.plan.title);
    notesController = TextEditingController(text: widget.plan.notes);
  }

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// HEADER
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Edit Plan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// FORM
                  Expanded(
                    child: ListView(
                      children: [
                        _label('Plan Title'),
                        _input(
                          controller: titleController,
                          hint: 'e.g. Full Body Workout',
                        ),

                        const SizedBox(height: 20),

                        /// EXERCISES SECTION
                        _sectionHeader('Exercises'),
                        const SizedBox(height: 12),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: exercises.length,
                          itemBuilder: (context, index) {
                            return _exerciseItem(index);
                          },
                        ),

                        const SizedBox(height: 12),

                        /// ➕ ADD EXERCISE BUTTON
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppTheme.primary, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            setState(() {
                              exercises.add(ExerciseForm());
                            });
                          },
                          icon: Icon(Icons.add_rounded, color: AppTheme.primary),
                          label: Text(
                            'Add Exercise',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// SCHEDULE SECTION
                        _sectionHeader('Schedule'),
                        const SizedBox(height: 12),

                        _label('Select Days'),
                        _daySelector(),

                        const SizedBox(height: 16),

                        _toggleEveryDay(),

                        const SizedBox(height: 20),

                        /// REMINDER SECTION
                        _sectionHeader('Reminder'),
                        const SizedBox(height: 12),

                        _reminderDropdown(),

                        const SizedBox(height: 20),

                        /// NOTES SECTION
                        _label('Notes (Optional)'),
                        const SizedBox(height: 5),
                        _input(
                          controller: notesController,
                          maxLines: 4,
                          hint: 'Add any additional notes here...',
                        ),

                        const SizedBox(height: 24),

                        /// UPDATE BUTTON
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            onPressed: isLoading ? null : _updatePlan,
                            child: isLoading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                                : const Text(
                              'Add Exercises',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Loading overlay
            if (isLoading)
              Container(
                color: Colors.black26,
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: AppTheme.primary),
                          const SizedBox(height: 16),
                          const Text('Adding exercises...'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// ================= COMPONENTS =================

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  Widget _input({
    required TextEditingController controller,
    int maxLines = 1,
    String? hint,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        contentPadding: const EdgeInsets.all(14),
        enabledBorder: _border(Colors.grey.shade300),
        focusedBorder: _border(AppTheme.primary),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red),
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: _border(Colors.grey.shade300),
      focusedBorder: _border(AppTheme.primary),
    );
  }

  /// SET / REP COUNTER
  Widget _counter(String label, int value, Function(int) onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: Colors.grey.shade700),
                onPressed: () => onChange(value - 1),
                padding: EdgeInsets.zero,
              ),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.grey.shade700),
                onPressed: () => onChange(value + 1),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// DAY SELECTOR
  Widget _daySelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: days.map((day) {
        final selected = selectedDays.contains(day);

        return ChoiceChip(
          label: Text(day),
          selected: selected,
          selectedColor: AppTheme.primary.withOpacity(0.15),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: selected ? AppTheme.primary : Colors.grey.shade300,
              width: 1,
            ),
          ),
          labelStyle: TextStyle(
            color: selected ? AppTheme.primary : Colors.black87,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
          onSelected: everyDay
              ? null
              : (value) {
            setState(() {
              value
                  ? selectedDays.add(day)
                  : selectedDays.remove(day);
            });
          },
        );
      }).toList(),
    );
  }

  /// EVERY DAY TOGGLE
  Widget _toggleEveryDay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Repeat Every Day',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Switch(
            value: everyDay,
            activeColor: AppTheme.primary,
            onChanged: (value) {
              setState(() {
                everyDay = value;
                if (value) selectedDays.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _reminderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications_outlined,
            color: Colors.grey.shade600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: reminder,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              items: reminderOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => reminder = value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _exerciseItem(int index) {
    final item = exercises[index];

    // Get exercises for selected category
    List<Map<String, dynamic>> availableExercises = [];
    if (item.categoryId != null && categoryMap.containsKey(item.categoryId)) {
      availableExercises = List<Map<String, dynamic>>.from(
        categoryMap[item.categoryId]!['exercises'] as List,
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER WITH NUMBER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '#${index + 1}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Exercise',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              if (exercises.length > 1)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      exercises.removeAt(index);
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),

          const SizedBox(height: 16),

          /// DROPDOWNS
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Muscle Group'),
                    DropdownButtonFormField<int>(
                      isExpanded: true,
                      value: item.categoryId,
                      hint: const Text('Select'),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      items: categoryMap.entries
                          .map((entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value['name'] as String),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          item.categoryId = value;
                          item.muscle = value != null
                              ? categoryMap[value]!['name'] as String
                              : null;

                          // Reset exercise when category changes
                          item.exerciseId = null;
                          item.exercise = null;

                          // Adjust weight range
                          if (item.muscle != null) {
                            final max = muscleMaxWeight[item.muscle] ?? 100;
                            if (item.weightRange.end > max) {
                              item.weightRange = RangeValues(0, max);
                            }
                          }
                        });
                      },
                      decoration: _dropdownDecoration(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Exercise'),
                    DropdownButtonFormField<int>(
                      isExpanded: true,
                      value: item.exerciseId,
                      hint: const Text('Select'),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      items: availableExercises
                          .map((ex) => DropdownMenuItem(
                        value: ex['id'] as int,
                        child: Text(ex['name'] as String),
                      ))
                          .toList(),
                      onChanged: availableExercises.isEmpty
                          ? null
                          : (value) {
                        setState(() {
                          item.exerciseId = value;
                          item.exercise = value != null
                              ? availableExercises
                              .firstWhere((ex) => ex['id'] == value)['name'] as String
                              : null;
                        });
                      },
                      decoration: _dropdownDecoration(),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// SETS / REPS
          Row(
            children: [
              Expanded(
                child: _counter('Sets', item.sets, (v) {
                  if (v < 1) return;
                  setState(() => item.sets = v);
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _counter('Reps', item.reps, (v) {
                  if (v < 1) return;
                  setState(() => item.reps = v);
                }),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// WEIGHT RANGE
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label('Weight Range'),
                  Text(
                    '${item.weightRange.start.round()}kg - ${item.weightRange.end.round()}kg',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              RangeSlider(
                values: item.weightRange,
                min: 0,
                max: muscleMaxWeight[item.muscle] ?? 100,
                divisions: 10,
                activeColor: AppTheme.primary,
                inactiveColor: Colors.grey.shade300,
                onChanged: (values) {
                  setState(() => item.weightRange = values);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= UPDATE FUNCTION =================

  Future<void> _updatePlan() async {
    // Validation
    if (titleController.text.isEmpty) {
      _showError('Please enter a plan title');
      return;
    }

    if (exercises.isEmpty) {
      _showError('Please add at least one exercise');
      return;
    }

    for (var i = 0; i < exercises.length; i++) {
      final ex = exercises[i];
      if (ex.categoryId == null || ex.exerciseId == null) {
        _showError('Please complete exercise #${i + 1}');
        return;
      }
    }

    if (!everyDay && selectedDays.isEmpty) {
      _showError('Please select at least one day');
      return;
    }

    setState(() => isLoading = true);

    try {
      debugPrint('🔵 ========================================');
      debugPrint('🔵 Adding exercises to plan ${widget.plan.id}');
      debugPrint('🔵 Plan title: ${titleController.text}');
      debugPrint('🔵 Total exercises to add: ${exercises.length}');

      // Prepare exercises data for API
      final exercisesData = exercises.map((e) {
        debugPrint('  📝 Exercise: ${e.exercise} (ID: ${e.exerciseId})');
        debugPrint('     Category: ${e.muscle} (ID: ${e.categoryId})');
        debugPrint('     Sets: ${e.sets}, Reps: ${e.reps}');
        debugPrint('     Weight: ${e.weightRange.start.round()}-${e.weightRange.end.round()}kg');

        return {
          'exerciseId': e.exerciseId!,
          'sets': e.sets,
          'reps': e.reps,
          'weight': e.weightRange.end.round(), // Use max weight from range
          'comments': 'Weight range: ${e.weightRange.start.round()}kg - ${e.weightRange.end.round()}kg',
        };
      }).toList();

      debugPrint('🔵 API Request data: $exercisesData');

      // Call API to create exercises
      final createdExercises = await WorkoutExerciseService.createMultipleWorkoutExercises(
        planId: widget.plan.id,
        exercises: exercisesData,
      );

      debugPrint('✅ Successfully created ${createdExercises.length} exercises');
      for (var ex in createdExercises) {
        debugPrint('   ✓ ${ex.exerciseName}: ${ex.sets} sets × ${ex.reps} reps @ ${ex.weight}kg');
      }
      debugPrint('🔵 ========================================');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully added ${createdExercises.length} exercise(s)!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );

        // Return to previous screen with success flag
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('❌ ========================================');
      debugPrint('❌ Error adding exercises: $e');
      debugPrint('❌ ========================================');

      if (mounted) {
        _showError('Failed to add exercises: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}