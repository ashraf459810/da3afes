import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const secret = "ea4a17aaa6d7910b2bede0d012dd62df";
  static const key = "92481583a9d03bbe0944caed1e0cc797";
  static const baseUrl = "http://daafees.com/main/api/api.php";

  static final baseOptions = new BaseOptions(
    baseUrl: "http://daafees.com/main/api/api.php",
    connectTimeout: 7000,
    receiveTimeout: 7000,
    headers: {"content-type": "application/x-www-form-urlencoded"},
  );
  static final uploadOptions = new BaseOptions(
    baseUrl: "http://daafees.com/main/api/api.php",
    connectTimeout: 10000,
    receiveTimeout: 10000,
    headers: {"content-type": "application/x-www-form-urlencoded"},
  );

  static Dio createDio() {
    return Dio(baseOptions);
  }

  static Dio addInterceptors(Dio dio) {
    return dio
      ..interceptors.add(InterceptorsWrapper(
          onRequest: (RequestOptions options) => requestInterceptor(options)));
  }

  static dynamic requestInterceptor(RequestOptions options) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String token = await storage.read(key: "token");
    options.queryParameters.addAll({"token": "$token"});
    return options;
  }

  static Dio getClient() {
    return createDio();
  }

  static Dio getTokenizedClient() {
    var dio = createDio();
    addInterceptors(dio);
    return dio;
  }

  static Dio getUploadClient() {
    return Dio(uploadOptions);
  }
}
