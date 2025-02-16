import 'package:dio/dio.dart';
import 'package:skillscaper_app/exceptions/exceptions.dart';
import 'package:skillscaper_app/models/exam/exam.dart';
import 'package:skillscaper_app/utils/utils.dart';

class ExamService {
  Future<Exam> retrieveOneExamRequest(idUser, token) async {
    final url = Uri.parse("http://$serverPath/api/exam/exams/${idUser}/");
    try {
      final Dio dio = Dio();
      final response = await dio.getUri(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      handleNoDataReceivedException(response);

      try {
        final Exam exam = Exam.fromJson(response.data);

        return exam;
      } catch (parseError) {
        throw ServerException(response.statusCode,
            'Failed to parse exam : ${parseError.toString()}');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw NetworkNotFoundException('Network error occurred: ${e.toString()}');
    } catch (e) {
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }
}
