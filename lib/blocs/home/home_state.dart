import 'package:da3afes/models/HomeResponse.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeState {}

class InitialHomeState extends HomeState {}

class LoadingHome extends HomeState {}

class FailedHome extends HomeState {}

class LoadedAd extends HomeState {
  final Ads ad;

  LoadedAd(this.ad);
}

class LoadedHome extends HomeState {
  final List<Ads> adsList;

  LoadedHome(this.adsList);
}
