import 'package:flutter/material.dart';

import '../models/WorkoutMock.dart';
import '../models/schedule_plan.dart';
import '../shared/plan_progress_timeline.dart';
import '../shared/workout_card.dart';

class PlanProgressScreen extends StatefulWidget {
  final SchedulePlan plan;
  const PlanProgressScreen({super.key, required this.plan});

  @override
  State<PlanProgressScreen> createState() => _PlanProgressScreenState();
}

class _PlanProgressScreenState extends State<PlanProgressScreen> {
  int activeWorkoutIndex = 0;
  late final List<WorkoutMock> workouts;

  @override
  void initState() {
    super.initState();

    /// MOCK DATA
    workouts = [
      WorkoutMock(
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSh4_YJj0WHX1lBkMo9uY5jytsD6VjEFXy41Q&s',
        title: 'Reverse Lunges',
        sets: '3 sets',
        reps: '3 reps',
      ),
      WorkoutMock(
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSh4_YJj0WHX1lBkMo9uY5jytsD6VjEFXy41Q&s',
        title: 'Running',
        sets: '3 sets',
        reps: '3 reps',
      ),
      WorkoutMock(
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSh4_YJj0WHX1lBkMo9uY5jytsD6VjEFXy41Q&s',
        title: 'Plank Hold',
        sets: '3 sets',
        reps: '45 sec',
      ),
      WorkoutMock(
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSh4_YJj0WHX1lBkMo9uY5jytsD6VjEFXy41Q&s',
        title: 'Plank Hold',
        sets: '3 sets',
        reps: '45 sec',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Lose Weight, Gain Muscle",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 16),

              /// TITLE
              const Text(
                'Plan Progress',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 16),

              /// CONTENT
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TIMELINE
                    PlanProgressTimeline(
                      total: workouts.length,
                      activeIndex: activeWorkoutIndex,
                    ),

                    const SizedBox(width: 12),

                    /// WORKOUT LIST
                    Expanded(
                      child: ListView.builder(
                        itemCount: workouts.length,
                        itemBuilder: (context, index) {
                          final workout = workouts[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: WorkoutCard(
                              image: workout.image,
                              title: workout.title,
                              sets: workout.sets,
                              reps: workout.reps,
                              active: index == activeWorkoutIndex,
                              onStart: () {
                                setState(() {
                                  activeWorkoutIndex = index;
                                });
                              },
                            ),
                          );
                        },
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
