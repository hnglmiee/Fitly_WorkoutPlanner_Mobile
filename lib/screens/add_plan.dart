import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';
import 'package:intl/intl.dart';

import '../models/exercise_models.dart';
import '../models/exercise_form.dart';
import '../services/exercise_service.dart';
import '../services/workout_exercise_service.dart';
import '../services/workout_plan_service.dart';
import '../services/workout_schedule_service.dart';

class AddPlanScreen extends StatefulWidget {
  final DateTime selectedDate;

  const AddPlanScreen({
    super.key,
    required this.selectedDate,
  });

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  /// FORM STATE
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingExercises = true;
  bool everyDay = true;

  /// EXERCISE DATA
  List<ExerciseCategory> categories = [];
  List<ExerciseData> allExercises = [];
  Map<int, List<ExerciseData>> exercisesByCategory = {};

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

  // THÊM TIME PICKER
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    _loadExerciseData();
  }

  Future<void> _loadExerciseData() async {
    setState(() {
      _isLoadingExercises = true;
    });

    try {
      debugPrint('🔵 Loading exercise data...');

      final results = await Future.wait([
        ExerciseService.fetchExerciseCategories(),
        ExerciseService.fetchExercises(),
      ]);

      categories = results[0] as List<ExerciseCategory>;
      allExercises = results[1] as List<ExerciseData>;

      debugPrint('✅ Loaded ${categories.length} categories');
      debugPrint('✅ Loaded ${allExercises.length} exercises');

      for (var exercise in allExercises) {
        exercise.matchCategoryId(categories);
      }

      exercisesByCategory.clear();

      for (var exercise in allExercises) {
        if (exercise.categoryId != null) {
          if (!exercisesByCategory.containsKey(exercise.categoryId)) {
            exercisesByCategory[exercise.categoryId!] = [];
          }
          exercisesByCategory[exercise.categoryId!]!.add(exercise);
        }
      }

      setState(() {
        _isLoadingExercises = false;
      });
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading exercise data: $e');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          _isLoadingExercises = false;
        });
        _showError('Failed to load exercises: ${e.toString()}');
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.darkPrimary,
              surface: AppTheme.darkSecondary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// HEADER
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppTheme.darkText),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Add New Plan',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.darkText
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.darkPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.darkPrimary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: AppTheme.darkText,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Schedule for: ${DateFormat('EEEE, MMM dd, yyyy')
                            .format(widget.selectedDate)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              if (_isLoadingExercises)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Loading exercises...',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.darkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
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

                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppTheme.darkPrimary, width: 1.5),
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
                        icon: Icon(Icons.add_rounded, color: AppTheme.darkPrimary),
                        label: Text(
                          'Add Exercise',
                          style: TextStyle(
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// SCHEDULE TIME (Optional)
                      _label('Schedule Time (Optional)'),
                      InkWell(
                        onTap: _selectTime,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.darkThird,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 18,
                                color: AppTheme.darkPrimary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  selectedTime != null
                                      ? _formatTime(selectedTime!)
                                      : 'Select time (optional)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: selectedTime != null
                                        ? AppTheme.darkText
                                        : Colors.grey.shade400,
                                  ),
                                ),
                              ),
                              if (selectedTime != null)
                                IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      selectedTime = null;
                                    });
                                  },
                                  color: Colors.red,
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// SAVE BUTTON
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.darkPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                            disabledBackgroundColor:
                            AppTheme.darkPrimary.withOpacity(0.6),
                          ),
                          onPressed: _isLoading ? null : _savePlan,
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : const Text(
                            'Save Plan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.darkBackground,
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
            color: AppTheme.darkText
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
        color: AppTheme.darkText,
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
      style: const TextStyle(color: AppTheme.darkText),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        contentPadding: const EdgeInsets.all(14),
        enabledBorder: _border(AppTheme.darkThird),
        focusedBorder: _border(AppTheme.darkThird),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red),
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: _border(AppTheme.darkThird),
      focusedBorder: _border(AppTheme.darkThird),
    );
  }

  // TIME PICKER BUTTON
  Widget _timePickerButton() {
    return InkWell(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        );
        if (time != null) {
          setState(() {
            selectedTime = time;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.darkThird,
          border: Border.all(color: AppTheme.darkThird),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              color: AppTheme.darkText,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedTime != null
                    ? selectedTime!.format(context)
                    : 'Select time (optional)',
                style: TextStyle(
                  fontSize: 15,
                  color: selectedTime != null
                      ? AppTheme.darkText
                      : Colors.grey.shade400,
                  fontWeight: selectedTime != null
                      ? FontWeight.w500
                      : FontWeight.w400,
                ),
              ),
            ),
            if (selectedTime != null)
              IconButton(
                icon: Icon(Icons.clear, size: 20, color: Colors.grey.shade600),
                onPressed: () {
                  setState(() {
                    selectedTime = null;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _counter(String label, int value, Function(int) onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.darkThird, width: 1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: AppTheme.darkText),
                onPressed: () => onChange(value - 1),
                padding: EdgeInsets.zero,
              ),
              Text(
                value.toString(),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkText
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: AppTheme.darkText),
                onPressed: () => onChange(value + 1),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _daySelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: days.map((day) {
        final selected = selectedDays.contains(day);

        return ChoiceChip(
          label: Text(day),
          selected: selected,
          selectedColor: AppTheme.darkPrimary.withOpacity(0.15),
          backgroundColor: AppTheme.darkThird,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: selected ? AppTheme.darkPrimary : AppTheme.darkThird,
              width: 1,
            ),
          ),
          labelStyle: TextStyle(
            color: selected ? AppTheme.darkBackground : AppTheme.darkText,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
          onSelected: everyDay
              ? null
              : (value) {
            setState(() {
              value ? selectedDays.add(day) : selectedDays.remove(day);
            });
          },
        );
      }).toList(),
    );
  }

  Widget _toggleEveryDay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.darkThird,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Repeat Every Day',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.darkText,
            ),
          ),
          Switch(
            value: everyDay,
            activeColor: AppTheme.darkPrimary,
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
        border: Border.all(color: AppTheme.darkThird),
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
                color: AppTheme.darkText,
              ),
              dropdownColor: AppTheme.darkSecondary,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              items: reminderOptions
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(color: AppTheme.darkText)),
              ))
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

    ExerciseCategory? selectedCategory;
    if (item.categoryId != null) {
      try {
        selectedCategory = categories.firstWhere(
              (cat) => cat.id == item.categoryId,
        );
      } catch (e) {
        selectedCategory = null;
      }
    }

    final categoryExercises = item.categoryId != null
        ? (exercisesByCategory[item.categoryId] ?? [])
        : <ExerciseData>[];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkSecondary,
        border: Border.all(color: AppTheme.darkThird),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkThird.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.darkSecondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '#${index + 1}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkText,
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
                      color: AppTheme.darkText,
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
                      hint: const Text('Select', style: TextStyle(color: Colors.grey)),
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppTheme.darkText,
                      ),
                      dropdownColor: AppTheme.darkSecondary,
                      items: categories
                          .map(
                            (cat) =>
                            DropdownMenuItem(
                              value: cat.id,
                              child: Text(cat.name, style: const TextStyle(color: AppTheme.darkText)),
                            ),
                      )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          item.categoryId = value;
                          item.exerciseId = null;
                          item.muscle = categories
                              .firstWhere((cat) => cat.id == value)
                              .name;
                          item.exercise = null;

                          final max = muscleMaxWeight[item.muscle] ?? 100;
                          if (item.weightRange.end > max) {
                            item.weightRange = RangeValues(0, max);
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
                      hint: const Text('Select', style: TextStyle(color: Colors.grey)),
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppTheme.darkText,
                      ),
                      dropdownColor: AppTheme.darkSecondary,
                      items: categoryExercises
                          .map(
                            (ex) =>
                            DropdownMenuItem(
                              value: ex.id,
                              child: Text(ex.name, style: const TextStyle(color: AppTheme.darkText)),
                            ),
                      )
                          .toList(),
                      onChanged: item.categoryId == null
                          ? null
                          : (value) {
                        setState(() {
                          item.exerciseId = value;
                          item.exercise = categoryExercises
                              .firstWhere((ex) => ex.id == value)
                              .name;
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

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label('Weight Range'),
                  Text(
                    '${item.weightRange.start.round()}kg - ${item.weightRange
                        .end.round()}kg',
                    style: TextStyle(
                      color: AppTheme.darkText,
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
                activeColor: AppTheme.darkPrimary,
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

  /// ================= SAVE FUNCTION  =================

  Future<void> _savePlan() async {
    if (titleController.text.trim().isEmpty) {
      _showError('Please enter a plan title');
      return;
    }

    if (exercises.isEmpty) {
      _showError('Please add at least one exercise');
      return;
    }

    for (var i = 0; i < exercises.length; i++) {
      if (exercises[i].categoryId == null || exercises[i].exerciseId == null) {
        _showError('Please complete exercise #${i + 1}');
        return;
      }
    }

    if (!everyDay && selectedDays.isEmpty) {
      _showError('Please select at least one day');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // STEP 1: CREATE PLAN
      final createdPlan = await WorkoutPlanService.createPlan(
        title: titleController.text.trim(),
        notes: notesController.text.trim(),
        exercises: [],
        everyDay: everyDay,
        days: everyDay ? [] : selectedDays.toList(),
        reminder: reminder,
      );

      // STEP 2: CREATE WORKOUT EXERCISES
      final workoutExercisesData = exercises.map((e) {
        final avgWeight =
        ((e.weightRange.start + e.weightRange.end) / 2).round();

        return {
          'exerciseId': e.exerciseId!,
          'sets': e.sets,
          'reps': e.reps,
          'weight': avgWeight, // 🔥 int
          'comments': null,
        };
      }).toList();

      final createdExercises =
      await WorkoutExerciseService.createMultipleWorkoutExercises(
        planId: createdPlan.id,
        exercises: workoutExercisesData,
      );

      // 🔥 GUARD: KHÔNG TẠO SCHEDULE NẾU EXERCISE FAIL
      if (createdExercises.isEmpty) {
        throw Exception('No exercises were created');
      }

      // STEP 3: CREATE SCHEDULE
      DateTime? scheduledDateTime;
      if (selectedTime != null) {
        scheduledDateTime = DateTime(
          widget.selectedDate.year,
          widget.selectedDate.month,
          widget.selectedDate.day,
          selectedTime!.hour,
          selectedTime!.minute,
        );
      }

      await WorkoutScheduleService.createSchedule(
        planId: createdPlan.id,
        scheduledDate: widget.selectedDate,
        scheduledTime: scheduledDateTime,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Plan created successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString().replaceAll('Exception:', '').trim());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}