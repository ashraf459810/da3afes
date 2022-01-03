import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/respositries/user_repository.dart';
import 'package:da3afes/services/image_upload_api.dart';
import 'package:da3afes/services/register_api.dart';

import './bloc.dart';

class ImageUploadBloc extends Bloc<ImageUploadEvent, ImageUploadState> {
  @override
  ImageUploadState get initialState => InitialImageUploadState();

  var userRepo = new UserRepository();
  @override
  Stream<ImageUploadState> mapEventToState(
    ImageUploadEvent event,
  ) async* {
    if (event is UploadImageEvent) {
      yield UploadingState();
      if (event.image != null) {
        var response = await ImageUploadApi.load(event.image);
        print(response.toString());

        event.value["image"] = response.fileName;
//        event.value["user_type"] = "1";
      }

      print(event.value.toString());
      var registerResponse = await RegisterApi.register(event.value);
      print(registerResponse.toString());
      if (registerResponse.aZSVR == "SUCCESS") {
        userRepo.persistToken(registerResponse.aCCESSTOKEN);
        yield UploadedState(registerResponse.aZSVR);
      } else
        yield UploadedState(registerResponse.eRRORMSG);
    }
    if (event is ProfileEditEvent) {
      yield UploadingState();
      if (event.image != null) {
        var response = await ImageUploadApi.load(event.image);
        print(response.toString());

        event.value["image"] = response.fileName;
//        event.value["user_type"] = "1";
      }

      event.value['token'] = await UserRepository().getToken();
      event.value.removeWhere((key, value) => key == 'access_token');
      event.value.removeWhere((key, value) => key == 'password');
      print(event.value.clean().toString());
      var registerResponse = await RegisterApi.update(event.value);
      print(registerResponse.toString());

      yield UploadedState(registerResponse.aZSVR);
    }
  }
}
