import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/screens/gender_screen.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text("Create Account", style: textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text(
                "Sign up and take the first step towards your goals.",
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),

              // Full Name
              Text("Full Name", style: textTheme.bodyMedium),
              const SizedBox(height: 6),
              _buildInput(
                textTheme,
                "Full Name",
                controller: fullNameController,
              ),

              const SizedBox(height: 20),

              // Email
              Text("Email address", style: textTheme.bodyMedium),
              const SizedBox(height: 6),
              _buildInput(
                textTheme,
                "Email address",
                controller: emailController,
              ),

              const SizedBox(height: 20),

              // Password
              Text("Password", style: textTheme.bodyMedium),
              const SizedBox(height: 6),
              _buildInput(
                textTheme,
                "Password",
                obscure: true,
                controller: passwordController,
              ),

              const SizedBox(height: 32),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onRegisterPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Sign Up",
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Footer
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Sign In",
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
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

  Widget _buildInput(
    TextTheme textTheme,
    String hint, {
    bool obscure = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: textTheme.bodyMedium,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
    );
  }

  void _onRegisterPressed() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    try {
      // 1️⃣ Register
      final user = await _authService.register(
        fullName: fullName,
        email: email,
        password: password,
      );

      // Login (token được lưu trong AuthService)
      await _authService.login(email: email, password: password);

      // Navigate
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GenderScreen(userId: user.id)),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
