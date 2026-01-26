import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class LyricsProvider extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  bool isLoading = false;
  String? artist;
  String? song;
  String? lyrics;
  String? error;

  Future<void> generateLyrics(String link) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _dio.post(
        '/api/generate-lyrics',
        data: {
          'link': link,
        },
      );

      final json = response.data;

      if (response.statusCode == 200 && json['status'] == 'success') {
        artist = json['data']['artist'];
        song = json['data']['song'];
        lyrics = json['data']['lyrics'];
      } else {
        error = 'Failed to generate lyrics';
      }
    } on DioException catch (e) {
      // Better error handling
      error = e.response?.data?['message'] ??
          e.message ??
          'Something went wrong';
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
