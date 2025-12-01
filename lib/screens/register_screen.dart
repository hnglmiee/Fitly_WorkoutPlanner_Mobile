import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/screens/gender_screen.dart';
import '../theme/app_theme.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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

              // Header
              Text("Create Account", style: textTheme.headlineLarge),

              const SizedBox(height: 8),

              Text(
                "Sign up and take the first step towards your goals.",
                style: textTheme.bodyLarge,
              ),

              const SizedBox(height: 40),

              // FULL NAME
              Text("Full Name", style: textTheme.bodyMedium),
              const SizedBox(height: 6),
              _buildInput(textTheme, "Full Name"),

              const SizedBox(height: 20),

              // EMAIL
              Text("Email address", style: textTheme.bodyMedium),
              const SizedBox(height: 6),
              _buildInput(textTheme, "Email address"),

              const SizedBox(height: 20),

              // PASSWORD
              Text("Password", style: textTheme.bodyMedium),
              const SizedBox(height: 6),
              _buildInput(textTheme, "Password", obscure: true),

              const SizedBox(height: 32),

              // SIGN UP BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GenderScreen()),
                    );
                  },
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

              // FOOTER
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
                        Navigator.pop(context); // quay về login
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

  // -------- CUSTOM INPUT WIDGET --------
  Widget _buildInput(TextTheme textTheme, String hint, {bool obscure = false}) {
    return TextField(
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
}
