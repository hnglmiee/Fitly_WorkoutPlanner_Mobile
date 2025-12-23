import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';

import '../models/exercise_form.dart';

class AddPlanScreen extends StatefulWidget {
  const AddPlanScreen({super.key});

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  /// FORM STATE
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  int sets = 1;
  int reps = 1;
  bool everyDay = true;

  /// EXERCISE DATA
  final Map<String, List<String>> exerciseMap = {
    'Chest': ['Bench Press', 'Push Up', 'Chest Fly'],
    'Legs': ['Squat', 'Lunges', 'Leg Press'],
    'Back': ['Pull Up', 'Deadlift', 'Lat Pulldown'],
    'Core': ['Plank', 'Crunch', 'Russian Twist'],
  };

  String? selectedMuscle;
  String? selectedExercise;

  /// DAYS
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final Set<String> selectedDays = {};

  /// WEIGHT
  final List<String> weight = ['5kg', '10kg', '15kg', '20kg', '25kg'];
  final Set<String> selectedWeight = {};

  /// WEIGHT CONFIG
  final Map<String, double> muscleMaxWeight = {
    'Chest': 200,
    'Back': 300,
    'Legs': 500,
    'Core': 100,
  };

  double get minWeight => 0;

  double get maxWeight {
    if (selectedMuscle == null) return 100;
    return muscleMaxWeight[selectedMuscle] ?? 100;
  }

  RangeValues weightRange = const RangeValues(0, 40);

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
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
                        'Add New Plan',
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
                    _label('Plan title'),
                    _input(controller: titleController),

                    const SizedBox(height: 16),

