import 'package:cached_network_image/cached_network_image.dart';
import 'package:da3afes/application.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/models/HomeResponse.dart';
import 'package:da3afes/respositries/user_repository.dart';
import 'package:da3afes/screens/ad_screen.dart';
import 'package:da3afes/screens/views/ad_editing_screen.dart';
import 'package:da3afes/services/ad_api.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyAdsScreen extends StatefulWidget {
  List<Ads> list;
  String title;

  MyAdsScreen(this.list, this.title);

  @override
  _MyAdsScreenState createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  bool dataUpdated = false;
  int _currentSelection = 1;
  Map<int, String> _children = {
    1: ('الفعالة'),
    0: ('الغير فعالة'),
    2: ('المميزة'),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, dataUpdated);
        return new Future.value(true);
      },
      child: Scaffold(
        appBar: defaultAppBar(widget.title),
        body: Container(
            decoration: appBackground,
            child: ListView(
              children: <Widget>[
                radioCustom({}, 1),
                buildListView(),
              ],
            )),
      ),
    );
  }

  Widget radioCustom(Map<String, dynamic> map, int group) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: yellowAmber),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  _currentSelection = 1;
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: _currentSelection == 1
                        ? BoxDecoration(
                            color: yellowAmber,
                            borderRadius: BorderRadius.circular(8),
                          )
                        : BoxDecoration(),
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            Trans.I.late(_children[1]),
                            style: TextStyle(
                                color: _currentSelection == 1
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  _currentSelection = 2;
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: _currentSelection == 2
                        ? BoxDecoration(
                            color: yellowAmber,
                            borderRadius: BorderRadius.circular(8),
                          )
                        : BoxDecoration(),
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            Trans.I.late(_children[2]),
                            style: TextStyle(
                                color: _currentSelection == 2
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  _currentSelection = 0;
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: _currentSelection == 0
                        ? BoxDecoration(
                            color: yellowAmber,
                            borderRadius: BorderRadius.circular(8),
                          )
                        : BoxDecoration(),
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            Trans.I.late(
                              _children[0],
                            ),
                            style: TextStyle(
                                color: _currentSelection == 0
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildListView() {
    var list = widget.list
        .where((element) => element.status == _currentSelection.toString());
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (mcontext, index) {
        return getAdsListItemEditable(mcontext, list.elementAt(index), index);
      },
    );
  }

  Widget getAdsListItemEditable(BuildContext context, Ads ads, int index) {
    final formatter = intl.NumberFormat.currency();
    var price = ads.price;

    return InkWell(
      onTap: () {
        navigate(context, AdView(ads, true));
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          elevation: 3,
          child: Container(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
//                mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              ads.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            divider(5),
                            Text((ads.condition ?? "") +
                                " - " +
                                (ads.catText ?? "")),
                            Text(ads.cityText ?? ""),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                callButton(ads.userPhone),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: SizedBox(),
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(
                                    (ads.price != null ? "$price دينار " : ""),
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: CachedNetworkImage(
                        imageUrl: (adImgDir + ads.images),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
                FutureBuilder<bool>(
                  future: checkMyAd(ads.id),
                  builder: (mcontext, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == true)
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  onTap: () =>
                                      navigate(context, AdEditScreen(ads)),
                                  child: Container(
                                    width: 90,
                                    decoration: roundedDecoration,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            style: TextStyle(
                                                color: yellowAmber,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 10,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => Share.share(
                                      "checkout my ad at daafees.com"),
                                  child: Container(
                                    width: 90,
                                    decoration: roundedDecoration,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.share,
                                            color: yellowAmber,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            Trans.I.late("نشر"),
                                            style: TextStyle(
                                                color: yellowAmber,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 10,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    // set up the button
                                    Widget okButton = FlatButton(
                                      child: Text("OK"),
                                      onPressed: () async {
                                        if (ads.status == "1") {
                                          var token =
                                              await UserRepository().getToken();
                                          var res = await AdApi.update({
                                            "id": ads.id,
                                            "status": "0",
                                            "token": token
                                          });
                                          if (res.aZSVR
                                                  .toString()
                                                  .toLowerCase() ==
                                              "success") {
                                            widget.list[index].status = "0";
                                            dataUpdated = true;
                                            setState(() {});
                                          }
                                        } else {
                                          var res = await AdApi.remove(ads.id);
                                          if (res.aZSVR
                                                  .toString()
                                                  .toLowerCase() ==
                                              "success") {
                                            widget.list.removeAt(index);
                                            dataUpdated = true;
                                            setState(() {});
                                          }
                                        }
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                    );
                                    // set up the AlertDialog
                                    AlertDialog alert = AlertDialog(
                                      title: Text(Trans.I
                                          .late("هل متاكد من حذف الاعلان ؟")),
                                      content: Text(""),
                                      actions: [
                                        okButton,
                                      ],
                                    );
                                    // show the dialog
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      },
                                    );
                                    // AwesomeDialog(
                                    //   context: context,
                                    //   dialogType: DialogType.INFO,
                                    //   animType: AnimType.BOTTOMSLIDE,
                                    //   title: Trans.I
                                    //       .late("هل متاكد من حذف الاعلان ؟"),
                                    //   desc: "",
                                    //   dismissOnBackKeyPress: true,
                                    //   btnOkColor: yellowAmber,
                                    //   dismissOnTouchOutside: true,
                                    //   btnOkOnPress: () async {
                                    //     if (ads.status == "1") {
                                    //       var token =
                                    //           await UserRepository().getToken();
                                    //       var res = await AdApi.update({
                                    //         "id": ads.id,
                                    //         "status": "0",
                                    //         "token": token
                                    //       });
                                    //       if (res.aZSVR
                                    //               .toString()
                                    //               .toLowerCase() ==
                                    //           "success") {
                                    //         widget.list[index].status = "0";
                                    //         dataUpdated = true;
                                    //         Navigator.of(context,
                                    //                 rootNavigator: true)
                                    //             .pop();
                                    //         setState(() {});
                                    //       }
                                    //     } else {
                                    //       var res = await AdApi.remove(ads.id);
                                    //       if (res.aZSVR
                                    //               .toString()
                                    //               .toLowerCase() ==
                                    //           "success") {
                                    //         widget.list.removeAt(index);
                                    //         dataUpdated = true;
                                    //         Navigator.of(context,
                                    //                 rootNavigator: true)
                                    //             .pop();
                                    //         setState(() {});
                                    //       }
                                    //     }
                                    //   },
                                    // )..show();
                                  },
                                  child: Container(
                                    width: 90,
                                    decoration: roundedDecoration,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.delete_outline,
                                            color: yellowAmber,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            Trans.I.late("حذف"),
                                            style: TextStyle(
                                                color: yellowAmber,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      else
                        return Container();
                    } else
                      return Container();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      getStatus(ads.dateAdded.split(" ").first),
                      Container(
                        color: Colors.black,
                        height: 19,
                        width: 1,
                      ),
                      getStatus(timeago.format(DateTime.parse(ads.dateAdded),
                          locale: ("ar"))),
                      Container(
                        color: Colors.black,
                        height: 19,
                        width: 1,
                      ),
                      getStatus("ينتهي بعد 95 يوم"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded getStatus(String st) => Expanded(
          child: Center(
              child: Text(
        st,
        style: TextStyle(fontSize: 13),
        textAlign: TextAlign.center,
      )));
}
