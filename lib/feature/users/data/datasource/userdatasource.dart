import 'package:meeting_app/core/api/api_helper.dart';
import 'package:meeting_app/core/api/api_url.dart';
import 'package:meeting_app/feature/users/data/model/user_response_model.dart';

class UserRemoteDataSource {
  final ApiHelper _apiHelper;

  UserRemoteDataSource(this._apiHelper);

  Future<UserResponseModel> getUsers() async {
    final response = await _apiHelper.get(ApiUrl.userListUrl);

    return UserResponseModel.fromJson(response.data);
  }
}
