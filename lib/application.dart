import 'package:da3afes/models/ProfileResponse.dart';
import 'package:da3afes/respositries/user_repository.dart';
import 'package:da3afes/services/profile_api.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';

EventBus eventBus = EventBus();
BuildContext singletonContext;

class SwitchTab {
  int index;
  SwitchTab(this.index);
}

class ProfileNavigation {
  InnerRoute route;
  ProfileNavigation(this.route);
}

enum InnerRoute { Profile }

class Refresh {}

class onAuthentcatedResume {}

ProfileResponse appData;
bool hasToken = false;
refreshData() async {
  hasToken = await UserRepository().hasToken();
  if (hasToken) appData = await ProfileApi.getProfile();
}

bool trigger = false;

Future<bool> checkMyAd(String id) async {
  if (appData != null) {
    for (var value in appData.myAds.ads) {
      if (value.id == id) return true;
    }
    return false;
  } else
    return false;
}

Future<bool> checkMyWishlistHome(String id) async {
  while (appData == null) {
    await Future.delayed(Duration(seconds: 1), () {});
  }

  if (appData != null) {
    for (var value in appData.wishList.wishlist) {
      if (value.id == id) return true;
    }
    return false;
  } else
    return false;
}

Future<bool> checkMyWishlist(String id) async {
  if (appData != null) {
    for (var value in appData.wishList.wishlist) {
      if (value.id == id) return true;
    }
    return false;
  } else
    return false;
}

Future<bool> checkFollowing(String id) async {
  appData = await ProfileApi.getProfile();
  if (appData != null) {
    for (var value in appData.following.following) {
      if (value.followingId == id) return true;
    }
    return false;
  } else
    return false;
}
