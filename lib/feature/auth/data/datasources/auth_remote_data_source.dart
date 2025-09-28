import 'package:dio/dio.dart';
import 'package:meeting_app/core/api/api_helper.dart';
import 'package:meeting_app/core/api/api_url.dart';
import 'package:meeting_app/feature/auth/data/model/login_response_model.dart';

class AuthRemoteDataSource {
  final ApiHelper _apiHelper;

  AuthRemoteDataSource(this._apiHelper);

  Future<LoginResponseModel> login(
    String username,
    String email,
    String password,
  ) async {
    final response = await _apiHelper.post(
      ApiUrl.loginUrl,
      data: {"email": email, "password": password},
    );

    return LoginResponseModel.fromJson(response.data);
  }
}
