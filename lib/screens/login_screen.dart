import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/screens/training_screen.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../utils/token_storage.dart';
import '../theme/app_theme.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email và password không được để trống")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authResponse = await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // ✅ Fetch user info ngay lập tức
      try {
        final userInfo = await UserService.getMyInfo();
        print("User full name: ${userInfo.fullName}");
      } catch (e) {
        print("Error fetching user info: $e");
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login successful")));

      // TODO: Navigator.pushReplacement(...)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TrainingScreen()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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

              Text("Let’s Sign you in", style: textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text(
                "Sign in and elevate your fitness game.",
                style: textTheme.bodyLarge,
              ),

              const SizedBox(height: 40),

              Text("Email address", style: textTheme.bodyMedium),
              const SizedBox(height: 6),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration("Email address", textTheme),
              ),

              const SizedBox(height: 20),

              Text("Password", style: textTheme.bodyMedium),
              const SizedBox(height: 6),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: _inputDecoration("Password", textTheme),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            "Sign In",
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                ),
              ),

              const SizedBox(height: 24),

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

  InputDecoration _inputDecoration(String hint, TextTheme textTheme) {
    return InputDecoration(
      hintText: hint,
      hintStyle: textTheme.bodyMedium,
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }
}
