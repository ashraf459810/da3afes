import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:da3afes/application.dart';
import 'package:da3afes/respositries/user_repository.dart';

import '../bloc.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static const kTokenField = "t";

  final userRepository = new UserRepository();

  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthenticateEvent) {
      final bool hasToken = await userRepository.hasToken();
      if (hasToken) {
        await refreshData();
        eventBus.fire(onAuthentcatedResume());
        yield AuthenticatedState();
      } else
        yield (NotAuthenticatedState());
    }
    if (event is AuthenticatedEvent) {
      refreshData();
      yield AuthenticatedState();
    }
  }
}
