import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent {}

class AuthenticateEvent extends AuthEvent {}

class AuthenticatedEvent extends AuthEvent {}

class IsAuthenticatedEvent extends AuthEvent {}

class AppleAuthLogin extends AuthEvent {
  String method;
  String token;
  AppleIdCredential cred;

  AppleAuthLogin(this.method, this.token, this.cred);
}
