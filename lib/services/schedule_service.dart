import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';
import '../models/schedule_plan.dart';
import '../models/workout_plan.dart';
import '../models/workout_schedule.dart';
import '../network/dio_client.dart';

class ScheduleService {
  static Future<List<SchedulePlan>> fetchMyPlans() async {
    try {
      debugPrint('🔵 Fetching workout plans and schedules...');

      final dio = DioClient.dio;

      final responses = await Future.wait([
        dio.get('/workout-plans/my-plans'),
        dio.get('/workout-schedules/my-schedules'),
      ]);

      debugPrint('✅ Plans response: ${responses[0].data}');
      debugPrint('✅ Schedules response: ${responses[1].data}');

      // ✅ Safely parse result arrays
      final plansRes = (responses[0].data['result'] as List?) ?? [];
      final schedulesRes = (responses[1].data['result'] as List?) ?? [];

      debugPrint('🔵 Found ${plansRes.length} plans');
      debugPrint('🔵 Found ${schedulesRes.length} schedules');

      if (plansRes.isEmpty) {
        debugPrint('⚠️ No workout plans found');
        return [];
      }

      if (schedulesRes.isEmpty) {
        debugPrint('⚠️ No schedules found');
        return [];
      }

      // ✅ Build plan map with error handling
      final planMap = <String, WorkoutPlan>{};
      for (var p in plansRes) {
        try {
          final plan = WorkoutPlan.fromJson(p);
          planMap[plan.title] = plan;
        } catch (e) {
          debugPrint('⚠️ Error parsing plan: $e');
          continue;
        }
      }

      debugPrint('🔵 Plan map has ${planMap.length} entries');

      final List<SchedulePlan> result = [];

      // ✅ Process schedules with error handling
      for (final s in schedulesRes) {
        try {
          debugPrint('🔵 Processing schedule: $s');

          final schedule = WorkoutSchedule.fromJson(s);
          debugPrint(
            '✅ Parsed schedule: ${schedule.planName} on ${schedule.scheduledDate}',
          );

          final plan = planMap[schedule.planName];

          if (plan == null) {
            debugPrint('⚠️ No plan found for: ${schedule.planName}');
            continue;
          }

          result.add(
            SchedulePlan(
              id: schedule.id,
              date: schedule.scheduledDate,
              title: plan.title,
              description: plan.notes,
              tag: schedule.status,
              backgroundColor: AppTheme.third,
              dayLabel: '',
            ),
          );

          debugPrint('✅ Added schedule plan: ${plan.title}');
        } catch (e, stackTrace) {
          debugPrint('❌ Error processing schedule: $e');
          debugPrint('❌ Stack trace: $stackTrace');
          debugPrint('❌ Schedule data: $s');
          continue; // Skip this schedule and continue
        }
      }

      debugPrint('✅ Total schedule plans created: ${result.length}');
      return result;
    } catch (e, stackTrace) {
      debugPrint('❌ ScheduleService error: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      return [];
    }
  }

  static Future<bool> deletePlan(int scheduleId) async {
    try {
      debugPrint('🔵 Deleting schedule: $scheduleId');

      final dio = DioClient.dio;
      final response = await dio.delete('/workout-schedules/$scheduleId');

      debugPrint('✅ Delete response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Delete schedule error: $e');
      return false;
    }
  }
}
