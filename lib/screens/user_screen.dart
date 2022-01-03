import 'package:async_loader/async_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:da3afes/blocs/auth/auth_bloc.dart';
import 'package:da3afes/blocs/bloc.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/models/ProfileResponse.dart';
import 'package:da3afes/services/profile_api.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../application.dart';
import 'ad_screen.dart';

class UserScreen extends StatefulWidget {
  @override
  UserScreenState createState() => UserScreenState();
  final String id;

  UserScreen(this.id);
}

class UserScreenState extends State<UserScreen> {
  GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  final authBLoc = new AuthBloc();
  var refresh = false;

  @override
  void initState() {
    super.initState();
    eventBus.on<Refresh>().listen((event) {
      refresh = true;
      _asyncLoaderState.currentState.reloadState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildProfile();
  }

  Widget buildProfile() {
    int _index =
        0; // Make sure this is outside build(), otherwise every setState will chage the value back to 0
    if (refresh) {
      _asyncLoaderState.currentState.reloadState();
      refresh = false;
    }
    return Scaffold(
      appBar: defaultAppBar(""),
      body: Center(
        child: AsyncLoader(
            key: _asyncLoaderState,
            initState: () async => await ProfileApi.getUserProfile(widget.id),
            renderLoad: () => CircularProgressIndicator(),
            renderError: ([error]) =>
                new Text('Sorry, there was an error loading the User profile'),
            renderSuccess: ({data}) {
              var response = data as ProfileResponse;
              if (response != null)
                return Container(
                  height: double.infinity,
                  decoration: appBackground,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        buildProfileHeader(response.profile[0]),
                        buildCounters(response),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            Trans.I.late("كل الاعلانات"),
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: response.myAds.ads.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 1 / 1),
                              itemBuilder: (BuildContext context, int index) {
                                var item = response.myAds.ads[index];
                                return getNetworkSquarePriced(
                                    adImgDir + item.images.split(",").first,
                                    () {
                                  navigate(context, AdView(item, true));
                                }, item.price ?? "");
                              }),
                        ),
                      ],
                    ),
                  ),
                );
              else
                return Text("حصل خطاء ما");
            }),
      ),
    );
  }

  Column buildCounters(ProfileResponse response) {
    print("follwersss==>>" + response.followers.toJson().toString());
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
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60.0),
                        child: CachedNetworkImage(
                          //TEMPORARY PLACEHOLDER
                          imageUrl: (ppImgDir + response.image),
                          fit: BoxFit.fill,
                          width: 110,
                          height: 110,
//                      image: CacheImage(
//                        "https://www.attractivepartners.co.uk/wp-content/uploads/2017/06/profile.jpg",
//                      ),
                        ),
                      ),
                    ),
                  ),
                  divider(10),
                  Text(
                    response.fullName ?? "",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    userTypes[response.userType ?? "1"],
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
                      FutureBuilder<bool>(
                          future: checkFollowing(response.id),
                          builder: (context, snapshot) {
                            print("isfollowing" + snapshot.data.toString());
                            if (snapshot.hasData) {
                              print("isfollowingresult" +
                                  snapshot.data.toString());
                              if (snapshot.data)
                                return InkWell(
                                  onTap: () async {
                                    await ProfileApi.unFollowProfile(
                                        response.id);
                                    _asyncLoaderState.currentState
                                        .reloadState();
                                  },
                                  child: Container(
                                    width: 100,
                                    decoration: roundedDecoration,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        textDirection: TextDirection.rtl,
                                        children: <Widget>[
                                          Icon(
                                            MaterialCommunityIcons
                                                .account_plus_outline,
                                            color: yellowAmber,
                                          ),
                                          Text(
                                            Trans.I.late("الغاء المتابعة"),
                                            style: TextStyle(
                                                color: yellowAmber,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              else
                                return buildFollowButton(response.id);
                            }
                            return buildFollowButton(response.id);
                          }),
                      divider(10),
                      editProfileButton(context, response),
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

  Widget buildFollowButton(String id) {
    return InkWell(
      onTap: () async {
        await ProfileApi.followProfile(id);
        _asyncLoaderState.currentState.reloadState();
      },
      child: Container(
        width: 100,
        decoration: roundedDecoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Icon(
                MaterialCommunityIcons.account_plus_outline,
                color: yellowAmber,
              ),
              Text(
                Trans.I.late("تابع"),
                style: TextStyle(
                    color: yellowAmber,
                    fontSize: 17,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget editProfileButton(BuildContext context, Profile profile) {
    return InkWell(
      onTap: () => launchPhone(profile.phone ?? ""),
      child: Container(
        width: 100,
        decoration: roundedDecoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Icon(
                Icons.phone,
                color: yellowAmber,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                Trans.I.late("اتصال"),
                style:
                    TextStyle(color: yellowAmber, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
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
