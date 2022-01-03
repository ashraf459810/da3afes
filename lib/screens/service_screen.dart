import 'package:carousel_slider/carousel_slider.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/models/HomeResponse.dart';
import 'package:da3afes/models/UserTypeResponse.dart';
import 'package:da3afes/screens/directions_screen.dart';
import 'package:da3afes/screens/views/ads_screen.dart';
import 'package:da3afes/services/ad_api.dart';
import 'package:da3afes/services/wishlist_api.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ad_screen.dart';

class ServiceScreen extends StatefulWidget {
  UserTypes ad;
  bool isAvailable;

  ServiceScreen(this.ad);

  @override
  State<StatefulWidget> createState() {
    return ServiceScreenState(ad);
  }
}

class ServiceScreenState extends State<ServiceScreen> {
  UserTypes ad;

  int _current = 0;

  TextEditingController commentController = new TextEditingController();

  ServiceScreenState(this.ad);

  @override
  void initState() {
    super.initState();
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
    var images = [ad.image];
    return buildView(images);
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
                  ad.shopname,
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

          (widget.ad.userType == "2")
              ? wakala()
              : FutureBuilder<HomeReponse>(
                  future: AdApi.getUserAds(widget.ad.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.ads != null)
                        return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.ads.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
        Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: map<Widget>(images, (index, url) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4)),
                );
              }),
            ))
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
                  InkWell(
                    onTap: () => WishlistApi.add(ad.id),
                    child: CircleAvatar(
                      backgroundColor: yellowAmber,
                      radius: 17,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: Icon(
                          MaterialCommunityIcons.star,
                          color: yellowAmber,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () =>
                        Share.share('check out my website http://daafees.com'),
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: yellowAmber,
                      child: CircleAvatar(
                        child: Icon(
                          Icons.share,
                          color: yellowAmber,
                        ),
                        backgroundColor: Colors.white,
                        radius: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      ad.shopname,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22.0),
                    ),
                    iconResize("profile.png"),
                  ],
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
//            Expanded(
//              child: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Row(
//                  children: <Widget>[
//                    Text(
//                      ad.price != null ? ad.price :Trans.I.late( "غير معلوم"),
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold, fontSize: 22.0),
//                    )
//                  ],
//                ),
//              ),
//            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40.0,
                width: 110.0,
                child: GestureDetector(
                  onTap: () {
                    _launchPhone(ad.phone);
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
            ad.location.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 40.0,
                      width: 110.0,
                      child: GestureDetector(
                        onTap: () {
                          navigate(context, DirectionsScreen(ad));
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
                                Trans.I.late("الاتجاه"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.directions,
                                size: 24,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        )
      ],
    );
  }

  Widget wakala() {
    Map<IconData, String> map = {
      MaterialCommunityIcons.cogs: Trans.I.late("اكسسوارات"),
      FlutterIcons.buddhism_mco: Trans.I.late("قطع الغيار"),
      MaterialCommunityIcons.car: Trans.I.late("السيارات"),
    };

    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: map.length,
        reverse: false,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          var item = map.keys.elementAt(index);
          var name = map[map.keys.elementAt(index)];
          return getSquare(name, item, () {
            if (index == 2) {
              navigate(context, FilterAdsScreen(widget.ad.id, "1"));
            } else if (index == 1) {
              navigate(context, FilterAdsScreen(widget.ad.id, "11"));
            } else if (index == 0) {
              navigate(context, FilterAdsScreen(widget.ad.id, "12"));
            }
          });
        });
  }

  List<Widget> populateInfo(UserTypes ad) {
    var list = new List<Widget>();

    print(ad.id);
    if (ad.cityId != null) {
      if (provinces.containsKey(ad.cityId))
        list.add(buildInfoRow("المدينة", "" + provinces[ad.cityId]));
    }

    if (ad.userType != null) {
      list.add(buildInfoRow("نوع الحساب", "" + userTypes[ad.userType]));
    }

    if (ad.email != null) {
      list.add(buildInfoRow("ايميل", "" + ad.email));
    }

    if (ad.phone != null) {
      list.add(buildInfoRow("رقم التلفون", "" + ad.phone));
    }

    if (ad.address != null) {
      list.add(buildInfoRow("العنوان", "" + ad.address));
    }

    return list;
  }
}

Widget getSquare(String name, IconData icon, Function ontap) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: InkWell(
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
                size: 55,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> _launchPhone(String url) async {
  if (await canLaunch('tel:$url')) {
    await launch('tel:$url');
  } else {
    throw 'Could not launch $url';
  }
}
