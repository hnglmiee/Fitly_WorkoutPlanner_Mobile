// lib/services/exercise_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/exercise_models.dart';
import '../network/dio_client.dart';

class ExerciseService {
  /// Lấy tất cả exercise categories (muscle groups)
  static Future<List<ExerciseCategory>> fetchExerciseCategories() async {
    try {
      debugPrint('🔵 Fetching exercise categories...');

      final dio = DioClient.dio;
      final response = await dio.get('/exercise/exercise-categories');

      debugPrint('🔵 Response status: ${response.statusCode}');
      debugPrint('🔵 Response data: ${response.data}');

      final data =
      response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        final message = data['message'] ?? 'Unknown error';
        debugPrint('❌ API error: $message');
        throw Exception('API Error: $message');
      }

      final List list = data['result'] ?? [];
      debugPrint('🔵 Categories list length: ${list.length}');

      if (list.isEmpty) {
        debugPrint('⚠️ No exercise categories found');
        return [];
      }

      final categories = list.map((e) {
        debugPrint('🔵 Parsing category: $e');
        return ExerciseCategory.fromJson(e as Map<String, dynamic>);
      }).toList();

      debugPrint('✅ Successfully fetched ${categories.length} categories');
      return categories;
    } catch (e, stack) {
      debugPrint('❌ fetchExerciseCategories error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  /// Lấy tất cả exercises
  static Future<List<ExerciseData>> fetchExercises() async {
    try {
      debugPrint('🔵 Fetching exercises...');

      final dio = DioClient.dio;
      final response = await dio.get('/exercise/exercise');

      debugPrint('🔵 Response status: ${response.statusCode}');
      debugPrint('🔵 Response data: ${response.data}');

      final data =
      response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        final message = data['message'] ?? 'Unknown error';
        debugPrint('❌ API error: $message');
        throw Exception('API Error: $message');
      }

      final List list = data['result'] ?? [];
      debugPrint('🔵 Exercises list length: ${list.length}');

      if (list.isEmpty) {
        debugPrint('⚠️ No exercises found');
        return [];
      }

      final exercises = list.map((e) {
        debugPrint('🔵 Parsing exercise: $e');
        return ExerciseData.fromJson(e as Map<String, dynamic>);
      }).toList();

      debugPrint('✅ Successfully fetched ${exercises.length} exercises');
      return exercises;
    } catch (e, stack) {
      debugPrint('❌ fetchExercises error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  /// Lấy exercises theo categoryId (Optional - nếu backend support)
  static Future<List<ExerciseData>> fetchExercisesByCategory(
      int categoryId) async {
    try {
      debugPrint('🔵 Fetching exercises for category $categoryId...');

      final dio = DioClient.dio;
      final response =
      await dio.get('/exercise/exercise/category/$categoryId');

      debugPrint('🔵 Response status: ${response.statusCode}');
      debugPrint('🔵 Response data: ${response.data}');

      final data =
      response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        final message = data['message'] ?? 'Unknown error';
        debugPrint('❌ API error: $message');
        throw Exception('API Error: $message');
      }

      final List list = data['result'] ?? [];
      debugPrint('🔵 Exercises list length: ${list.length}');

      final exercises = list.map((e) {
        return ExerciseData.fromJson(e as Map<String, dynamic>);
      }).toList();

      debugPrint(
          '✅ Successfully fetched ${exercises.length} exercises for category $categoryId');
      return exercises;
    } catch (e, stack) {
      debugPrint('❌ fetchExercisesByCategory error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }
}