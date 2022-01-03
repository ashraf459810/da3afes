import 'dart:convert';

import 'package:da3afes/models/MapResponse.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'api_client.dart';

//const apiKey = "AIzaSyAapj-O50HANt2anhKD5mS3vtviRfWESUQ";
const apiKey = "AIzaSyCpRYe1pxsjZJEldcgRkwEfVSKuUdbmoGc";

class MapApi {
  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
    print(url);
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    print("====================>>>>>>>>${values}");

    return values["routes"][0]["overview_polyline"]["points"];
  }

  static Future<MapResponse> load() async {
    var client = ApiClient.getClient();
    try {
      var response = await client.get(
        "?cmd=MapAds",
      );
      return MapResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }

  static Future<MapResponse> filter(String id) async {
    var client = ApiClient.getClient();
    try {
      var response = await client.get(
        "?cmd=MapAds&cat_id=$id",
      );
      return MapResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      throw e;
    }
  }
}
