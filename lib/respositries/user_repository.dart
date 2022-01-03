import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static const kTokenField = "t";

//

  Future<void> deleteToken() async {
    final storage = await SharedPreferences.getInstance();
    storage.remove(kTokenField);
  }

  Future<void> persistToken(String token) async {
    final storage = await SharedPreferences.getInstance();
    storage.setString(kTokenField, token);
  }

  Future<String> getToken() async {
    final storage = await SharedPreferences.getInstance();
    return storage.getString(kTokenField);
  }

  Future<bool> hasToken() async {
    final String token = await getToken();
    return token != "" && token != null;
  }
}
