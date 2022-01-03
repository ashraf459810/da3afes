import 'package:async_loader/async_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:da3afes/application.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/models/HomeResponse.dart';
import 'package:da3afes/respositries/user_repository.dart';
import 'package:da3afes/screens/ReportScreen.dart';
import 'package:da3afes/screens/user_screen.dart';
import 'package:da3afes/services/ad_api.dart';
import 'package:da3afes/services/home_api.dart';
import 'package:da3afes/services/wishlist_api.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class AdView extends StatefulWidget {
  Ads ad;
  bool isAvailable;

  AdView(this.ad, this.isAvailable);

  @override
  State<StatefulWidget> createState() {
    return AdViewState(ad);
  }
}

class AdViewState extends State<AdView> {
  GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  Ads ad;

  int _current = 0;
  bool isAvailable;

  TextEditingController commentController = new TextEditingController();

  AdViewState(this.ad);

  @override
  void initState() {
    super.initState();
    widget.isAvailable = false;
    this.isAvailable = widget.isAvailable;
    AdApi.seen(ad.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("اعلان"),
      body: getWidget(),
    );
  }

  Widget getWidget() {
    if (isAvailable) {
      var images = ad.images.split(",");
      return buildView(images);
    } else {
      return AsyncLoader(
        key: _asyncLoaderState,
        initState: () async => HomeApi.loadAd(widget.ad.id),
        renderLoad: () => Center(child: CircularProgressIndicator()),
        renderError: ([error]) =>
            new Text('Sorry, there was an error loading your joke'),
        renderSuccess: ({data}) {
          this.ad = (data as HomeReponse).ads[0];
          var images = ad.images.split(",");
          return buildView(images);
        },
      );
    }
  }

