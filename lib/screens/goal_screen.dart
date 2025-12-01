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
      "icon": "🏃‍♂️",
    },
    {"title": "Get Fit", "subtitle": "Build habits & balance", "icon": "💪"},
    {
      "title": "Get Strong",
      "subtitle": "Gain strength & muscle",
      "icon": "🏋️",
    },
    {
      "title": "Combination",
      "subtitle": "Burn fat + build muscle",
      "icon": "🔥",
    },
  ];

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

              Text("Goal", style: textTheme.headlineMedium),
              const SizedBox(height: 20),

              Row(
                children: [
                  _progress(true),
                  _progress(true),
                  _progress(true),
                  _progress(true),
                ],
              ),

              const SizedBox(height: 30),

              Text(
                "What is your Goal?",
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "You can choose more than one — change anytime later.",
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children:
                      goals.map((goal) {
                        final isSelected = selected.contains(goal["title"]);

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 14),
                          child: Material(
                            color:
                                isSelected
                                    ? AppTheme.primary.withOpacity(0.08)
                                    : AppTheme.third,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              splashColor: AppTheme.primary.withOpacity(0.2),
                              onTap: () {
                                setState(() {
                                  isSelected
                                      ? selected.remove(goal["title"])
                                      : selected.add(goal["title"]);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Text(
                                      goal["icon"],
                                      style: const TextStyle(fontSize: 26),
                                    ),
                                    const SizedBox(width: 16),

                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          goal["title"],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(goal["subtitle"]),
                                      ],
                                    ),

                                    const Spacer(),

                                    AnimatedOpacity(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      opacity: isSelected ? 1 : 0,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: AppTheme.primary,
                                        size: 26,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),

              SizedBox(
                width: double.infinity,
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
}
