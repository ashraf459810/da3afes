import 'package:da3afes/application.dart';
import 'package:da3afes/models/DefaultResponse.dart';
import 'package:da3afes/models/ProfileResponse.dart';
import 'package:da3afes/respositries/user_repository.dart';

import 'api_client.dart';

class ProfileApi {
  static Future<ProfileResponse> getProfile() async {
    var client = ApiClient.getClient();
    var token = await UserRepository().getToken();
    print(token);
    try {
      var response = await client.get(
        "?cmd=FullProfile&token=$token",
      );
      print(response.request.uri.toString());
      return ProfileResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<ProfileResponse> getUserProfile(String id) async {
    var client = ApiClient.getClient();
    var token = await UserRepository().getToken();
    print(token);
    try {
      var response = await client.get(
        "?cmd=FullProfile&token=$token&id=$id",
      );
      print(response.request.uri.toString());
      return ProfileResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<DefaultResponse> followProfile(String id) async {
    var client = ApiClient.getClient();
    var token = await UserRepository().getToken();
    print(token);
    try {
      var response = await client.get(
        "?cmd=Follow&token=$token&id=$id",
      );
      print(response.request.uri);
      print("follow request" + response.data.toString());
      refreshData();
      return DefaultResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<DefaultResponse> unFollowProfile(String id) async {
    var client = ApiClient.getClient();
    var token = await UserRepository().getToken();
    print(token);
    try {
      var response = await client.get(
        "?cmd=UnFollow&token=$token&id=$id",
      );
      print(response.request.uri.toString());
      return DefaultResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }
}
