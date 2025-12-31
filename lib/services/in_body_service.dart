// lib/services/in_body_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/in_body_data.dart';
import '../network/dio_client.dart';

class InBodyService {
  /// ✅ Fetch all InBody records của user
  static Future<List<InBodyData>> fetchMyInBodyRecords() async {
    try {
      debugPrint('🔵 Fetching InBody records...');

      final dio = DioClient.dio;
      final response = await dio.get('/user-in-body/my-in-body');

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
        debugPrint('⚠️ No InBody records found');
        return []; // ✅ Return empty list (not error)
      }

      final records =
          list.map((e) {
            debugPrint('🔵 Parsing record: $e');
            return InBodyData.fromJson(e);
          }).toList();

      debugPrint('✅ Successfully fetched ${records.length} InBody records');
      return records;
    } catch (e, stack) {
      debugPrint('❌ fetchMyInBodyRecords error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  /// ✅ Lấy record mới nhất (theo measuredAt)
  static Future<InBodyData?> fetchLatestInBodyRecord() async {
    try {
      final records = await fetchMyInBodyRecords();

      if (records.isEmpty) {
        debugPrint('⚠️ No records to get latest from');
        return null;
      }

      // Sort by measuredAt descending (mới nhất lên đầu)
      records.sort((a, b) => b.measuredAt.compareTo(a.measuredAt));

      final latest = records.first;
      debugPrint(
        '✅ Latest record: ID ${latest.id}, measured at ${latest.measuredAt}',
      );

      return latest;
    } catch (e) {
      debugPrint('❌ fetchLatestInBodyRecord error: $e');
      rethrow;
    }
  }

  /// ✅ Get record by ID
  static Future<InBodyData> getInBodyRecordById(int id) async {
    try {
      debugPrint('🔵 Fetching InBody record $id...');

      final dio = DioClient.dio;
      final response = await dio.get('/user-in-body/$id');

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to get record');
      }

      debugPrint('✅ Record fetched successfully');
      return InBodyData.fromJson(data['result']);
    } catch (e) {
      debugPrint('❌ getInBodyRecordById error: $e');
      rethrow;
    }
  }

  /// ✅ Create new InBody record
  static Future<InBodyData> createInBodyRecord({
    required DateTime measuredAt,
    required double height,
    required double weight,
    required double bodyFatPercentage,
    required double muscleMass,
    String? notes,
  }) async {
    try {
      debugPrint('🔵 Creating InBody record...');

      final dio = DioClient.dio;
      final response = await dio.post(
        '/user-in-body',
        data: {
          'measuredAt': measuredAt.toIso8601String(),
          'height': height,
          'weight': weight,
          'bodyFatPercentage': bodyFatPercentage,
          'muscleMass': muscleMass,
          'notes': notes,
        },
      );

      debugPrint('🔵 Create response: ${response.data}');

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to create record');
      }

      debugPrint('✅ InBody record created successfully');
      return InBodyData.fromJson(data['result']);
    } catch (e) {
      debugPrint('❌ createInBodyRecord error: $e');
      rethrow;
    }
  }

  /// ✅ Update InBody record
  static Future<InBodyData> updateInBodyRecord({
    required int id,
    required DateTime measuredAt,
    required double height,
    required double weight,
    required double bodyFatPercentage,
    required double muscleMass,
    String? notes,
  }) async {
    try {
      debugPrint('🔵 Updating InBody record $id...');

      final dio = DioClient.dio;
      final response = await dio.put(
        '/user-in-body/$id',
        data: {
          'measuredAt': measuredAt.toIso8601String(),
          'height': height,
          'weight': weight,
          'bodyFatPercentage': bodyFatPercentage,
          'muscleMass': muscleMass,
          'notes': notes,
        },
      );

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to update record');
      }

      debugPrint('✅ InBody record updated successfully');
      return InBodyData.fromJson(data['result']);
    } catch (e) {
      debugPrint('❌ updateInBodyRecord error: $e');
      rethrow;
    }
  }

  /// ✅ Delete InBody record
  static Future<void> deleteInBodyRecord(int id) async {
    try {
      debugPrint('🔵 Deleting InBody record $id...');

      final dio = DioClient.dio;
      final response = await dio.delete('/user-in-body/$id');

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to delete record');
      }

      debugPrint('✅ InBody record deleted successfully');
    } catch (e) {
      debugPrint('❌ deleteInBodyRecord error: $e');
      rethrow;
    }
  }
}
