import 'package:da3afes/models/DefaultResponse.dart';
import 'package:da3afes/respositries/user_repository.dart';

import 'api_client.dart';

class ContactApi {
  static Future<DefaultResponse> submit(String title, String msg) async {
    var token = await UserRepository().getToken();
    var client = ApiClient.getClient();
    try {
      var response = await client.post(
        "?cmd=SendMsgToAdminPanel&title=$title&token=$token&msg=$msg",
      );
      print(response.data.toString());
      return DefaultResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }
}
