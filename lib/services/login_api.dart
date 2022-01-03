import 'package:da3afes/models/DefaultResponse.dart';
import 'package:da3afes/models/LoginResponse.dart';

import 'api_client.dart';

class LoginApi {
  static Future<LoginResponse> login(String username, String password) async {
    var client = ApiClient.getClient();
    try {
      var response = await client.post("?cmd=Login",
          queryParameters: {"username": username, "password": password});
      print(response);
      return LoginResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<LoginResponse> thirdLogin(String key, String token) async {
    var client = ApiClient.getClient();
    try {
      var response = await client.get("?cmd=GetUserInfo", queryParameters: {
        "field": 'access_token',
        "byWhat": key,
        "id": token
      });
      print(response);
      return LoginResponse.fromJsonSec(response.data);
    } catch (e) {
      return LoginResponse.fromJson({'AZSVR': 'failed'});
    }
  }

  static Future<DefaultResponse> recover(String email) async {
    var client = ApiClient.getClient();
    try {
      var response = await client.get("?cmd=GeneratePWDLink&email=$email");
      print(response);
      return DefaultResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }
}
