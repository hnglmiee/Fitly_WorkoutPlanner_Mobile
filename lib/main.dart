import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker_mini_project_mobile/screens/login_screen.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';
import 'package:workout_tracker_mini_project_mobile/theme/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Workout Tracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            /// ✅ THÊM GRADIENT WRAPPER (Optional)
            builder: (context, child) {
              if (child == null) return const SizedBox();
              return GlobalGradientWrapper(child: child);
            },

            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}

/// Gradient Wrapper
class GlobalGradientWrapper extends StatelessWidget {
  final Widget child;

  const GlobalGradientWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    const Color(0xFF3F403D).withOpacity(0.3),
                    const Color(0xFF313130).withOpacity(0.5),
                    const Color(0xFF1C1C1C),
                  ]
                  : [
                    const Color(0xFF0091FF).withOpacity(0.05),
                    const Color(0xFFB7E0FF).withOpacity(0.15),
                    const Color(0xFFEDF7FF).withOpacity(0.1),
                  ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}