                    // _label('Choose Exercise'),
                    // _exerciseDropdowns(),
                    _label('Exercises'),

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
                        side: BorderSide(color: AppTheme.primary, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          exercises.add(ExerciseForm());
                        });
                      },
                      icon: Icon(Icons.add, color: AppTheme.primary),
                      label: Text(
                        'Add Exercise',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Row(
                    //   children: [
                    //     Expanded(child: _counter('Sets', sets, _changeSets)),
                    //     const SizedBox(width: 12),
                    //     Expanded(child: _counter('Reps', reps, _changeReps)),
                    //   ],
                    // ),
                    //
                    // const SizedBox(height: 16),
                    //
                    // const SizedBox(height: 16),
                    //
                    // _weightRangeSlider(),
                    //
                    // const SizedBox(height: 16),
                    _label('Select Days'),
                    _daySelector(),

                    const SizedBox(height: 16),

                    _toggleEveryDay(),

                    const SizedBox(height: 16),

                    _reminderDropdown(),

                    const SizedBox(height: 16),

                    _label('Notes'),
                    const SizedBox(height: 5),
                    _input(controller: notesController, maxLines: 3),

                    const SizedBox(height: 24),

                    /// NEXT BUTTON
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
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

  /// ================= COMPONENTS =================

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  /// BORDER (mảnh hơn)
  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: color,
        width: 1, // 👈 viền mảnh
      ),
    );
  }

  Widget _input({required TextEditingController controller, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(14),
        enabledBorder: _border(Colors.grey.shade300),
        focusedBorder: _border(AppTheme.primary),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red),
      ),
    );
  }

  /// EXERCISE DROPDOWNS
  Widget _exerciseDropdowns() {
    return Row(
      children: [
        /// MUSCLE GROUP
        Expanded(
          child: DropdownButtonFormField<String>(
            style: const TextStyle(
              fontSize: 18, // ← chỉnh size ở đây
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            hint: const Text('Muscle group'),
            value: selectedMuscle,
            items:
                exerciseMap.keys
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (value) {
              setState(() {
                selectedMuscle = value;
                selectedExercise = null;
              });
            },
            decoration: _dropdownDecoration(),
          ),
        ),

        const SizedBox(width: 12),

        /// EXERCISE NAME
        Expanded(
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            style: const TextStyle(
              fontSize: 18, // ← chỉnh size ở đây
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            hint: const Text('Exercise name'),
            value: selectedExercise,
            items:
                selectedMuscle == null
                    ? []
                    : exerciseMap[selectedMuscle]!
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
            onChanged: (value) {
              setState(() => selectedExercise = value);
            },
            decoration: _dropdownDecoration(),
          ),
        ),
      ],
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
                icon: const Icon(Icons.remove),
                onPressed: () => onChange(value - 1),
              ),
              Text(value.toString(), style: const TextStyle(fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => onChange(value + 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _changeSets(int v) {
    if (v < 1) return;
    setState(() => sets = v);
  }

  void _changeReps(int v) {
    if (v < 1) return;
    setState(() => reps = v);
  }

  /// REPEAT OPTIONS
  Widget _repeatOptions() {
    final options = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
    return Wrap(
      spacing: 8,
      children:
          options
              .map(
                (e) => Chip(
                  label: Text(e),
                  backgroundColor: AppTheme.primary.withOpacity(0.15),
                ),
              )
              .toList(),
    );
  }

  /// DAY SELECTOR
  Widget _daySelector() {
    return Wrap(
      spacing: 8,
      children:
          days.map((day) {
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
                  width: 1, // 👈 viền mảnh
                ),
              ),

              labelStyle: TextStyle(
                color: selected ? AppTheme.primary : Colors.black87,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),

              onSelected:
                  everyDay
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

  Widget _weightRangeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Weight Range',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              '${weightRange.start.round()}kg - ${weightRange.end.round()}kg',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: weightRange,
          min: minWeight,
          max: maxWeight,
          divisions: (maxWeight / 10).round(),
          labels: RangeLabels(
            '${weightRange.start.round()}kg',
            '${weightRange.end.round()}kg',
          ),
          activeColor: AppTheme.primary,
          inactiveColor: Colors.grey.shade300,
          onChanged: (values) {
            setState(() => weightRange = values);
          },
        ),
      ],
    );
  }

  /// EVERY DAY TOGGLE
  Widget _toggleEveryDay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Every Days',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
    );
  }

  Widget _reminderDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Reminder',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),

        SizedBox(
          width: 180,
          child: DropdownButtonFormField<String>(
            value: reminder,
            style: const TextStyle(
              fontSize: 18, // ← chỉnh size ở đây
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            items:
                reminderOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => reminder = value);
            },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              enabledBorder: _border(Colors.grey.shade300),
              focusedBorder: _border(AppTheme.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _exerciseItem(int index) {
    final item = exercises[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          /// DROPDOWNS
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  // ❌ Xóa key: ObjectKey(item) - đây là nguyên nhân bug
                  isExpanded: true,
                  value: item.muscle,
                  hint: const Text('Muscle group'),
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  items:
                      exerciseMap.keys
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      item.muscle = value;
                      item.exercise = null; // Reset exercise khi đổi muscle
                      final max = muscleMaxWeight[value] ?? 100;
                      if (item.weightRange.end > max) {
                        item.weightRange = RangeValues(0, max);
                      }
                    });
                  },
                  decoration: _dropdownDecoration(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  // ❌ Xóa key: ObjectKey(item)
                  isExpanded: true,
                  value: item.exercise,
                  hint: const Text('Exercise'),
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  items:
                      item.muscle == null
                          ? []
                          : exerciseMap[item.muscle]!
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                  onChanged: (value) {
                    setState(() => item.exercise = value);
                  },
                  decoration: _dropdownDecoration(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

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
          const SizedBox(height: 12),

          /// WEIGHT RANGE
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Weight Range', style: TextStyle(fontSize: 14)),
                  Text(
                    '${item.weightRange.start.round()}kg - ${item.weightRange.end.round()}kg',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
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

          /// 🗑️ DELETE BUTTON (optional - để xóa exercise)
          if (exercises.length > 1)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    exercises.removeAt(index);
                  });
                },
                icon: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.red,
                ),
                label: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
