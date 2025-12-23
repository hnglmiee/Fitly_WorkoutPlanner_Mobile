import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';
import '../models/schedule_plan.dart';
import '../models/workout_plan.dart';
import '../models/workout_schedule.dart';
import '../network/dio_client.dart';

class ScheduleService {
  static Future<List<SchedulePlan>> fetchMyPlans() async {
    try {
      final dio = DioClient.dio;

      final responses = await Future.wait([
        dio.get('/workout-plans/my-plans'),
        dio.get('/workout-schedules/my-schedules'),
      ]);

      final plansRes = responses[0].data['result'] as List;
      final schedulesRes = responses[1].data['result'] as List;

      final planMap = {
        for (var p in plansRes) p['title']: WorkoutPlan.fromJson(p),
      };

      final List<SchedulePlan> result = [];

      for (final s in schedulesRes) {
        final schedule = WorkoutSchedule.fromJson(s);
        final plan = planMap[schedule.planName];
        if (plan == null) continue;

        result.add(
          SchedulePlan(
            date: schedule.scheduledDate,
            title: plan.title,
            description: plan.notes,
            tag: schedule.status,
            backgroundColor: AppTheme.third,
            dayLabel: '',
          ),
        );
      }

      return result;
    } catch (e) {
      debugPrint('ScheduleService error: $e');
      return [];
    }
  }
}
