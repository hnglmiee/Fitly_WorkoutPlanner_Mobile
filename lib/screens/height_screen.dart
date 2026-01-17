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
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// HEADER
              const Text(
                "Height",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.darkText),
              ),

              const SizedBox(height: 20),

              /// PROGRESS BAR
              Row(
                children: [
                  _progress(true),
                  _progress(true),
                  _progress(false),
                  _progress(false),
                ],
              ),

              const SizedBox(height: 40),

              /// TITLE
              const Text(
                "What is your Height?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                    color: AppTheme.darkText
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              /// SUBTITLE
              Text(
                "Height in cm — don't worry you can always\nchange it later",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.darkText,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              /// HEIGHT SELECTOR
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.darkThird,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /// HEIGHT VALUE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.darkText,
                            height: 1,
                          ),
                          child: Text(height.toInt().toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 4),
                          child: Text(
                            "cm",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.darkText,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    /// SLIDER
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 6,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 12,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 24,
                        ),
                        activeTrackColor: AppTheme.darkPrimary,
                        inactiveTrackColor: Colors.grey.shade200,
                        thumbColor: AppTheme.darkPrimary,
                        overlayColor: AppTheme.primary.withOpacity(0.2),
                      ),
                      child: Slider(
                        min: 140,
                        max: 210,
                        value: height,
                        onChanged: (v) {
                          setState(() => height = v);
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// MIN MAX LABELS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "140 cm",
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "210 cm",
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// NEXT BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, _slideTo(const WeightScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.darkPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      color: AppTheme.darkBackground,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: active ? AppTheme.darkPrimary : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

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
