import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'congratulation_page.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  List<String> selected = [];

  final List<Map<String, dynamic>> goals = [
    {
      "title": "Exercise",
      "subtitle": "Burn calories, burn fat",
      "icon": Icons.directions_run,
      "color": Colors.orange,
    },
    {
      "title": "Get Fit",
      "subtitle": "Build habits & balance",
      "icon": Icons.favorite,
      "color": Colors.red,
    },
    {
      "title": "Get Strong",
      "subtitle": "Gain strength & muscle",
      "icon": Icons.fitness_center,
      "color": Colors.blue,
    },
    {
      "title": "Combination",
      "subtitle": "Burn fat + build muscle",
      "icon": Icons.local_fire_department,
      "color": Colors.deepOrange,
    },
  ];

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
                "Goal",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.darkText),
              ),

              const SizedBox(height: 20),

              /// PROGRESS BAR
              Row(
                children: [
                  _progress(true),
                  _progress(true),
                  _progress(true),
                  _progress(true),
                ],
              ),

              const SizedBox(height: 40),

              /// TITLE
              const Text(
                "What is your Goal?",
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
                "You can choose more than one — change\nanytime later.",
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.darkText,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              /// GOALS LIST
              Expanded(
                child: ListView.separated(
                  itemCount: goals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    final isSelected = selected.contains(goal["title"]);

                    return _goalCard(
                      title: goal["title"],
                      subtitle: goal["subtitle"],
                      icon: goal["icon"],
                      color: goal["color"],
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          isSelected
                              ? selected.remove(goal["title"])
                              : selected.add(goal["title"]);
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// NEXT BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed:
                      selected.isNotEmpty
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CongratulationsPage(),
                              ),
                            );
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.darkPrimary,
                    disabledBackgroundColor: AppTheme.darkPrimary.withOpacity(0.4),
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

  Widget _goalCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.darkThird,
          border: Border.all(
            color: isSelected ? AppTheme.darkPrimary : AppTheme.darkThird,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color:
                  isSelected
                      ? AppTheme.primary.withOpacity(0.15)
                      : Colors.black.withOpacity(0.02),
              blurRadius: isSelected ? 12 : 4,
              offset: Offset(0, isSelected ? 4 : 1),
            ),
          ],
        ),
        child: Row(
          children: [
            /// ICON
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:
                    isSelected ? color.withOpacity(0.15) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isSelected ? color : Colors.grey.shade600,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppTheme.darkText : AppTheme.darkText,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: AppTheme.darkText),
                  ),
                ],
              ),
            ),

            /// CHECK ICON
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1 : 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.darkBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
