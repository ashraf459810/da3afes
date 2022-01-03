import 'package:meta/meta.dart';

@immutable
abstract class AuthState {}

class InitialAuthState extends AuthState {}

class NotAuthenticatedState extends AuthState {}

class AuthenticatedState extends AuthState {}
