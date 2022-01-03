import 'package:da3afes/consts.dart';
import 'package:da3afes/screens/SettingsScreen.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class PromoteScreen extends StatefulWidget {
  @override
  _PromoteScreenState createState() => _PromoteScreenState();
}

class _PromoteScreenState extends State<PromoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(Trans.I.late("ترقية الحساب")),
      body: Container(
        color: lightGrey,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: <Widget>[
              divider(20),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    line(),
                    buildListTile(),
                    Container(
                      color: Colors.grey,
                      height: 2,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                    ),
                    Container(
                      child: ListTile(
                        leading: Wrap(
                          direction: Axis.vertical,
                          children: <Widget>[
                            Container(
                              width: 150,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: buildText("الاعلانات الفعالة",
                                          color: Colors.grey)),
                                  buildTextBold("0")
                                ],
                              ),
                            ),
                            divider(5),
                            Container(
                              width: 150,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: buildText("المتبقية",
                                          color: Colors.grey)),
                                  buildTextBold("20")
                                ],
                              ),
                            ),
                          ],
                        ),
                        trailing: Material(
                          color: Colors.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: yellowAmber),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  MaterialCommunityIcons.crown,
                                  color: yellowAmber,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  Trans.I.late("ترقية الحساب"),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    line(),
                  ],
                ),
              ),
              divider(20),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    line(),
                    ListTile(
                      leading: buildTextBold("حسابي"),
                      enabled: false,
                      dense: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          buildText("نوع الحساب", color: darkGrey),
                          buildTextBold("عضو مجاني", color: darkGrey),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          buildText("الحد للاعلانات الفعالة", color: darkGrey),
                          buildTextBold("20 اعلان", color: darkGrey),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          buildText("الاعلانات الفعالة", color: darkGrey),
                          buildTextBold("0 اعلان", color: Colors.green),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          buildText("الاعلانات المدفوعة", color: darkGrey),
                          buildTextBold("0 اعلان", color: Colors.green),
                        ],
                      ),
                    ),
                    line(),
                  ],
                ),
              ),
              divider(20),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    line(),
                    ListTile(
                      leading: buildTextBold("الحد الاعلى للاعلانات في القسم"),
                      enabled: false,
                      dense: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          buildText(
                              "هذا هو الحد الاعلى المسموح للاعلان تحت كل قسم",
                              color: Colors.grey),
                        ],
                      ),
                    ),
                    divider(16),
                    buildListTileCustom(
                        "قسم السيارات",
                        "",
                        Icon(
                          MaterialCommunityIcons.car,
                          color: yellowAmber,
                        )),
                    buildListTileCustom(
                        "قسم القطع الغيار",
                        "",
                        Icon(
                          MaterialCommunityIcons.cogs,
                          color: yellowAmber,
                        )),
                    buildListTileCustom(
                        "قسم الاكسسوارات",
                        "",
                        Icon(
                          MaterialCommunityIcons.fire,
                          color: yellowAmber,
                        )),
                    line(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        leading: buildTextBold("الحد للاعلانات الفعالة"),
        trailing: buildTextBold(
          "20",
        ),
      ),
    );
  }

  Widget buildListTileCustom(String title, String sub, Icon icon) {
    return Column(
      children: <Widget>[
        line(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            leading: icon,
            title: buildTextBold(title),
            trailing: buildTextBold("20 اعلان", color: darkGrey),
          ),
        ),
        line(),
      ],
    );
  }

  Text buildTextBold(String text, {color = Colors.black}) {
    return Text(
      Trans.I.late(text),
      style: TextStyle(fontWeight: FontWeight.bold, color: color),
    );
  }

  Text buildText(String text, {color = Colors.black}) {
    return Text(
      Trans.I.late(text),
      style: TextStyle(color: color),
    );
  }
}
