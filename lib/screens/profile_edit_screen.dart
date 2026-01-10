// screens/profile_edit_screen.dart
import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';
import '../models/user_info.dart';
import '../services/user_service.dart';

class ProfileEditScreen extends StatefulWidget {
  final UserInfo userInfo;

  const ProfileEditScreen({super.key, required this.userInfo});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  DateTime? dateOfBirth;
  String selectedGender = 'Male';
  String? avatarUrl;

  final List<String> genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

  @override
  void initState() {
    super.initState();

    // Pre-fill with existing data
    fullNameController = TextEditingController(text: widget.userInfo.fullName);
    emailController = TextEditingController(text: widget.userInfo.email);
    phoneController = TextEditingController(text: widget.userInfo.phoneNumber ?? '');

    // Map gender from database format
    selectedGender = _mapGenderFromApi(widget.userInfo.gender);

    // Set birthday from existing data
    dateOfBirth = widget.userInfo.birthday ??
        DateTime.now().subtract(const Duration(days: 365 * 25));

    // avatarUrl = widget.userInfo.avatarUrl; // If available
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
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
                        'Edit Profile',
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
                    /// AVATAR SECTION
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.primary,
                                width: 3,
                              ),
                              image:
                              avatarUrl != null
                                  ? DecorationImage(
                                image: NetworkImage(avatarUrl!),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                            child:
                            avatarUrl == null
                                ? Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey.shade400,
                            )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickAvatar,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    Center(
                      child: TextButton(
                        onPressed: _pickAvatar,
                        child: Text(
                          'Change Photo',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// PERSONAL INFORMATION SECTION
                    _sectionHeader('Personal Information'),
                    const SizedBox(height: 12),

                    _label('Full Name'),
                    _input(
                      controller: fullNameController,
                      hint: 'Enter your full name',
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 16),

                    _label('Email'),
                    _input(
                    controller: emailController,
                    hint: 'Enter your email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    enabled: false
                    ),

                    const SizedBox(height: 16),

                    _label('Phone Number'),
                    _input(
                      controller: phoneController,
                      hint: 'Enter your phone number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 20),

                    /// DATE OF BIRTH & GENDER SECTION
                    _sectionHeader('Additional Details'),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: _dateOfBirthPicker()),
                        const SizedBox(width: 12),
                        Expanded(child: _genderDropdown()),
                      ],
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
                        onPressed: _updateProfile,
                        child: const Text(
                          'Update Profile',
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
    IconData? icon,
    TextInputType? keyboardType,
    bool enabled = true
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon:
        icon != null
            ? Icon(icon, color: Colors.grey.shade600, size: 20)
            : null,
        contentPadding: const EdgeInsets.all(14),
        enabledBorder: _border(Colors.grey.shade300),
        focusedBorder: _border(AppTheme.primary),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red),
      ),
    );
  }

  Widget _dateOfBirthPicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate:
          dateOfBirth ??
              DateTime.now().subtract(const Duration(days: 365 * 25)),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
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
          setState(() => dateOfBirth = picked);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Date of Birth'),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  dateOfBirth != null
                      ? '${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}'
                      : 'Select',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color:
                    dateOfBirth != null
                        ? Colors.black87
                        : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Gender'),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(14),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedGender,
            isExpanded: true,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            items:
            genders
                .map(
                  (gender) => DropdownMenuItem(
                value: gender,
                child: Text(gender),
              ),
            )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedGender = value);
              }
            },
          ),
        ),
      ],
    );
  }

  /// ================= HELPER METHODS =================

  String _mapGenderFromApi(String? apiGender) {
    if (apiGender == null) return 'Male';

    switch (apiGender.toUpperCase()) {
      case 'MALE':
        return 'Male';
      case 'FEMALE':
        return 'Female';
      case 'OTHER':
        return 'Other';
      default:
        return 'Prefer not to say';
    }
  }

  String _mapGenderToApi(String uiGender) {
    switch (uiGender) {
      case 'Male':
        return 'MALE';
      case 'Female':
        return 'FEMALE';
      case 'Other':
        return 'OTHER';
      default:
        return 'OTHER';
    }
  }

  /// ================= ACTIONS =================

  void _pickAvatar() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Change Profile Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.camera_alt, color: AppTheme.primary),
              ),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _showInfo('Camera feature coming soon');
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.photo_library, color: Colors.blue),
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _showInfo('Gallery feature coming soon');
              },
            ),
            if (avatarUrl != null)
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                title: const Text('Remove Photo'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => avatarUrl = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _updateProfile() async {
    // Validate
    if (fullNameController.text.trim().isEmpty) {
      _showError('Please enter your full name');
      return;
    }

    if (emailController.text.trim().isEmpty) {
      _showError('Please enter your email');
      return;
    }

    if (!_isValidEmail(emailController.text.trim())) {
      _showError('Please enter a valid email');
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
      debugPrint('🔵 Updating profile for user ID: ${widget.userInfo.id}');

      // Call API to update profile
      await UserService.updateProfile(
        userId: widget.userInfo.id,
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim().isNotEmpty
            ? phoneController.text.trim()
            : null,
        gender: _mapGenderToApi(selectedGender),
        birthday: dateOfBirth,
      );

      // Close loading dialog
      if (!mounted) return;
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );

      // Return to previous screen with success flag
      Navigator.pop(context, true);

    } catch (e) {
      // Close loading dialog
      if (!mounted) return;
      Navigator.pop(context);

      // Show error
      _showError('Failed to update profile: ${e.toString()}');
      debugPrint('❌ Update profile error: $e');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
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

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}