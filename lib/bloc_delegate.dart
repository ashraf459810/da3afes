import 'package:bloc/bloc.dart';

class MyShopBlocDelegate extends BlocDelegate {
  @override
  Future<void> onTransition(Bloc bloc, Transition transition) async {
    final state = transition.currentState;

    print(bloc.toString());

    super.onTransition(bloc, transition);
  }

  @override
  Future<void> onEvent(Bloc bloc, Object event) async {
    print(bloc.toString() + " event==??>>" + event.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    // TODO: implement onError
    print(stackTrace.toString());
    print(bloc.toString());
    print(error.toString());
    super.onError(bloc, error, stackTrace);
  }
}
