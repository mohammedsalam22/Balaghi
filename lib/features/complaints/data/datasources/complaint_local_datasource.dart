import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/complaint_model.dart';

abstract class ComplaintLocalDataSource {
  Future<List<ComplaintModel>> getCachedComplaints();
  Future<void> cacheComplaints(List<ComplaintModel> complaints);
  Future<void> clearCache();
  Future<DateTime?> getLastCacheTime();
}

class ComplaintLocalDataSourceImpl implements ComplaintLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _cacheKey = 'cached_complaints';
  static const String _cacheTimeKey = 'complaints_cache_time';
  static const Duration _cacheValidDuration = Duration(hours: 1);

  ComplaintLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ComplaintModel>> getCachedComplaints() async {
    try {
      final cacheTime = await getLastCacheTime();
      if (cacheTime == null) {
        return [];
      }

      // Check if cache is still valid
      final now = DateTime.now();
      if (now.difference(cacheTime) > _cacheValidDuration) {
        // Cache expired, return empty list to force refresh
        return [];
      }

      final jsonString = sharedPreferences.getString(_cacheKey);
      if (jsonString == null) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => ComplaintModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If cache is corrupted, clear it and return empty
      await clearCache();
      return [];
    }
  }

  @override
  Future<void> cacheComplaints(List<ComplaintModel> complaints) async {
    try {
      final jsonList = complaints
          .map((complaint) => complaint.toJson())
          .toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(_cacheKey, jsonString);
      await sharedPreferences.setString(
        _cacheTimeKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      // Silently fail caching - not critical
    }
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(_cacheKey);
    await sharedPreferences.remove(_cacheTimeKey);
  }

  @override
  Future<DateTime?> getLastCacheTime() async {
    final timeString = sharedPreferences.getString(_cacheTimeKey);
    if (timeString == null) {
      return null;
    }
    try {
      return DateTime.parse(timeString);
    } catch (e) {
      return null;
    }
  }
}
