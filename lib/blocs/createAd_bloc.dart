import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/models/DefaultResponse.dart';
import 'package:da3afes/respositries/user_repository.dart';
import 'package:da3afes/services/ad_api.dart';
import 'package:da3afes/services/image_upload_api.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/src/asset.dart';

class CreateAdBloc extends Bloc<CreateAdEvent, CreateAdState> {
  @override
  CreateAdState get initialState => CreateAdInitial();

  @override
  Stream<CreateAdState> mapEventToState(
    CreateAdEvent event,
  ) async* {
    if (event is Submit) {
      print("submit bloc");
      print(event.images.toString());
      yield LoadingCreateAd();
      var images = await ImageUploadApi.uploadAd(event.images, []);
      var map = event.adInfo;
      map["token"] = await UserRepository().getToken();
      map["images"] = images;
      var response = await AdApi.create(map);
      yield SubmittedAd(response);
    }

    if (event is Update) {
      print("update bloc");
      print(event.images.toString());
      yield LoadingCreateAd();
      List<String> stringImages = event.images
          .where((element) => element is String)
          .toList()
          .cast<String>();

      List<Asset> assetImages = event.images
          .where((element) => element is Asset)
          .toList()
          .cast<Asset>();
      var images = await ImageUploadApi.uploadAd(assetImages, stringImages);
      var map = event.adInfo;
      map = map.clean();
      map["token"] = await UserRepository().getToken();
      map["images"] = images;
      map['token'] = await UserRepository().getToken();
      map.removeWhere((key, value) => key == 'comments');
      map.removeWhere((key, value) => key == 'condition');
      map.removeWhere((key, value) => key == 'model_text');
      map.removeWhere((key, value) => key == 'km_text');
      map.removeWhere((key, value) => key == 'transmission_text');
      map.removeWhere((key, value) => key == 'cat_text');
      map.removeWhere((key, value) => key == 'make_text');
      map.removeWhere((key, value) => key == 'color_text');
      map.removeWhere((key, value) => key == 'model_text');
      map.removeWhere((key, value) => key == 'images_folder');
      map.removeWhere((key, value) => key == 'city_text');
      map.removeWhere((key, value) => key == 'fuel_text');
      map.removeWhere((key, value) => key == 'user_full_name');
      map.removeWhere((key, value) => key == 'user_phone');
      map.removeWhere((key, value) => key == 'date_added');
      map.removeWhere((key, value) => key == 'user_profile_picture');
      var response = await AdApi.update(map);
      yield SubmittedAd(response);
    }
  }
}

@immutable
abstract class CreateAdEvent {}

class Submit extends CreateAdEvent {
  final Map<String, dynamic> adInfo;
  final List<dynamic> images;

  Submit(this.adInfo, this.images);
}

class Update extends CreateAdEvent {
  final Map<String, dynamic> adInfo;
  final List<dynamic> images;

  Update(this.adInfo, this.images);
}

@immutable
abstract class CreateAdState {}

class CreateAdInitial extends CreateAdState {}

class LoadingCreateAd extends CreateAdState {}

class SubmittedAd extends CreateAdState {
  final DefaultResponse response;

  SubmittedAd(this.response);
}
