import 'package:da3afes/models/HomeResponse.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent {}

class LoadAds extends HomeEvent {}

class ShowAd extends HomeEvent {
  final Ads ad;

  ShowAd(this.ad);
}
