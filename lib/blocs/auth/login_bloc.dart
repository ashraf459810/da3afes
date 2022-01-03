import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:da3afes/application.dart';
import 'package:da3afes/models/LoginResponse.dart';
import 'package:da3afes/respositries/user_repository.dart';
import 'package:da3afes/services/login_api.dart';

import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => InitialLoginState();

  String email;
  String token;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is Login) {
      yield LoadingLogin();
      LoginResponse response =
          await LoginApi.login(event.username, event.password);
      if (response.aZSVR == "FAILED") {
        yield FailedLogin();
      } else if (response.aZSVR == "SUCCESS") {
        UserRepository().persistToken(response.aCCESSTOKEN);
        yield SuccessLogin();
      }
    }

    if (event is ThirdLogin) {
      yield LoadingLogin();
      LoginResponse response =
          await LoginApi.thirdLogin(event.method, event.token);
      if (response.aZSVR.toLowerCase() == "failed") {
        yield FailedLogin();
      } else if (response.aZSVR.toLowerCase() == "SUCCESS".toLowerCase()) {
        UserRepository().persistToken(response.aCCESSTOKEN);
        yield SuccessLogin();
      }
    }

    if (event is AppleLogin) {
      yield LoadingLogin();
      LoginResponse response =
          await LoginApi.thirdLogin(event.method, event.token);
      if (response.aZSVR.toLowerCase() == "failed") {
        eventBus.fire(event);
        yield FailedLogin();
      } else if (response.aZSVR.toLowerCase() == "SUCCESS".toLowerCase()) {
        UserRepository().persistToken(response.aCCESSTOKEN);
        yield SuccessLogin();
      }
    }
  }
}
