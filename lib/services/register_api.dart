import 'package:da3afes/models/DefaultResponse.dart';
import 'package:da3afes/models/RegisterResponse.dart';
import 'package:da3afes/respositries/user_repository.dart';
import 'package:dio/dio.dart';

import 'api_client.dart';

class RegisterApi {
  static Future<RegisterResponse> register(Map<String, dynamic> values) async {
    var client = ApiClient.getClient();
    try {
      var response =
          await client.post("?cmd=Register", data: FormData.fromMap(values));
      print("registerresponse==>" + response.toString());
      return RegisterResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<DefaultResponse> update(Map<String, dynamic> values) async {
    values['token'] = await UserRepository().getToken();
    var client = ApiClient.getClient();
    try {
      var response =
          await client.get("?cmd=UpdateUserInfo", queryParameters: values);
      print("UpdateUserInfo==>" + values.toString());
      print("UpdateUserInfo==>" + response.toString());
      return DefaultResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }
}
