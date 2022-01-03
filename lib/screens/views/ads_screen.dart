import 'package:da3afes/consts.dart';
import 'package:da3afes/models/HomeResponse.dart';
import 'package:da3afes/services/home_api.dart';
import 'package:da3afes/widgets/my_ads_item.dart';
import 'package:flutter/material.dart';

class FilterAdsScreen extends StatefulWidget {
  String user_id;
  String cat_id;

  FilterAdsScreen(this.user_id, this.cat_id);

  @override
  _FilterAdsScreenState createState() => _FilterAdsScreenState();
}

class _FilterAdsScreenState extends State<FilterAdsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(""),
      body: Container(
          decoration: appBackground,
          child: FutureBuilder<HomeReponse>(
              future: HomeApi.wakalaAd(widget.user_id, widget.cat_id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.ads.length,
                    itemBuilder: (context, index) {
                      return getAdsListItem(context, snapshot.data.ads[index]);
                    },
                  );
                } else
                  return Center(child: CircularProgressIndicator());
              })),
    );
  }
}