  SingleChildScrollView buildView(List<String> images) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          imagesSlider(images),
          namePriceInfo(),
          SizedBox(
            height: 1.0,
            child: Container(
              color: Colors.black,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ad.title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
//          getDiscreption(),
          Column(
            children: populateInfo(ad),
          ),

          SizedBox(
            height: 1.0,
            child: Container(
              color: Colors.black,
            ),
          ),
          FutureBuilder<HomeReponse>(
            future: AdApi.getUserSuggestions(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.ads != null)
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.ads.length > 8
                          ? 8
                          : snapshot.data.ads.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, childAspectRatio: 1 / 1),
                      itemBuilder: (BuildContext context, int index) {
                        var item = snapshot.data.ads[index];
                        return getNetworkSquare(
                            adImgDir + item.images.split(",").first, () {
                          navigate(context, AdView(item, true));
                        });
                      });
                else
                  return Container();
              } else {
                return Container();
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  Trans.I.late("التعليقات"),
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          buildCommentBox(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            // Let the ListView know how many items it needs to build.
            itemCount: ad.comments.commentsCount,
            // Provide a builder function. This is where the magic happens.
            // Convert each item into a widget based on the type of item it is.
            itemBuilder: (context, index) {
              final item = ad.comments.comments[index];

              return buildCommentTile(
                  item.userFullName, item.comment, item.dateAdded);
            },
          ),
        ],
      ),
    );
  }

  Column buildCommentTile(String username, String comment, String time) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "" + time,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "" + username,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: iconResize("profile.png"),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 60.0),
                    child: Text("" + comment),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 1,
          child: Container(
            color: Colors.grey,
          ),
        )
      ],
    );
  }

  Padding buildInfoRow(String title, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 5.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 30,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(text),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: 30,
              maxWidth: 140,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: yellowAmber),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    title,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget imagesSlider(List<String> images) {
    return Stack(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            disableCenter: true,
          ),
          items: images
              .map((item) => Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        "http://daafees.com/main/ads_uploads/" +
                            item.toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                    color: Colors.white,
                  ))
              .toList(),
        ),
      ],
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  Widget namePriceInfo() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FutureBuilder<bool>(
                      future: checkMyWishlist(ad.id),
                      builder: (context, snapshot) {
                        print("isfollowing" + snapshot.data.toString());
                        if (snapshot.hasData) {
                          print("isfollowingresult" + snapshot.data.toString());
                          if (snapshot.data)
                            return InkWell(
                              onTap: () async {
                                await WishlistApi.remove(ad.id);
                                _asyncLoaderState.currentState.reloadState();
                              },
                              child: Icon(
                                FontAwesome.star,
                                color: yellowAmber,
                                size: 35,
                              ),
                            );
                          else
                            return InkWell(
                              onTap: () async {
                                await WishlistApi.add(ad.id);
                                _asyncLoaderState.currentState.reloadState();
                              },
                              child: Icon(
                                FontAwesome.star_o,
                                color: yellowAmber,
                                size: 35,
                              ),
                            );
                        }
                        return Container();
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () =>
                        Share.share('check out my website http://daafees.com'),
                    child: Icon(
                      Entypo.share_alternative,
                      color: yellowAmber,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () => navigate(context, ReportScreen(ad.id)),
                    child: Icon(
                      MaterialCommunityIcons.alert_octagon,
                      color: yellowAmber,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    if (await UserRepository().hasToken()) {
                      navigate(context, UserScreen(ad.userId));
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        ad.userFullName ?? "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22.0),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      ad.userProfilePicture == null
                          ? iconResize("profile.png")
                          : SizedBox(
                              width: 35.0,
                              height: 35.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60.0),
                                    child: CachedNetworkImage(
                                      //TEMPORARY PLACEHOLDER
                                      imageUrl:
                                          (ppImgDir + ad.userProfilePicture),
                                      fit: BoxFit.fill,
                                      width: 32,
                                      height: 32,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      ad.price != null ? ad.price : Trans.I.late("غير معلوم"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22.0),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40.0,
                width: 110.0,
                child: GestureDetector(
                  onTap: () {
                    _launchPhone(ad.userPhone);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: yellowAmber,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          Trans.I.late("اتصال"),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.call,
                          size: 24,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  List<Widget> populateInfo(Ads ad) {
    var list = new List<Widget>();

    if (ad.cityText != null) {
      list.add(buildInfoRow("المدينة", "" + ad.cityText));
    }

    if (ad.condition != null) {
      list.add(buildInfoRow("الحالة", "" + ad.condition));
    }

    if (ad.year != null) {
      list.add(buildInfoRow("تاريخ الصنع", "" + ad.year));
    }

    if (ad.modelText != null) {
      list.add(buildInfoRow("موديل", "" + ad.modelText));
    }
    if (ad.price != null) {
      list.add(buildInfoRow("السعر", "" + ad.price));
    }
    if (ad.makeText != null) {
      list.add(buildInfoRow("الشركة", "" + ad.makeText));
    }
    if (ad.transmissionText != null) {
      list.add(buildInfoRow("نوع ناقل الحركة", "" + ad.transmissionText));
    }
    if (ad.colorText != null) {
      list.add(buildInfoRow("اللون", "" + ad.colorText));
    }
    if (ad.modelText != null) {
      list.add(buildInfoRow("موديل", "" + ad.modelText));
    }
    if (ad.catText != null) {
      list.add(buildInfoRow("النوع", "" + ad.catText));
    }
    if (ad.address != null) {
      list.add(buildInfoRow("العنوان", "" + ad.address));
    }
    if (ad.dateAdded != null) {
      list.add(buildInfoRow("تاريخ النشر", "" + ad.dateAdded));
    }

    if (ad.description != null) {
      list.add(buildInfoRow("تفاصيل اخرى", "" + ad.description));
    }

    return list;
  }

  Widget buildCommentBox() {
    if (hasToken)
      return Container(
        color: grey2,
        height: 50,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: commentController,
                    style: TextStyle(fontWeight: FontWeight.w500),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: commentInputDecoration(),
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                RaisedButton(
                  color: Color(0xFFC59E1E),
                  child: Text(
                    Trans.I.late("ارسل"),
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  onPressed: () async {
                    if (commentController.text.isNotEmpty) {
                      var result =
                          await AdApi.addComment(ad.id, commentController.text);
                      if (result.aZSVR.isSuccess()) {
                        commentController.clear();
                        Fluttertoast.showToast(
                            msg: Trans.I.late("تم ارسال التعليق"));
                        widget.isAvailable = false;
                        // widget.isAvailable = false;
                        _asyncLoaderState.currentState.reloadState();
                        setState(() {});
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    else
      return Container();
  }
}

Future<void> _launchPhone(String url) async {
  if (await canLaunch('tel:$url')) {
    await launch('tel:$url');
  } else {
    throw 'Could not launch $url';
  }
}
