import 'package:dio/dio.dart';
import 'package:skillscaper_app/exceptions/exceptions.dart';
import 'package:skillscaper_app/models/test_requiest.dart';
import 'package:skillscaper_app/utils/utils.dart';

class TestRequestService {
  Future<List<TestRequest>> retrieveTestRequest(idUser, token) async {
    final url = Uri.parse("$serverPath/api/exam/test_request/${idUser}");
    try {
      final Dio dio = Dio();
      final response = await dio.getUri(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      handleNoDataReceivedException(response);

      try {
        final List<TestRequest> testRequestList = (response.data as List)
            .map((e) {
              try {
                return TestRequest.fromJson(e);
              } catch (parseError) {
                return null;
              }
            })
            .whereType<TestRequest>()
            .toList();
        return testRequestList;
      } catch (parseError) {
        throw ServerException(response.statusCode,
            'Failed to parse test request: ${parseError.toString()}');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw NetworkNotFoundException('Network error occurred: ${e.toString()}');
    } catch (e) {
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<TestRequest> updateTestRequest(
      Map testRequestMap, String token) async {
    final url = Uri.parse(
        "$serverPath/api/exam/test_request/${testRequestMap["id"]}/update/");

    try {
      final Dio dio = Dio();
      final response = await dio.patchUri(url,
          data: testRequestMap,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      handleNoDataReceivedException(response);

      try {
        final TestRequest testRequest = TestRequest.fromJson(response.data);

        return testRequest;
      } catch (parseError) {
        throw ServerException(response.statusCode,
            'Failed to parse test request: ${parseError.toString()}');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw NetworkNotFoundException('Network error occurred: ${e.toString()}');
    } catch (e) {
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }
}
