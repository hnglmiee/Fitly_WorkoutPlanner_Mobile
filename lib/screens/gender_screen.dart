import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../theme/app_theme.dart';
import 'height_screen.dart';

class GenderScreen extends StatefulWidget {
  final int userId;
  const GenderScreen({super.key, required this.userId});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String selectedGender = "";

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Text("Gender", style: textTheme.headlineMedium),
              const SizedBox(height: 20),

              // ---- PROGRESS ----
              Row(
                children: [
                  _progress(true),
                  _progress(false),
                  _progress(false),
                  _progress(false),
                ],
              ),

              const SizedBox(height: 30),

              Text(
                "Tell Us About Yourself",
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                "To give you a better experience and results we need\nto know your gender",
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),

              const SizedBox(height: 32),

              // ---- GENDER CARDS ----
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.third,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _genderCard(
                      label: "Male",
                      imageUrl:
                          "https://images.unsplash.com/photo-1605296867304-46d5465a13f1?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      isSelected: selectedGender == "Male",
                      onTap: () => setState(() => selectedGender = "Male"),
                    ),
                    _genderCard(
                      label: "Female",
                      imageUrl:
                          "https://images.unsplash.com/photo-1644845225271-4cd4f76a0631?q=80&w=1172&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      isSelected: selectedGender == "Female",
                      onTap: () => setState(() => selectedGender = "Female"),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      selectedGender.isNotEmpty
                          ? () async {
                            try {
                              // Call API để update gender
                              await UserService.updateUserGender(
                                userId: widget.userId,
                                gender: selectedGender,
                              );

                              // Chuyển sang HeightScreen
                              Navigator.push(
                                context,
                                _slideTo(const HeightScreen()),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    disabledBackgroundColor: Colors.blue[200],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Next",
                    style: textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progress(bool active) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 4,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: active ? AppTheme.primary : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  // ---- CARD ----
  Widget _genderCard({
    required String label,
    required String imageUrl,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: 132,
        height: isSelected ? 170 : 160,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            width: 3,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                  : [],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.12 : 1,
              child: CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // ---- SLIDE ANIMATION ----
  Route _slideTo(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
