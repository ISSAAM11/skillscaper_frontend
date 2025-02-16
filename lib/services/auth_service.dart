import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:skillscaper_app/exceptions/exceptions.dart';
import 'package:skillscaper_app/models/user.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:skillscaper_app/utils/utils.dart';

class AuthService {
  Future<void> loginUser(String username, String password) async {
    final url = Uri.parse("http://$serverPath/api/auth/login/");

    try {
      final Dio dio = Dio();
      final response = await dio.postUri(
        url,
        data: json.encode({"username": username, "password": password}),
        options: Options(contentType: Headers.jsonContentType),
      );
      final responseData = response.data;
      // final id = responseData['user']['id'];
      // final emailData = responseData['user']["email"];
      final fullName = username;
      final token = responseData['access'];
      final refreshToken = responseData['refresh'];

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'full_name': fullName,
          'token': token,
          'refresh_token': refreshToken,
        },
      );

      prefs.setString('userData', userData);

      // final user = User(
      //   id: id,
      //   email: emailData,
      //   name: fullName,
      // );
      // return user;
    } on DioException catch (e) {
      handleDioException(e);
      throw NetworkNotFoundException('Network error occurred: ${e.toString()}');
    } catch (e) {
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<Map?> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return null;
    }
    final userData = json.decode(prefs.getString('userData')!) as Map;

    return userData;
  }
}
