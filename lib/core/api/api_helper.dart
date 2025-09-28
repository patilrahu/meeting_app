import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meeting_app/core/api/api_url.dart';

class ApiHelper {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "accept": "application/json",
        "Content-Type": "application/json",
        "x-api-key": dotenv.env['API_KEY'],
      },
    ),
  );

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _successResponse(response);
    } on DioException catch (e) {
      return _errorResponse(e);
    }
  }

  Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.post(endpoint, data: data);
      return _successResponse(response);
    } on DioException catch (e) {
      return _errorResponse(e);
    }
  }

  Response _successResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return Response(
          requestOptions: response.requestOptions,
          statusCode: response.statusCode,
          data: response.data,
        );
      default:
        return Response(
          requestOptions: response.requestOptions,
          statusCode: response.statusCode,
          data: {"error": "Unexpected status code: ${response.statusCode}"},
        );
    }
  }

  Response _errorResponse(DioException e) {
    return Response(
      requestOptions: e.requestOptions,
      statusCode: e.response?.statusCode ?? 500,
      data: {"error": e.response?.data ?? e.message},
    );
  }
}
