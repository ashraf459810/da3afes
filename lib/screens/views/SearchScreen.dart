import 'package:da3afes/consts.dart';
import 'package:da3afes/models/HomeResponse.dart';
import 'package:da3afes/screens/ad_screen.dart';
import 'package:da3afes/services/ad_api.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:da3afes/widgets/my_ads_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Ads> _searchResult = [];
  TextEditingController controller = new TextEditingController();
  var dio = Dio();
  bool stop = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("البحث"),
      body: Container(
        child: Column(
          children: <Widget>[
            new Container(
                color: Theme.of(context).primaryColor,
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: _buildSearchBox())),
            new Expanded(
                child: _searchResult.length != 0 || controller.text.isNotEmpty
                    ? _buildSearchResults(_searchResult)
                    : _buildUsersList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<Ads> list) {
    return new ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return getAdsListItem(context, list[index]);
      },
    );
  }

  Widget _buildUsersList() {
    return FutureBuilder<SuggestionsLastSeen>(
      future: AdApi.getBoth(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data.suggestions.toJson().toString());
          return Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  (snapshot.data.lastSeen.aZSVR == "success")
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                Trans.I.late("الاخيرة"),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(color: Colors.black),
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: (snapshot
                                                .data.lastSeen.items.length >
                                            8)
                                        ? 8
                                        : snapshot.data.lastSeen.items.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            childAspectRatio: 1 / 1.5),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var item =
                                          snapshot.data.lastSeen.items[index];
                                      return getNetworkSquare(
                                          item.title,
                                          adImgDir +
                                              item.images.split(",").first, () {
                                        navigate(context, AdView(item, false));
                                      });
                                    }),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  (snapshot.data.suggestions.aZSVR == "success")
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                Trans.I.late("المقترحات"),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(color: Colors.black),
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: (snapshot
                                                .data.suggestions.ads.length >
                                            8)
                                        ? 8
                                        : snapshot.data.suggestions.ads.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            childAspectRatio: 1 / 1.3),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var item =
                                          snapshot.data.suggestions.ads[index];
                                      return getNetworkSquare(
                                          item.title,
                                          adImgDir +
                                              item.images.split(",").first, () {
                                        navigate(context, AdView(item, false));
                                      });
                                    }),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget getNetworkSquare(String name, String path, Function ontap) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: <Widget>[
          Card(
            elevation: 8,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: yellowAmber, width: 0.5),
                borderRadius: BorderRadius.circular(40.0)),
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Image.network(
                path,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Center(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Card(
        child: new ListTile(
          leading: new Icon(Icons.search),
          title: new TextField(
            controller: controller,
            decoration: new InputDecoration(
                hintText: 'البحث', border: InputBorder.none),
            onChanged: onSearchTextChanged,
          ),
          trailing: new IconButton(
            icon: new Icon(Icons.cancel),
            onPressed: () {
              controller.clear();
              onSearchTextChanged('');
            },
          ),
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    dio.clear();
    if (text.isNotEmpty) {
      stop = false;
      final response = await dio
          .get('http://daafees.com/main/api/api.php?cmd=SearchAds&title=$text');
      var ads = HomeReponse.fromJson(response.data).ads;

      _searchResult = ads;
//      print("new searchResult" + _searchResult.length.toString());
      if (!stop) setState(() {});
    } else {
      stop = true;
      setState(() {});
    }
  }
}
