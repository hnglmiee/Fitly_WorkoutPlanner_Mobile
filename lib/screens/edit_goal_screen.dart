import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';
import '../models/goal_progress.dart';
import '../models/goal_request.dart';
import '../services/goal_service.dart';

class EditGoalScreen extends StatefulWidget {
  final GoalProgress goal;

  const EditGoalScreen({super.key, required this.goal});

  @override
  State<EditGoalScreen> createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  late TextEditingController goalNameController;
  late TextEditingController targetWeightController;
  late TextEditingController currentWeightController;
  late TextEditingController bodyFatController;
  late TextEditingController muscleMassController;
  late TextEditingController caloriesController;
  late TextEditingController notesController;

  DateTime? startDate;
  DateTime? targetDate;
  String selectedCategory = 'Weight Loss';
  int workoutSessionsPerWeek = 2;

  final List<String> categories = [
    'Weight Loss',
    'Muscle Gain',
    'Endurance',
    'Flexibility',
    'General Fitness',
  ];

  final List<String> activities = [
    'Bench Press',
    'Running',
    'Squat',
    'Deadlift',
    'Cycling',
    'Swimming',
  ];

  Set<String> selectedActivities = {
    'Bench Press',
    'Running',
    'Squat',
    'Deadlift',
  };

  @override
  void initState() {
    super.initState();

    final goal = widget.goal.goal;

    // Pre-fill with existing data from goal
    goalNameController = TextEditingController(text: goal.goalName);
    targetWeightController = TextEditingController(
        text: goal.targetWeight?.toString() ?? '0'
    );
    currentWeightController = TextEditingController(text: '80'); // Default or fetch from user profile
    bodyFatController = TextEditingController(
        text: goal.targetBodyFatPercentage?.toString() ?? '0'
    );
    muscleMassController = TextEditingController(
        text: goal.targetMuscleMass?.toString() ?? '0'
    );
    caloriesController = TextEditingController(
        text: goal.targetCaloriesPerDay?.toString() ?? '0'
    );
    notesController = TextEditingController(text: goal.notes);

    // Set dates from existing goal (already DateTime objects)
    startDate = goal.startDate;
    targetDate = goal.endDate;

    // Set workout sessions from existing goal
    workoutSessionsPerWeek = goal.targetWorkoutSessionsPerWeek ?? 2;
  }

  @override
  void dispose() {
    goalNameController.dispose();
    targetWeightController.dispose();
    currentWeightController.dispose();
    bodyFatController.dispose();
    muscleMassController.dispose();
    caloriesController.dispose();
    notesController.dispose();
    super.dispose();
  }

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
                        'Edit Goal',
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
                    _label('Goal Name'),
                    _input(
                      controller: goalNameController,
                      hint: 'e.g. Lose 10kg in 3 months',
                    ),

                    const SizedBox(height: 20),

                    /// CATEGORY SECTION
                    _sectionHeader('Category'),
                    const SizedBox(height: 12),
                    _categoryDropdown(),

                    const SizedBox(height: 20),

