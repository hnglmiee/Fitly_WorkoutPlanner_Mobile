import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/screens/register_screen.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              Text("Let’s Sign you in", style: textTheme.headlineLarge),

              const SizedBox(height: 8),

              Text(
                "Sign in and elevate your fitness game.",
                style: textTheme.bodyLarge,
              ),

              const SizedBox(height: 40),

              // EMAIL
              Text("Email address", style: textTheme.bodyMedium),
              const SizedBox(height: 6),

              TextField(
                decoration: InputDecoration(
                  hintText: "Email address",
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
              ),

              const SizedBox(height: 20),

              // PASSWORD
              Text("Password", style: textTheme.bodyMedium),
              const SizedBox(height: 6),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
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
              ),

              const SizedBox(height: 32),

              // SIGN IN BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Sign In",
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // FOOTER
              // FOOTER
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign up",
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
}
