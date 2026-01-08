// lib/screens/create_goal_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/goal_request.dart';
import '../services/goal_service.dart';
import '../theme/app_theme.dart';

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _goalNameController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _targetBodyFatController = TextEditingController();
  final _targetMuscleMassController = TextEditingController();
  final _workoutSessionsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 90));
  String _status = 'In Progress';

  bool _isLoading = false;

  @override
  void dispose() {
    _goalNameController.dispose();
    _targetWeightController.dispose();
    _targetBodyFatController.dispose();
    _targetMuscleMassController.dispose();
    _workoutSessionsController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // Ensure end date is after start date
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 30));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // Future<void> _createGoal() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }
  //
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   try {
  //     final request = GoalRequest(
  //       goalName: _goalNameController.text.trim(),
  //       targetWeight: double.parse(_targetWeightController.text),
  //       targetBodyFatPercentage: double.parse(_targetBodyFatController.text),
  //       targetMuscleMass: double.parse(_targetMuscleMassController.text),
  //       targetWorkoutSessionsPerWeek: int.parse(_workoutSessionsController.text),
  //       targetCaloriesPerDay: int.parse(_caloriesController.text),
  //       startDate: _startDate,
  //       endDate: _endDate,
  //       status: _status,
  //       notes: _notesController.text.trim(),
  //     );
  //
  //     final goal = await GoalService.createGoal(request);
  //
  //     if (!mounted) return;
  //
  //     if (goal != null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Row(
  //             children: const [
  //               Icon(Icons.check_circle, color: Colors.white),
  //               SizedBox(width: 12),
  //               Text('Goal created successfully!'),
  //             ],
  //           ),
  //           backgroundColor: Colors.green,
  //           behavior: SnackBarBehavior.floating,
  //         ),
  //       );
  //
  //       // Return true to indicate success
  //       Navigator.pop(context, true);
  //     }
  //   } catch (e) {
  //     if (!mounted) return;
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to create goal: ${e.toString()}'),
  //         backgroundColor: Colors.red,
  //         behavior: SnackBarBehavior.floating,
  //       ),
  //     );
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }

  Future<void> _createGoal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = GoalRequest(
        goalName: _goalNameController.text.trim(),
        targetWeight: double.parse(_targetWeightController.text),
        targetBodyFatPercentage: double.parse(_targetBodyFatController.text),
        targetMuscleMass: double.parse(_targetMuscleMassController.text),
        targetWorkoutSessionsPerWeek:
        int.parse(_workoutSessionsController.text),
        targetCaloriesPerDay: int.parse(_caloriesController.text),
        startDate: _startDate,
        endDate: _endDate,
        status: _status,
        notes: _notesController.text.trim(),
      );

      // ✅ CHỈ GỌI – KHÔNG GÁN BIẾN
      await GoalService.createGoal(request);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Goal created successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // ✅ Trả true để màn trước biết cần refresh
      Navigator.pop(context, true);

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create goal: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create New Goal',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Goal Name
              _buildSectionTitle('Goal Details'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _goalNameController,
                label: 'Goal Name',
                hint: 'e.g. Lose 10kg in 3 months',
                icon: Icons.flag_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter goal name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// Target Weight
              _buildTextField(
                controller: _targetWeightController,
                label: 'Target Weight (kg)',
                hint: 'e.g. 75',
                icon: Icons.monitor_weight_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter target weight';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// Target Body Fat
              _buildTextField(
                controller: _targetBodyFatController,
                label: 'Target Body Fat (%)',
                hint: 'e.g. 15',
                icon: Icons.local_fire_department,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter target body fat';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// Target Muscle Mass
              _buildTextField(
                controller: _targetMuscleMassController,
                label: 'Target Muscle Mass (%)',
                hint: 'e.g. 40',
                icon: Icons.fitness_center,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter target muscle mass';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              /// Activity Targets
              _buildSectionTitle('Activity Targets'),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _workoutSessionsController,
                label: 'Workout Sessions Per Week',
                hint: 'e.g. 4',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter workout sessions';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter valid number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _caloriesController,
                label: 'Target Calories Per Day',
                hint: 'e.g. 2000',
                icon: Icons.restaurant,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter target calories';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter valid number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              /// Date Range
              _buildSectionTitle('Duration'),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      label: 'Start Date',
                      date: _startDate,
                      onTap: () => _selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDateField(
                      label: 'End Date',
                      date: _endDate,
                      onTap: () => _selectDate(context, false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// Status
              _buildSectionTitle('Status'),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonFormField<String>(
                  value: _status,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.info_outline, color: AppTheme.primary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  items: ['In Progress', 'Completed', 'Pending']
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),

              /// Notes
              _buildSectionTitle('Notes (Optional)'),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextFormField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Add any additional notes...',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// Create Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createGoal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Text(
                    'Create Goal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(icon, color: AppTheme.primary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: AppTheme.primary),
                const SizedBox(width: 12),
                Text(
                  DateFormat('MMM dd, yyyy').format(date),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}