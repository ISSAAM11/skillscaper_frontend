import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:skillscaper_app/exceptions/exceptions.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:skillscaper_app/models/user.dart';
import 'package:skillscaper_app/utils/utils.dart';

class AuthService {
  Future<User> loginUser(String username, String password) async {
    final url = Uri.parse("$serverPath/api/auth/login/");

    try {
      final Dio dio = Dio();
      final response = await dio.postUri(
        url,
        data: json.encode({"username": username, "password": password}),
        options: Options(contentType: Headers.jsonContentType),
      );
      final responseData = response.data;

      final token = responseData['access'];
      final refreshToken = responseData['refresh'];

      final thisUsername = responseData['username'];
      final userId = responseData['id'];
      final email = responseData['email'];

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          "id": userId,
          'full_name': thisUsername,
          "email": email,
          'token': token,
          'refresh_token': refreshToken,
        },
      );

      prefs.setString('userData', userData);

      final user = User(
        id: userId,
        email: email,
        name: thisUsername,
      );
      return user;
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

  Future<User?> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return null;
    }
    final userData = prefs.getString('userData')!;

    Map<String, dynamic> userMap = jsonDecode(userData);
    return User.fromJson(userMap);
  }
}
