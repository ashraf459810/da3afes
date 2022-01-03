import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:da3afes/application.dart';
import 'package:da3afes/models/HomeResponse.dart';
import 'package:da3afes/services/home_api.dart';
import 'package:meta/meta.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  @override
  HomeState get initialState => InitialHomeState();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    _events.add(event);
    if (event is LoadAds) {
      yield LoadingHome();

      HomeReponse response = await HomeApi.load(event.filters);

//      print(response.toJson().toString());
      print(response.aZSVR);
      if (appData == null) await refreshData();

      if (response.aZSVR == "success") {
        print("succloaded");
        yield LoadedHome(response.ads);
      } else
        yield FailedHome();
    } else if (event is ShowAd) {
      yield LoadedAd(event.ad);
    } else if (event is SwitchTabEvent) {
      yield SwitchTabState(event.tab, event.filters);
    } else if (event is RefreshHome) {
      dispatchPreviousState();
    }
  }

  static final List<HomeEvent> _events = new List<HomeEvent>();

  dispatchPreviousState() {
    print(_events.removeLast());
    this.add(_events.last);
  }
}

@immutable
abstract class HomeEvent {}

class LoadAds extends HomeEvent {
  Map<String, dynamic> filters;

  LoadAds(this.filters);
}

class ShowAd extends HomeEvent {
  final Ads ad;

  ShowAd(this.ad);
}

class RefreshHome extends HomeEvent {}

@immutable
abstract class HomeState {}

class InitialHomeState extends HomeState {}

class SwitchTabState extends HomeState {
  TabCategory tab;
  Map<String, dynamic> filters;

  SwitchTabState(this.tab, this.filters);
}

class LoadingHome extends HomeState {}

class FailedHome extends HomeState {}

class LoadedAd extends HomeState {
  final Ads ad;

  LoadedAd(this.ad);
}

class SwitchTabEvent extends HomeEvent {
  TabCategory tab;
  Map<String, dynamic> filters;

  SwitchTabEvent(this.tab, this.filters);
}

enum TabCategory {
  Cars,
  Models,
  UserTypes,
  Services,
  SparePartsView,
  AccessoriesView,
  RetailersView,
  ShippingView
}

class LoadedHome extends HomeState {
  final List<Ads> adsList;

  LoadedHome(this.adsList);
}
