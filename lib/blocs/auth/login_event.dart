import 'package:apple_sign_in/apple_id_credential.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent {}

class Login extends LoginEvent {
  String username;
  String password;

  Login(this.username, this.password);
}

class ThirdLogin extends LoginEvent {
  String method;
  String token;

  ThirdLogin(this.method, this.token);
}

class AppleLogin extends LoginEvent {
  String method;
  String token;
  AppleIdCredential cred;

  AppleLogin(this.method, this.token, this.cred);
}
