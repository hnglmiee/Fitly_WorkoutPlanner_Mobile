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

      debugPrint('🔵 Response status: ${response.statusCode}');
      debugPrint('🔵 Response data type: ${response.data.runtimeType}');
      debugPrint('🔵 Response data: ${response.data}');

      // Parse response
      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      debugPrint('🔵 Parsed data: $data');

      // ✅ Check if response is successful
      if (data['code'] != 1000) {
        final message = data['message'] ?? 'Unknown error';
        debugPrint('❌ API error: $message');
        throw Exception('API Error: $message');
      }

      final List list = data['result'] ?? [];
      debugPrint('🔵 Result list length: ${list.length}');

      if (list.isEmpty) {
        debugPrint('⚠️ No workout exercises found');
        return []; // ✅ Return empty list (not error)
      }

      final exercises =
          list.map((e) {
            debugPrint('🔵 Parsing exercise: $e');
            return WorkoutExercise.fromJson(e);
          }).toList();

      debugPrint('✅ Successfully fetched ${exercises.length} exercises');
      return exercises;
    } catch (e, stack) {
      debugPrint('❌ fetchMyWorkoutExercises error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow; // ✅ IMPORTANT: Throw error instead of returning []
    }
  }

  /// ✅ Lọc exercises theo planId - QUAN TRỌNG
  /// Đảm bảo Plan ID 2 chỉ hiển thị exercises có planId = 2
  static List<WorkoutExercise> filterExercisesByPlanId(
    List<WorkoutExercise> allExercises,
    int planId,
  ) {
    debugPrint('🔵 Filtering exercises for planId: $planId');
    final filtered =
        allExercises.where((exercise) => exercise.planId == planId).toList();
    debugPrint('✅ Found ${filtered.length} exercises for plan $planId');

    // Debug: In ra danh sách exercises đã filter
    for (var ex in filtered) {
      debugPrint('   - ${ex.exerciseName} (planId: ${ex.planId})');
    }

    return filtered;
  }

  /// ✅ Get exercise by ID
  static Future<WorkoutExercise> getExerciseById(int exerciseId) async {
    try {
      debugPrint('🔵 Fetching workout exercise $exerciseId...');

      final dio = DioClient.dio;
      final response = await dio.get('/workout-exercise/$exerciseId');

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to get exercise');
      }

      debugPrint('✅ Exercise fetched successfully');
      return WorkoutExercise.fromJson(data['result']);
    } catch (e) {
      debugPrint('❌ getExerciseById error: $e');
      rethrow;
    }
  }

  /// ✅ Create new workout exercise
  static Future<WorkoutExercise> createExercise({
    required int planId,
    required int exerciseId,
    required int sets,
    required int reps,
    double? weight,
    String? comments,
  }) async {
    try {
      debugPrint('🔵 Creating workout exercise...');

      final dio = DioClient.dio;
      final response = await dio.post(
        '/workout-exercise',
        data: {
          'planId': planId,
          'exerciseId': exerciseId,
          'sets': sets,
          'reps': reps,
          'weight': weight,
          'comments': comments,
        },
      );

      debugPrint('🔵 Create response: ${response.data}');

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to create exercise');
      }

      debugPrint('✅ Exercise created successfully');
      return WorkoutExercise.fromJson(data['result']);
    } catch (e) {
      debugPrint('❌ createExercise error: $e');
      rethrow;
    }
  }

  /// ✅ Update workout exercise
  static Future<WorkoutExercise> updateExercise({
    required int workoutExerciseId,
    required int sets,
    required int reps,
    double? weight,
    String? comments,
  }) async {
    try {
      debugPrint('🔵 Updating workout exercise $workoutExerciseId...');

      final dio = DioClient.dio;
      final response = await dio.put(
        '/workout-exercise/$workoutExerciseId',
        data: {
          'sets': sets,
          'reps': reps,
          'weight': weight,
          'comments': comments,
        },
      );

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to update exercise');
      }

      debugPrint('✅ Exercise updated successfully');
      return WorkoutExercise.fromJson(data['result']);
    } catch (e) {
      debugPrint('❌ updateExercise error: $e');
      rethrow;
    }
  }

  /// ✅ Delete workout exercise
  static Future<void> deleteExercise(int workoutExerciseId) async {
    try {
      debugPrint('🔵 Deleting workout exercise $workoutExerciseId...');

      final dio = DioClient.dio;
      final response = await dio.delete('/workout-exercise/$workoutExerciseId');

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to delete exercise');
      }

      debugPrint('✅ Exercise deleted successfully');
    } catch (e) {
      debugPrint('❌ deleteExercise error: $e');
      rethrow;
    }
  }

  /// ✅ Get exercises by plan ID (alternative method - nếu backend có endpoint riêng)
  static Future<List<WorkoutExercise>> fetchExercisesByPlanId(
    int planId,
  ) async {
    try {
      debugPrint('🔵 Fetching exercises for plan $planId...');

      final dio = DioClient.dio;
      final response = await dio.get(
        '/workout-exercise/plan/$planId',
      ); // Nếu có endpoint này

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to get exercises');
      }

      final List list = data['result'] ?? [];
      final exercises = list.map((e) => WorkoutExercise.fromJson(e)).toList();

      debugPrint('✅ Fetched ${exercises.length} exercises for plan $planId');
      return exercises;
    } catch (e) {
      debugPrint('❌ fetchExercisesByPlanId error: $e');
      // Nếu endpoint không tồn tại, fallback về fetch all + filter
      debugPrint('⚠️ Falling back to fetch all + filter');
      final allExercises = await fetchMyWorkoutExercises();
      return filterExercisesByPlanId(allExercises, planId);
    }
  }

  /// ✅ Convert WorkoutExercise sang WorkoutMock format (để dùng với UI hiện tại)
  static Map<String, dynamic> convertToWorkoutMock(WorkoutExercise exercise) {
    return {
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSh4_YJj0WHX1lBkMo9uY5jytsD6VjEFXy41Q&s',
      'title': exercise.exerciseName,
      'sets': '${exercise.sets} sets',
      'reps': '${exercise.reps} reps',
      'weight': exercise.weight,
      'comments': exercise.comments,
    };
  }

  /// ✅ Refresh exercises cache
  static Future<void> refreshExercisesCache() async {
    debugPrint('🔄 Refreshing exercises cache...');
    // Implement caching logic if needed
  }
}
