import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'weight_screen.dart';

class HeightScreen extends StatefulWidget {
  const HeightScreen({super.key});

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  double height = 170;

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

              Text("Height", style: textTheme.headlineMedium),
              const SizedBox(height: 20),

              Row(
                children: [
                  _progress(true),
                  _progress(true),
                  _progress(false),
                  _progress(false),
                ],
              ),

              const SizedBox(height: 30),

              Text(
                "What is your Height?",
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                "Height in cm — don’t worry you can always\nchange it later",
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.third,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                      child: Text(height.toInt().toString()),
                    ),
                    const SizedBox(height: 8),
                    const Text("centimeters"),

                    Slider(
                      min: 140,
                      max: 210,
                      value: height,
                      activeColor: AppTheme.primary,
                      onChanged: (v) {
                        setState(() => height = v);
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, _slideTo(const WeightScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
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
        duration: const Duration(milliseconds: 250),
        height: 4,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: active ? AppTheme.primary : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  // Slide page transition
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