                    /// TARGET DETAILS SECTION
                    _sectionHeader('Target Details'),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _numberInput(
                            controller: currentWeightController,
                            label: 'Current Weight',
                            suffix: 'kg',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _numberInput(
                            controller: targetWeightController,
                            label: 'Target Weight',
                            suffix: 'kg',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _numberInput(
                            controller: bodyFatController,
                            label: 'Body Fat',
                            suffix: '%',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _numberInput(
                            controller: muscleMassController,
                            label: 'Muscle Mass',
                            suffix: '%',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _numberInput(
                      controller: caloriesController,
                      label: 'Daily Calories Target',
                      suffix: 'kcal',
                    ),

                    const SizedBox(height: 20),

                    /// WORKOUT FREQUENCY SECTION
                    _sectionHeader('Workout Frequency'),
                    const SizedBox(height: 12),
                    _workoutCounter(),

                    const SizedBox(height: 20),

                    /// TIMELINE SECTION
                    _sectionHeader('Timeline'),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _datePickerCard('Start Date', startDate),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _datePickerCard('Target Date', targetDate),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// ACTIVITIES SECTION
                    _sectionHeader('My Activities'),
                    const SizedBox(height: 12),
                    _activitiesSelector(),

                    const SizedBox(height: 20),

                    /// NOTES SECTION
                    _label('Notes (Optional)'),
                    const SizedBox(height: 5),
                    _input(
                      controller: notesController,
                      hint: 'Add any additional notes here...',
                      maxLines: 4,
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
                        onPressed: _confirmUpdate,
                        child: const Text(
                          'Update Goal',
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
    String? hint,
    int maxLines = 1,
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

  Widget _numberInput({
    required TextEditingController controller,
    required String label,
    required String suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            suffixText: suffix,
            suffixStyle: TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.all(14),
            enabledBorder: _border(Colors.grey.shade300),
            focusedBorder: _border(AppTheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _categoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
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
        items:
        categories
            .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => selectedCategory = value);
          }
        },
      ),
    );
  }

  Widget _workoutCounter() {
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
            'Sessions per week',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.grey.shade700),
                  onPressed: () {
                    if (workoutSessionsPerWeek > 1) {
                      setState(() => workoutSessionsPerWeek--);
                    }
                  },
                  padding: EdgeInsets.zero,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    workoutSessionsPerWeek.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.grey.shade700),
                  onPressed: () {
                    if (workoutSessionsPerWeek < 7) {
                      setState(() => workoutSessionsPerWeek++);
                    }
                  },
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _datePickerCard(String label, DateTime? date) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(primary: AppTheme.primary),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            if (label == 'Start Date') {
              startDate = picked;
            } else {
              targetDate = picked;
            }
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text(
                  date != null
                      ? '${date.day}/${date.month}/${date.year}'
                      : 'Select',
                  style: const TextStyle(
                    fontSize: 14,
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

  Widget _activitiesSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
      activities.map((activity) {
        final isSelected = selectedActivities.contains(activity);
        return ChoiceChip(
          label: Text(activity),
          selected: isSelected,
          selectedColor: AppTheme.primary.withOpacity(0.15),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? AppTheme.primary : Colors.grey.shade300,
              width: 1,
            ),
          ),
          labelStyle: TextStyle(
            color: isSelected ? AppTheme.primary : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedActivities.add(activity);
              } else {
                selectedActivities.remove(activity);
              }
            });
          },
        );
      }).toList(),
    );
  }

  /// ================= UPDATE FUNCTIONS =================

  void _confirmUpdate() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Goal'),
        content: const Text('Are you sure you want to update this goal?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              _updateGoal();
            },
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _updateGoal() async {
    // Validate goal name
    if (goalNameController.text.trim().isEmpty) {
      _showError('Please enter a goal name');
      return;
    }

    // Validate dates
    if (startDate == null || targetDate == null) {
      _showError('Please select start and target dates');
      return;
    }

    if (targetDate!.isBefore(startDate!)) {
      _showError('Target date must be after start date');
      return;
    }

    // Parse and validate numeric values
    final targetWeight = double.tryParse(targetWeightController.text.trim());
    final bodyFat = double.tryParse(bodyFatController.text.trim());
    final muscleMass = double.tryParse(muscleMassController.text.trim());
    final calories = int.tryParse(caloriesController.text.trim());

    if (targetWeight == null || targetWeight <= 0) {
      _showError('Please enter a valid target weight');
      return;
    }

    if (bodyFat == null || bodyFat < 0 || bodyFat > 100) {
      _showError('Please enter a valid body fat percentage (0-100)');
      return;
    }

    if (muscleMass == null || muscleMass < 0 || muscleMass > 100) {
      _showError('Please enter a valid muscle mass percentage (0-100)');
      return;
    }

    if (calories == null || calories <= 0) {
      _showError('Please enter a valid daily calories target');
      return;
    }

    // Show loading indicator
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Create request object
      final request = GoalRequest(
        goalName: goalNameController.text.trim(),
        targetWeight: targetWeight,
        targetBodyFatPercentage: bodyFat,
        targetMuscleMass: muscleMass,
        targetWorkoutSessionsPerWeek: workoutSessionsPerWeek,
        targetCaloriesPerDay: calories,
        startDate: startDate!,
        endDate: targetDate!,
        status: widget.goal.goal.status,
        notes: notesController.text.trim(),
      );

      debugPrint('🔵 Updating goal with data: ${request.toJson()}');

      // Call API
      await GoalService.updateGoal(widget.goal.goal.id, request);

      // Close loading dialog
      if (!mounted) return;
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Goal updated successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      // Return to previous screen with success result
      Navigator.pop(context, true); // true indicates successful update

    } catch (e) {
      // Close loading dialog
      if (!mounted) return;
      Navigator.pop(context);

      // Show error
      _showError('Failed to update goal: ${e.toString()}');
      debugPrint('❌ Update goal error: $e');
    }
  }

  /// Helper method to format date to "yyyy-MM-dd"
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}