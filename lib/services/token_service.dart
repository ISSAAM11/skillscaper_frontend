import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillscaper_app/exceptions/exceptions.dart';
import 'package:skillscaper_app/utils/utils.dart';

class TokenService {
  Future<(String?, String?)> retrieveToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return (null, null);
    }
    final userData = json.decode(prefs.getString('userData')!) as Map;
    return (userData['token'] as String, userData['full_name'] as String);
  }

  Future<(String, String)> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = (json.decode(prefs.getString('userData')!) as Map);
    final refreshToken = userData['refresh_token'];
    final url = Uri.parse("http://$serverPath/api/v1/auth/refresh/");
    try {
      final Dio dio = Dio();
      final data = {'refresh': refreshToken};
      final response = await dio.postUri(url, data: data);

      userData['token'] = response.data['access'];
      await prefs.setString('userData', json.encode(userData));

      return (
        response.data['access'] as String,
        userData['full_name'] as String
      );
    } on DioException catch (e) {
      throw NetworkNotFoundException('Network error occurred: ${e.toString()}');
    } catch (e) {
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }
}
