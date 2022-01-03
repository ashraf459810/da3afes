import 'package:da3afes/models/DefaultResponse.dart';
import 'package:da3afes/models/HomeResponse.dart';
import 'package:da3afes/models/ProfileResponse.dart';
import 'package:da3afes/respositries/user_repository.dart';
import 'package:dio/dio.dart';

import 'api_client.dart';

class SuggestionsLastSeen {
  GetLastSeen lastSeen;
  HomeReponse suggestions;

  SuggestionsLastSeen(this.lastSeen, this.suggestions);
}

class AdApi {
  static Future<DefaultResponse> create(Map<String, dynamic> values) async {
    print(values.toString());
    var client = ApiClient.getClient();
    try {
      var response =
          await client.post("?cmd=NewAd", data: FormData.fromMap(values));
      print("Create Ad==>" + response.toString());
      return DefaultResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<DefaultResponse> update(Map<String, dynamic> values) async {
    print(values.toString());
    var client = ApiClient.getClient();
    try {
      var response = await client.post("?cmd=UpdateAdInfo",
          data: FormData.fromMap(values));

      print("UpdateAdInfo==>" + response.toString());
      return DefaultResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
    }
  }

  static Future<DefaultResponse> reportAd(String id, String type,
      {String notes}) async {
    var token = await UserRepository().getToken();
    var client = ApiClient.getClient();
    try {
      var response;
      if (notes == null)
        response = await client.get(
          "?cmd=ReportAd&id=$id&reason_id=$type&token=$token",
        );
      else
        response = await client.get(
          "?cmd=ReportAd&id=$id&reason_id=$type&token=$token&notes=$notes",
        );

      return DefaultResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<String> seen(String id) async {
    var token = await UserRepository().getToken();
    var client = ApiClient.getClient();
    try {
      var response = await client.get(
        "?cmd=AddToLastSeen&id=$id&token=$token",
      );
      return response.data.toString();
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<SuggestionsLastSeen> getBoth() async {
    var one = await getUserSuggestions();
    var two = await getLastSeen();
    return SuggestionsLastSeen(two, one);
  }

  static Future<HomeReponse> getUserSuggestions() async {
    var client = ApiClient.getClient();
    var token = await UserRepository().getToken();
    var url = ("?cmd=GetUserSuggestions&token=$token");

    print(url.toString());
    try {
      var response = await client.get(url.toString());
      print(response.data["AZSVR"].toString());
      return HomeReponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<HomeReponse> getUserAds(String id) async {
    var client = ApiClient.getClient();
    var url = ("?cmd=SearchAds&user_id=$id");

    print(url.toString());
    try {
      var response = await client.get(url.toString());
      print(response.data["AZSVR"].toString());
      return HomeReponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<GetLastSeen> getLastSeen() async {
    var client = ApiClient.getClient();
    var token = await UserRepository().getToken();
    var url = ("?cmd=GetLastSeen&token=$token");

    print(url.toString());
    try {
      var response = await client.get(url.toString());
      print(response.request.uri.toString());
      return GetLastSeen.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<DefaultResponse> addComment(String id, String comment) async {
    var token = await UserRepository().getToken();
    var client = ApiClient.getClient();
    try {
      print("" +
          ApiClient.baseUrl +
          "?cmd=AddComment&ads_id=$id&token=$token&comment=$comment");
      var response = await client.post(
        "?cmd=AddComment&ads_id=$id&token=$token&comment=$comment",
      );
      print(response.data.toString());
      return DefaultResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<DefaultResponse> remove(String id) async {
    var token = await UserRepository().getToken();
    var client = ApiClient.getClient();
    try {
      var response = await client.post("?cmd=RemoveAd&token=$token",
          data: FormData.fromMap({"id": id}));
      print(response.request.uri.toString());
      print(response.toString());
      return DefaultResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }
}
