import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:moodify/core/model/saved_video.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@immutable
final class AppStart {
  const AppStart._();

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: DoubleConstant.twelve.toInt()),
      receiveTimeout: Duration(seconds: DoubleConstant.twelve.toInt()),
    ),
  );

  static String supabaseUrl = '';
  static String supabaseAnonKey = '';
  static String vimeoBaseUrl = '';
  static String vimeoAccessToken = '';

  static Future<void> init() async {
    const endpoint =
        'https://wofblnggxhjoxijmofpb.supabase.co/functions/v1/get-secrets';

    try {
      final res = await _dio.get<dynamic>(endpoint);

      // Dio bazen already-decoded (Map) bazen String döndürebilir
      final data = switch (res.data) {
        final Map<String, dynamic> m => m,
        final String s => jsonDecode(s) as Map<String, dynamic>,
        _ => <String, dynamic>{},
      };

      supabaseUrl = (data['SUPABASE_URL'] ?? '').toString();
      supabaseAnonKey = (data['SUPABASE_ANON_KEY'] ?? '').toString();
      vimeoBaseUrl = (data['VIMEO_BASE_URL'] ?? '').toString();
      vimeoAccessToken = (data['VIMEO_ACCESS_TOKEN'] ?? '').toString();
    } on Exception catch (_) {
      // Hata durumunda boş string'lerle devam eder
      supabaseUrl = '';
      supabaseAnonKey = '';
      vimeoBaseUrl = '';
      vimeoAccessToken = '';
    }

    // Supabase initialization
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    // Hive initialization
    await Hive.initFlutter();
    Hive.registerAdapter(SavedVideoAdapter());
    await Hive.openBox<SavedVideo>('saved_videos');
  }
}
