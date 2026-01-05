// lib/models/exercise_models.dart
import 'package:flutter/material.dart';

/// Model cho Exercise Category (Muscle Group)
class ExerciseCategory {
  final int id;
  final String name;
  final String? description;

  ExerciseCategory({
    required this.id,
    required this.name,
    this.description,
  });

  factory ExerciseCategory.fromJson(Map<String, dynamic> json) {
    try {
      return ExerciseCategory(
        id: json['id'] as int,
        name: json['categoryName']?.toString() ?? 'Unknown', // ✅ Đổi từ 'name' -> 'categoryName'
        description: json['description']?.toString(),
      );
    } catch (e) {
      debugPrint('❌ Error parsing ExerciseCategory: $e');
      debugPrint('JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'ExerciseCategory(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Model cho Exercise Data
class ExerciseData {
  final int id;
  final String name;
  final String category; // Category name từ API (string)
  final String? description;
  final String? instructions;
  final String? videoUrl;

  // Helper field - sẽ được set sau khi match với categories
  int? _categoryId;

  ExerciseData({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.instructions,
    this.videoUrl,
    int? categoryId,
  }) : _categoryId = categoryId;

  // Getter để lấy categoryId
  int? get categoryId => _categoryId;

  // Setter để set categoryId sau khi match với categories list
  set categoryId(int? id) => _categoryId = id;

  /// Helper method để match category name với category ID
  void matchCategoryId(List<ExerciseCategory> categories) {
    try {
      final matchingCategory = categories.firstWhere(
            (cat) => cat.name.toLowerCase().trim() == category.toLowerCase().trim(),
      );
      _categoryId = matchingCategory.id;
      debugPrint('✅ Matched exercise "$name" -> category "${matchingCategory.name}" (id: ${matchingCategory.id})');
    } catch (e) {
      // Không tìm thấy category match
      debugPrint('⚠️ No matching category for exercise "$name" with category "$category"');
      _categoryId = null;
    }
  }

  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    try {
      return ExerciseData(
        id: json['id'] as int,
        name: json['name']?.toString() ?? 'Unknown', // Safe conversion
        category: json['category']?.toString() ?? 'Unknown', // Safe conversion
        description: json['description']?.toString(),
        instructions: json['instructions']?.toString(),
        videoUrl: json['videoUrl']?.toString(),
      );
    } catch (e) {
      debugPrint('❌ Error parsing ExerciseData: $e');
      debugPrint('JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'categoryId': _categoryId,
      'description': description,
      'instructions': instructions,
      'videoUrl': videoUrl,
    };
  }

  // Create a copy with updated categoryId
  ExerciseData copyWith({
    int? id,
    String? name,
    String? category,
    String? description,
    String? instructions,
    String? videoUrl,
    int? categoryId,
  }) {
    return ExerciseData(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      videoUrl: videoUrl ?? this.videoUrl,
      categoryId: categoryId ?? _categoryId,
    );
  }

  @override
  String toString() {
    return 'ExerciseData(id: $id, name: $name, category: $category, categoryId: $_categoryId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseData && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}