import 'package:da3afes/application.dart';
import 'package:da3afes/models/DefaultResponse.dart';
import 'package:da3afes/respositries/user_repository.dart';

import 'api_client.dart';

class WishlistApi {
  static Future<DefaultResponse> add(String id) async {
    var client = ApiClient.getClient();
    var token = await UserRepository().getToken();
    try {
      var response = await client.get(
        "?cmd=AddToWishlist&token=$token&id=$id",
      );
      var result = DefaultResponse.fromJson(response.data);
      print("remove wishlist");
      print(response.request.uri.toString());
      if (result.aZSVR.toLowerCase() == "success") await refreshData();
      print(response.data.toString());
      return result;
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<DefaultResponse> remove(String id) async {
    var client = ApiClient.getClient();
    var token = await UserRepository().getToken();
    try {
      var response = await client.get(
        "?cmd=RemoveFromWishlist&token=$token&id=$id",
      );
      print("remove wishlist");
      print(response.request.uri.toString());
      var result = DefaultResponse.fromJson(response.data);
      if (result.aZSVR.toLowerCase() == "success") await refreshData();
      print(response.data.toString());

      return result;
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }
}
