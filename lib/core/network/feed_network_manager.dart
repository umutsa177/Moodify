import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:moodify/product/initialize/app_start.dart';

class FeedNetworkManager {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppStart.vimeoBaseUrl,
      headers: {
        'Authorization': 'Bearer ${AppStart.vimeoAccessToken}',
      },
    ),
  );

  // Fetch videos with pagination
  Future<Map<String, dynamic>?> fetchVideos({
    required String mood,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/videos',
        queryParameters: {
          'query': mood,
          'page': page,
          'per_page': perPage,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        log('Vimeo API error: ${response.statusCode}');
      }
    } on Exception catch (e) {
      log('Error fetching Vimeo videos: $e');
    }
    return null;
  }
}
