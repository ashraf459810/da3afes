import 'dart:convert';

import 'package:da3afes/models/ListReportsResponse.dart';
import 'package:da3afes/respositries/user_repository.dart';

import 'api_client.dart';

class VinApi {
  static Future<ListReportsResponse> getUserReprts() async {
    var client = ApiClient.getClient();
    var token = await UserRepository().getToken();
    var url = ("?cmd=ListUserReports&token=$token");

    try {
      var response = await client.get(url.toString());
      print(response.request.uri.toString());
      return ListReportsResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      throw e;
    }
  }

  static Future<String> getReport(String id) async {
    var client = ApiClient.getClient();
    var token = await UserRepository().getToken();
    var url = ("?cmd=ReadReport&token=$token&id=$id");

    try {
      var response = await client.get(url.toString());
      print(response.request.uri.toString());
      print(response.headers.toString());
      return jsonEncode(response.data);
    } on Exception catch (e, stack) {
      throw e;
    }
  }
}
