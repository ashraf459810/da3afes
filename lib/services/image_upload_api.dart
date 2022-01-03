import 'dart:io';

import 'package:da3afes/models/ImageUploadResponse.dart';
import 'package:dio/dio.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'api_client.dart';

class ImageUploadApi {
  static Future<ImageUploadResponse> load(File file) async {
    try {
      List<int> postData = file.readAsBytesSync();
      int length = await file.length();
      var response = await ApiClient.getUploadClient()
          .post("?cmd=UploadImage&type=profile&file_size=$length",
              data: Stream.fromIterable(
                postData.map((e) => [e]),
              ), //
              options: Options(
                headers: {
                  Headers.contentLengthHeader:
                      postData.length, // set content-length
                },
              ) // create a Stream<List<int>>
              );

      print("dio response " + response.toString());
      return ImageUploadResponse.fromJson(response.data);
    } on Exception catch (e, stack) {
      print(e);
      print(stack);
      return ImageUploadResponse.name("failed from dio");
    }
  }

  static Future<String> uploadAd(
      List<Asset> assets, List<String> images) async {
    List<String> list = [];
    if (images != null) list.addAll(images);

    for (var element in assets) {
      try {
        var bytedata = await element.getByteData(quality: 80);
        var buffer = bytedata.buffer;

        List<int> postData =
            buffer.asInt8List(bytedata.offsetInBytes, bytedata.lengthInBytes);

        int length = buffer.lengthInBytes;

        print(" " + length.toString() + " " + postData.length.toString());
        var response = await ApiClient.getUploadClient()
            .post("?cmd=UploadImage&type=ads&file_size=$length",
                data: Stream.fromIterable(
                  postData.map((e) => [e]),
                ), //
                options: Options(
                  headers: {
                    Headers.contentLengthHeader: postData.length,
                    // set content-length
                  },
                ) // create a Stream<List<int>>
                );
        print("first index");
        list.add(ImageUploadResponse.fromJson(response.data).fileName);
      } catch (Exception) {
        print(Exception.toString());
        //nothing here... :/
      }
    }

    var result = list
        .toString()
        .replaceAll(']', '')
        .replaceAll('[', '')
        .replaceAll(" ", "");

    print("result is => $result");
    return result;
  }
}
