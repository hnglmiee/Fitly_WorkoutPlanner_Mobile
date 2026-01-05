// lib/services/workout_exercise_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/workout_exercise.dart';
import '../network/dio_client.dart';

class WorkoutExerciseService {
  /// ✅ Fetch tất cả workout exercises của user
  static Future<List<WorkoutExercise>> fetchMyWorkoutExercises() async {
    try {
      debugPrint('🔵 Fetching workout exercises...');

      final dio = DioClient.dio;
      final response = await dio.get('/workout-exercise/my-workout-exercise');

      final data =
      response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != null && data['code'] != 1000 && data['code'] != 0) {
        throw Exception(data['message'] ?? 'API error');
      }

      final List list = data['result'] ?? [];
      return list.map((e) => WorkoutExercise.fromJson(e)).toList();
    } catch (e) {
      debugPrint('❌ fetchMyWorkoutExercises error: $e');
      rethrow;
    }
  }

  /// ✅ CREATE MULTIPLE WORKOUT EXERCISES (SAFE)
  static Future<List<WorkoutExercise>> createMultipleWorkoutExercises({
    required int planId,
    required List<Map<String, dynamic>> exercises,
  }) async {
    debugPrint('🔵 Creating ${exercises.length} workout exercises for plan $planId');

    final List<WorkoutExercise> createdExercises = [];

    for (int i = 0; i < exercises.length; i++) {
      final ex = exercises[i];

      try {
        final created = await createExercise(
          planId: planId,
          exerciseId: ex['exerciseId'] as int,
          sets: ex['sets'] as int,
          reps: ex['reps'] as int,
          weight: ex['weight'] as int, // 🔥 FIX: luôn int
          comments: ex['comments'] as String?,
        );

        createdExercises.add(created);
        debugPrint('✅ Created exercise ${i + 1}');
      } catch (e) {
        debugPrint('❌ Failed to create exercise ${i + 1}: $e');
      }
    }

    // 🔥 GUARD: KHÔNG CHO SUCCESS GIẢ
    if (createdExercises.isEmpty) {
      throw Exception('Failed to create workout exercises');
    }

    return createdExercises;
  }

  /// ✅ Create single workout exercise
  static Future<WorkoutExercise> createExercise({
    required int planId,
    required int exerciseId,
    required int sets,
    required int reps,
    required int weight,
    String? comments,
  }) async {
    try {
      final requestBody = {
        'planId': planId,
        'exerciseId': exerciseId,
        'sets': sets,
        'reps': reps,
        'weight': weight, // 🔥 FIX: luôn gửi weight
        'comments': comments ?? '',
      };

      debugPrint('📤 POST /workout-exercise: $requestBody');

      final dio = DioClient.dio;
      final response = await dio.post(
        '/workout-exercise',
        data: requestBody,
      );

      final data =
      response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != null && data['code'] != 1000 && data['code'] != 0) {
        throw Exception(data['message'] ?? 'Create exercise failed');
      }

      return WorkoutExercise.fromJson(data['result']);
    } catch (e) {
      debugPrint('❌ createExercise error: $e');
      rethrow;
    }
  }

  /// ================== CÁC HÀM KHÁC GIỮ NGUYÊN ==================

  static List<WorkoutExercise> filterExercisesByPlanId(
      List<WorkoutExercise> allExercises, int planId) {
    return allExercises.where((e) => e.planId == planId).toList();
  }

  static Future<WorkoutExercise> getExerciseById(int exerciseId) async {
    final dio = DioClient.dio;
    final response = await dio.get('/workout-exercise/$exerciseId');
    final data =
    response.data is String ? jsonDecode(response.data) : response.data;
    return WorkoutExercise.fromJson(data['result']);
  }

  static Future<WorkoutExercise> updateExercise({
    required int workoutExerciseId,
    required int sets,
    required int reps,
    int? weight,
    String? comments,
  }) async {
    final dio = DioClient.dio;
    final response = await dio.put(
      '/workout-exercise/$workoutExerciseId',
      data: {
        'sets': sets,
        'reps': reps,
        if (weight != null) 'weight': weight,
        if (comments != null) 'comments': comments,
      },
    );

    final data =
    response.data is String ? jsonDecode(response.data) : response.data;
    return WorkoutExercise.fromJson(data['result']);
  }

  static Future<void> deleteExercise(int workoutExerciseId) async {
    final dio = DioClient.dio;
    await dio.delete('/workout-exercise/$workoutExerciseId');
  }

  static Future<List<WorkoutExercise>> fetchExercisesByPlanId(int planId) async {
    try {
      final dio = DioClient.dio;
      final response = await dio.get('/workout-exercise/plan/$planId');
      final data =
      response.data is String ? jsonDecode(response.data) : response.data;
      final List list = data['result'] ?? [];
      return list.map((e) => WorkoutExercise.fromJson(e)).toList();
    } catch (_) {
      final all = await fetchMyWorkoutExercises();
      return filterExercisesByPlanId(all, planId);
    }
  }
}
