import 'dart:io';
import 'dart:io' show Platform;

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:async_loader/async_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:da3afes/application.dart';
import 'package:da3afes/blocs/auth/auth_bloc.dart';
import 'package:da3afes/blocs/auth/auth_state.dart';
import 'package:da3afes/blocs/bloc.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/models/ProfileResponse.dart';
import 'package:da3afes/respositries/user_repository.dart';
import 'package:da3afes/screens/PromoteScreen.dart';
import 'package:da3afes/screens/auth/login_screen.dart';
import 'package:da3afes/screens/contactus_screen.dart';
import 'package:da3afes/screens/following_ads_screen.dart';
import 'package:da3afes/screens/following_screen.dart';
import 'package:da3afes/screens/myads_screen.dart';
import 'package:da3afes/screens/vin_reports_screen.dart';
import 'package:da3afes/screens/wallet_screen.dart';
import 'package:da3afes/services/profile_api.dart';
import 'package:da3afes/services/register_api.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import 'SettingsScreen.dart';
import 'auth/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  final authBLoc = new AuthBloc();
  var refresh = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      //check for ios if developing for both android & ios
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBLoc,
      builder: (BuildContext context, AuthState state) {
        if (state is AuthenticatedState) {
          return buildProfile();
        } else if (state is NotAuthenticatedState) {
          return LoginScreen(authBLoc, context);
        } else if (state is InitialAuthState) {
          authBLoc.add(AuthenticateEvent());
          return Scaffold(
              appBar: defaultAppBar(""),
              body: (appData != null)
                  ? buildScreen(appData)
                  : Center(child: CircularProgressIndicator()));
        }
        return Scaffold(
            appBar: defaultAppBar(""),
            body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget buildProfile() {
    int _index =
        0; // Make sure this is outside build(), otherwise every setState will chage the value back to 0

    // return Scaffold(
    //   appBar: defaultAppBar("الصفحة الشخصية"),
    //   body: Center(
    //     child: AsyncLoader(
    //         key: _asyncLoaderState,
    //         initState: () async => await ProfileApi.getProfile(),
    //         renderLoad: () => CircularProgressIndicator(),
    //         renderError: ([error]) => LiquidPullToRefresh(
    //               showChildOpacityTransition: false,
    //               onRefresh: () async {
    //                 _asyncLoaderState.currentState.reloadState();
    //               },
    //               child: Center(
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: new Text(
    //                     'Sorry, there was an error loading your profile, please swipe to refresh',
    //                     textAlign: TextAlign.center,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //         renderSuccess: ({data}) {
    //           var response = data as ProfileResponse;
    //           if (response != null && response.profile != null)
    //             return Container(
    //               decoration: appBackground,
    //               height: double.infinity,
    //               child: LiquidPullToRefresh(
    //                 showChildOpacityTransition: false,
    //                 onRefresh: () async {
    //                   _asyncLoaderState.currentState.reloadState();
    //                 },
    //                 child: ListView(
    //                   children: <Widget>[
    //                     buildProfileHeader(response.profile[0]),
    //                     buildCounters(response),
    //                     buildGrid(response)
    //                   ],
    //                 ),
    //               ),
    //             );
    //           else {
    //             refresh = true;
    //             UserRepository().deleteToken();
    //             authBLoc.add(AuthenticateEvent());
    //             return Text("حصل خطاء ما ");
    //           }
    //         }),
    //   ),
    // );
    // print("profile availablility >>>>> " + (appData != null).toString());
    return Scaffold(
      appBar: defaultAppBar("الصفحة الشخصية"),
      body: Center(
        child: AsyncLoader(
            key: _asyncLoaderState,
            initState: () async => await ProfileApi.getProfile(),
            renderLoad: () => (appData != null)
                ? buildScreen(appData)
                : CircularProgressIndicator(),
            renderError: ([error]) => LiquidPullToRefresh(
                  showChildOpacityTransition: false,
                  onRefresh: () async {
                    _asyncLoaderState.currentState.reloadState();
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Text(
                        'Sorry, there was an error loading your profile, please swipe to refresh',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            renderSuccess: ({data}) {
              var response = data as ProfileResponse;
              if (response != null && response.profile != null)
                return buildScreen(response);
              else {
                refresh = true;
                UserRepository().deleteToken();
                authBLoc.add(AuthenticateEvent());
                return Text("حصل خطاء ما ");
              }
            }),
      ),
    );
  }

  Container buildScreen(ProfileResponse response) {
    return Container(
      decoration: appBackground,
      height: double.infinity,
      child: ListView(
        children: <Widget>[
          buildProfileHeader(response.profile[0]),
          buildCounters(response),
          buildGrid(response)
        ],
      ),
    );
  }

  Column buildCounters(ProfileResponse response) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.black,
          height: 1,
          width: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    response.countAdsViews.sumViews ?? "0",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    Trans.I.late("المشاهدات"),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    response.followers.following != null
                        ? response.followers.following.length.toString()
                        : "0",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    Trans.I.late("المتابعين"),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    response.following.following != null
                        ? response.following.following.length.toString()
                        : "0",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    Trans.I.late("المتابعون"),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          color: Colors.black,
          height: 1,
          width: double.infinity,
        ),
      ],
    );
  }

  Container buildProfileHeader(Profile response) {
    print(ppImgDir + response.image);

    return Container(
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: yellowAmber),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        //TEMPORARY PLACEHOLDER
                        imageUrl: (ppImgDir + response.image),
                        fit: BoxFit.cover,
                        width: 110,
                        height: 120,
//                      image: CacheImage(
//                        "https://www.attractivepartners.co.uk/wp-content/uploads/2017/06/profile.jpg",
//                      ),
                      ),
                    ),
                  ),
                  divider(10),
                  Text(
                    response.fullName ?? "",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    Trans.I.late("مستخدم"),
                    style: TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.grey),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      editProfileButton(context, response),
                      divider(10),
                      buildTrustBtn(response)
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Function callback(String key, BuildContext dcontext) {
    return (TrustStatus s, String m) async {
      if (s == TrustStatus.success) {
        await RegisterApi.update({"$key": m}).then((value) => null);
        Navigator.pop(dcontext);
        _asyncLoaderState.currentState.reloadState();
      }
    };
  }

  InkWell buildTrustBtn(Profile profile) {
    return InkWell(
      onTap: () async {
        showDialog(
          context: context,
          builder: (dcontext) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 66,
                      bottom: 16,
                      right: 16,
                      left: 16,
                    ),
                    margin: EdgeInsets.only(top: 66),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: yellowAmber, width: 2),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          SocialCover(
                            child: SignInButton(
                              Buttons.Facebook,
                              onPressed: () {
                                handleFacebookSignIn(
                                    callback("og_id", dcontext));
                              },
                            ),
                            isActive: profile.ogId.isNotEmpty,
                          ),
                          if (Platform.isIOS)
                            SocialCover(
                              child: SignInButton(
                                Buttons.AppleDark,
                                onPressed: () {
                                  appleLogIn(callback("apple_id", dcontext));
                                },
                              ),
                              isActive: (profile.appleId != null),
                            )
                          else
                            Container(),
                          SocialCover(
                            child: SignInButton(
                              Buttons.GoogleDark,
                              onPressed: () {
                                handleGoogleSignIn(
                                    callback("og_type", dcontext));
                              },
                            ),
                            isActive: profile.ogType.isNotEmpty,
                          ),
                          divider(5),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 66,
                      child: Icon(
                        MaterialCommunityIcons.shield_lock_outline,
                        size: 120,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        width: 100,
        decoration: roundedDecoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                MaterialCommunityIcons.shield_check,
                color: yellowAmber,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                Trans.I.late("ابني الثقة"),
                style:
                    TextStyle(color: yellowAmber, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget editProfileButton(BuildContext context, Profile profile) {
    return InkWell(
      onTap: () => navigate(context, EditProfileScreen(profile)).then((value) {
        if (value != null) if (value)
          _asyncLoaderState.currentState.reloadState();
      }),
      child: Container(
        width: 100,
        decoration: roundedDecoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.edit,
                color: yellowAmber,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                Trans.I.late("تعديل"),
                style:
                    TextStyle(color: yellowAmber, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGrid(ProfileResponse response) {
    var list = getGrid(response);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: list.length,
          reverse: false,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemBuilder: (BuildContext context, int index) {
            return list[index];
          }),
    );
  }

  List<Widget> getGrid(ProfileResponse response) {
    var list = List<Widget>();

    list.add(getProfileItem("محفظتي", Entypo.wallet, () {
      navigate(context, WalletScreen(response));
    }));
    list.add(getProfileItem(
        Trans.I.late("المتابعين"), MaterialCommunityIcons.account_arrow_left,
        () {
      navigate(
          context,
          FollowScreen(
              response.followers.following, Trans.I.late("المتابعين")));
    }));
    list.add(getProfileItem(
        Trans.I.late("المتابعون"), MaterialCommunityIcons.account_arrow_right,
        () {
      navigate(
          context,
          FollowScreen(
              response.following.following, Trans.I.late("المتابعون")));
    }));
    list.add(getProfileItem(
        Trans.I.late("اعلاناتي"), MaterialCommunityIcons.bullhorn, () {
      navigate(context,
              MyAdsScreen(response.myAds.ads, Trans.I.late("اعلاناتي")))
          .then((value) {
        if (value != null) if (value)
          _asyncLoaderState.currentState.reloadState();
      });
    }));
    list.add(getProfileItem(
        Trans.I.late("شوهد مؤخرا"), MaterialCommunityIcons.eye, () {
      print(response.myAds.ads.length.toString());
      navigate(
          context,
          FollowingAdsScreen(response.getLastSeen.items,
              Trans.I.late("شوهد مؤخرا"), FollowingAdsScreenType.lastSeen));
    }));

    list.add(getProfileItem(
        Trans.I.late("الاعلانات المفضلة"), MaterialCommunityIcons.star, () {
      print(response.myAds.ads.length.toString());
      navigate(
        context,
        FollowingAdsScreen(response.wishList.wishlist,
            Trans.I.late("الاعلانات المفضلة"), FollowingAdsScreenType.my),
      );
    }));
    list.add(getProfileItem(Trans.I.late("اعلانات المتابعون"),
        MaterialCommunityIcons.account_details, () {
      navigate(
          context,
          FollowingAdsScreen(
              response.followingAds.ads,
              Trans.I.late("اعلانات المتابعون"),
              FollowingAdsScreenType.following));
    }));

    list.add(getProfileItem(
        Trans.I.late("ترقية الحساب"), MaterialCommunityIcons.crown, () {
      navigate(context, PromoteScreen());
    }));
    list.add(getProfileItem(
        Trans.I.late("اتصل بنا"), MaterialCommunityIcons.phone, () {
      navigate(context, ContactUsScreen(response.profile[0]));
    }));
    // list.add(getProfileItem(Trans.I.late("مشاركة حسابي"),
    //     MaterialCommunityIcons.share_variant, () {}));
    list.add(getProfileItem(
        Trans.I.late("مساعدة"), MaterialCommunityIcons.account_question_outline,
        () {
      navigate(
          context,
          new WebviewScaffold(
            url: "http://daafees.com/faq",
            appBar: new AppBar(
              title: const Text('FAQ'),
            ),
            withZoom: false,
            withJavascript: true,
            withLocalStorage: true,
            hidden: false,
          ));
    }));
    list.add(getProfileItem(
        Trans.I.late("الاعدادات"), MaterialCommunityIcons.settings_outline, () {
      navigate(context, SettingsScreen(response.profile[0])).then((value) {
        if (value != null) {
          if (value) _asyncLoaderState.currentState.reloadState();
        }
      });
    }));
    list.add(
        getProfileItem(Trans.I.late("تقاريري"), Icons.featured_play_list, () {
      navigate(context, VinReportsScreen());
    }));
    // list.add(getProfileItem(Trans.I.late("تنبيهاتي"),
    //     MaterialCommunityIcons.account_question_outline, () {}));
    return list;
  }

  Widget getProfileItem(String name, IconData icon, Function ontap) {
    return InkWell(
      onTap: ontap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
            side: new BorderSide(color: yellowAmber, width: 0.5),
            borderRadius: BorderRadius.circular(8.0)),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: yellowAmber,
                size: 39,
              ),
              Text(
                name,
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialCover extends StatelessWidget {
  Widget child;
  bool isActive;

  SocialCover({this.child, this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    color: isActive ? Colors.green : Colors.transparent,
                    width: 3)),
            child: child,
          ),
        ),
      ],
    );
  }
}
