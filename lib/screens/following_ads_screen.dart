import 'package:da3afes/consts.dart';
import 'package:da3afes/models/HomeResponse.dart';
import 'package:da3afes/widgets/my_ads_item.dart';
import 'package:flutter/material.dart';

class FollowingAdsScreen extends StatefulWidget {
  List<Ads> list;
  String title;
  FollowingAdsScreenType type;

  FollowingAdsScreen(this.list, this.title, this.type);

  @override
  _FollowingAdsScreenState createState() => _FollowingAdsScreenState();
}

enum FollowingAdsScreenType { my, lastSeen, following }

class _FollowingAdsScreenState extends State<FollowingAdsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(widget.title),
      body: Container(
          decoration: appBackground,
          child: ListView.builder(
            itemCount: widget.list.length,
            itemBuilder: (context, index) {
              if (widget.type == FollowingAdsScreenType.lastSeen) {
                var item = Column(
                  children: <Widget>[
                    Container(
                      color: Colors.grey,
                      height: 0.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text("قبل 1 ساعة"),
                          Container(
                            width: 5,
                          ),
                          Icon(
                            Icons.remove_red_eye,
                            color: yellowAmber,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
                return getAdsListItem(context, widget.list[index],
                    widget: item);
              } else
                return getAdsListItem(context, widget.list[index]);
            },
          )),
    );
  }
}
