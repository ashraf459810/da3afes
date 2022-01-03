import 'package:da3afes/consts.dart';
import 'package:da3afes/models/ListReportsResponse.dart';
import 'package:da3afes/models/ProfileResponse.dart';
import 'package:da3afes/screens/user_screen.dart';
import 'package:da3afes/services/vin_api.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:da3afes/vin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class VinReportsScreen extends StatefulWidget {
  @override
  _VinReportsScreenState createState() => _VinReportsScreenState();
}

class _VinReportsScreenState extends State<VinReportsScreen> {
  List<Following> _searchResult = [];
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(Trans.I.late("تقاريري")),
      body: Container(
        child: Column(
          children: <Widget>[
            // new Container(
            //     color: Theme.of(context).primaryColor,
            //     child: Directionality(
            //         textDirection: TextDirection.rtl,
            //         child: _buildSearchBox())),
            new Expanded(
                child: FutureBuilder<ListReportsResponse>(
                    future: VinApi.getUserReprts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.reports.length > 0)
                          return _buildUsersList(snapshot.data.reports);
                        else
                          return Container(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Icon(
                                    MaterialCommunityIcons.flask_outline,
                                    size: 40,
                                  ),
                                  Text(Trans.I.late("لا يوجد لديك تقارير")),
                                  RaisedButton(
                                    textColor: Colors.white,
                                    color: Colors.green,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child:
                                        Text(Trans.I.late("شراء تقرير سيارة")),
                                  ),
                                ],
                              ),
                            ),
                          );
                      }

                      return Center(child: CircularProgressIndicator());
                    })),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return new ListView.builder(
      itemCount: _searchResult.length,
      itemBuilder: (context, i) {
        return new Card(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: InkWell(
              onTap: () => navigate(context, UserScreen(_searchResult[i].id)),
              child: new ListTile(
                leading: new CircleAvatar(
                  child: Icon(
                    Icons.supervised_user_circle,
                    color: yellowAmber,
                  ),
                ),
                title: new Text(_searchResult[i].fullName),
              ),
            ),
          ),
          margin: const EdgeInsets.all(0.0),
        );
      },
    );
  }

  Widget _buildUsersList(List<Reports> reports) {
    return new ListView.builder(
      itemCount: reports.length + 1,
      itemBuilder: (context, index) {
        if (index != reports.length)
          return new Card(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: InkWell(
                onTap: () async {
                  var a = await VinApi.getReport(reports[index].id);
                  navigate(context, VehicleInfoScreen(a));
                },
                child: new ListTile(
                  leading: new CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.line_style,
                      color: yellowAmber,
                    ),
                  ),
                  title: new Text(reports[index].vinNumber),
                ),
              ),
            ),
            margin: const EdgeInsets.all(0.0),
          );
        else
          return RaisedButton(
            textColor: Colors.white,
            color: Colors.green,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(Trans.I.late("شراء تقرير سيارة")),
          );
      },
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
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    // widget.list.forEach((userDetail) {
    //   if (userDetail.fullName.toLowerCase().contains(text.toLowerCase())) {
    //     _searchResult.add(userDetail);
    //     print(userDetail.fullName.toLowerCase() + " " + text.toLowerCase());
    //   }
    // });

    setState(() {});
  }
}
