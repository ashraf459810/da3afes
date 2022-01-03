import 'package:da3afes/models/HomeResponse.dart';
import 'package:da3afes/models/UserTypeResponse.dart';
import 'package:da3afes/respositries/user_repository.dart';

import 'api_client.dart';

class HomeApi {
  static Future<HomeReponse> load(Map<String, dynamic> filters) async {
    var client = ApiClient.getClient();
    var url = ("?cmd=SearchAds");
    filters.forEach((key, value) {
      url = url + ("&$key=$value");
    });
    print(url.toString());
    try {
      var response = await client.get(url.toString());
      print(response.request.uri.toString() + "request");
      return HomeReponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<UserTypeResponse> loadWakalas(
      Map<String, dynamic> filters) async {
    var client = ApiClient.getClient();
    var token = await UserRepository().getToken();
    var url = ("?cmd=SearchUserType&secret=zxy8l08ZycsOCsEY42Tc");
    filters.forEach((key, value) {
      url = url + ("&$key=$value");
    });
    print(ApiClient.baseUrl + url.toString());
    try {
      var response = await client.get(url.toString());
      print(response.data.toString());
      return UserTypeResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<HomeReponse> loadAd(String id) async {
    var client = ApiClient.getClient();
    try {
      var response = await client.get(
        "?cmd=SearchAds&id=$id",
      );
      return HomeReponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<HomeReponse> wakalaAd(String userid, String cat_id) async {
    var client = ApiClient.getClient();
    try {
      var response = await client.get(
        "?cmd=SearchAds&user_id=$userid&cat_id=$cat_id",
      );
      print(response.request.uri);

      return HomeReponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }
}
