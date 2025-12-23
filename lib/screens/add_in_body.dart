import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';
import 'package:file_picker/file_picker.dart';

class AddInBodyScreen extends StatefulWidget {
  const AddInBodyScreen({super.key});

  @override
  State<AddInBodyScreen> createState() => _AddInBodyScreenState();
}

class _AddInBodyScreenState extends State<AddInBodyScreen> {
  /// FORM CONTROLLERS
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController bodyFatController = TextEditingController();
  final TextEditingController muscleMassController = TextEditingController();
  final TextEditingController bodyWaterController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  /// FILE UPLOAD
  String? uploadedFileName;
  String? uploadedFilePath;

  /// GENDER
  String selectedGender = 'Male';
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  /// GOAL
  String? selectedGoal;
  final List<String> goalOptions = [
    'Lose Fat & Gain Muscle',
    'Build Muscle',
    'Lose Weight',
    'Maintain Weight',
    'Improve Endurance',
  ];

  /// DATE & TIME
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    bodyFatController.dispose();
    muscleMassController.dispose();
    bodyWaterController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.light(primary: AppTheme.primary)),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.light(primary: AppTheme.primary)),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'pdf'],
      );

      if (result != null) {
        setState(() {
          uploadedFileName = result.files.single.name;
          uploadedFilePath = result.files.single.path;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File uploaded: $uploadedFileName'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      _showError('Failed to pick file: $e');
    }
  }

  void _removeFile() {
    setState(() {
      uploadedFileName = null;
      uploadedFilePath = null;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
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
                        'Add In Body Record',
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
                    /// DATE & TIME
                    _label('Date & Time'),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _selectDate,
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatDate(selectedDate),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: _selectTime,
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatTime(selectedTime),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// GOAL
                    _label('Goal'),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: selectedGoal,
                      hint: const Text('Select your goal'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      items:
                      goalOptions
                          .map(
                            (e) =>
                            DropdownMenuItem(value: e, child: Text(e)),
                      )
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedGoal = value);
                      },
                      decoration: _dropdownDecoration(),
                    ),

                    const SizedBox(height: 16),

                    /// BASIC INFO SECTION
                    _sectionHeader('Basic Information'),
                    const SizedBox(height: 12),

                    /// HEIGHT & WEIGHT
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Height (cm)'),
                              _numberInput(
                                controller: heightController,
                                hint: 'e.g. 170',
                                suffix: 'cm',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Weight (kg)'),
                              _numberInput(
                                controller: weightController,
                                hint: 'e.g. 65',
                                suffix: 'kg',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// GENDER
                    _label('Gender'),
                    Wrap(
                      spacing: 12,
                      children:
                      genderOptions.map((gender) {
                        final selected = selectedGender == gender;
                        return ChoiceChip(
                          label: Text(gender),
                          selected: selected,
                          selectedColor: AppTheme.primary.withOpacity(0.15),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color:
                              selected
                                  ? AppTheme.primary
                                  : Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color:
                            selected
                                ? AppTheme.primary
                                : Colors.black87,
                            fontWeight:
                            selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          onSelected: (value) {
                            setState(() => selectedGender = gender);
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    /// BODY COMPOSITION SECTION
                    _sectionHeader('Body Composition'),
                    const SizedBox(height: 12),

                    /// BODY FAT PERCENTAGE
                    _label('Body Fat Percentage (%)'),
                    _numberInput(
                      controller: bodyFatController,
                      hint: 'e.g. 14',
                      suffix: '%',
                    ),

                    const SizedBox(height: 16),

                    /// MUSCLE MASS
                    _label('Muscle Mass (%)'),
                    _numberInput(
                      controller: muscleMassController,
                      hint: 'e.g. 75',
                      suffix: '%',
                    ),

                    const SizedBox(height: 16),

                    /// TOTAL BODY WATER
                    _label('Total Body Water (L)'),
                    _numberInput(
                      controller: bodyWaterController,
                      hint: 'e.g. 28.1',
                      suffix: 'L',
                    ),

                    const SizedBox(height: 20),

                    /// NOTES
                    _label('Notes (Optional)'),
                    const SizedBox(height: 5),
                    _input(controller: notesController, maxLines: 3),

                    const SizedBox(height: 20),

                    /// FILE UPLOAD SECTION
                    _sectionHeader('Upload InBody Report'),
                    const SizedBox(height: 12),

                    /// UPLOAD BUTTON
                    if (uploadedFileName == null)
                      OutlinedButton.icon(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.cloud_upload_outlined, size: 20),
                        label: const Text(
                          'Upload PNG or PDF',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primary,
                          side: BorderSide(
                            color: AppTheme.primary,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      )
                    else
                    /// FILE UPLOADED CARD
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppTheme.primary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                uploadedFileName!.endsWith('.pdf')
                                    ? Icons.picture_as_pdf
                                    : Icons.image,
                                color: AppTheme.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    uploadedFileName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'File uploaded successfully',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: _removeFile,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    /// SAVE BUTTON
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _saveInBodyRecord,
                        child: const Text(
                          'Save Record',
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
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
    String? hint,
    String? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        hintText: hint,
        suffixText: suffix,
        suffixStyle: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
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

  /// ================= SAVE FUNCTION =================

  void _saveInBodyRecord() {
    // Validate required fields
    if (heightController.text.isEmpty) {
      _showError('Please enter your height');
      return;
    }
    if (weightController.text.isEmpty) {
      _showError('Please enter your weight');
      return;
    }
    if (bodyFatController.text.isEmpty) {
      _showError('Please enter body fat percentage');
      return;
    }
    if (muscleMassController.text.isEmpty) {
      _showError('Please enter muscle mass');
      return;
    }
    if (bodyWaterController.text.isEmpty) {
      _showError('Please enter total body water');
      return;
    }
    if (selectedGoal == null) {
      _showError('Please select your goal');
      return;
    }

    // TODO: Save to database or state management
    // Example data structure:
    final inBodyData = {
      'date': selectedDate,
      'time': selectedTime,
      'goal': selectedGoal,
      'height': double.tryParse(heightController.text),
      'weight': double.tryParse(weightController.text),
      'gender': selectedGender,
      'bodyFatPercentage': double.tryParse(bodyFatController.text),
      'muscleMass': double.tryParse(muscleMassController.text),
      'totalBodyWater': double.tryParse(bodyWaterController.text),
      'notes': notesController.text,
      'uploadedFile': uploadedFilePath,
      'uploadedFileName': uploadedFileName,
    };

    print('Saving In Body Record: $inBodyData');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('In Body record saved successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Navigate back
    Navigator.pop(context);
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