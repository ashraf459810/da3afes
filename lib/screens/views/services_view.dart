import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:da3afes/models/MapResponse.dart';
import 'package:da3afes/models/UserTypeResponse.dart';
import 'package:da3afes/services/home_api.dart';
import 'package:da3afes/services/map_api.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../consts.dart';

class ServicesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ServicesScreenState();
  }
}

class ServicesScreenState extends State<ServicesScreen> {
  final Set<Polyline> _polyLines = {};
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  final Set<Marker> _markers = {};

  CameraPosition _currentPosition;
  double _pinPillPosition = -200;
  MapAds currentMapAd;
  Map<String, String> filters = {};
  var list = List<LatLng>();
  var ads = List<UserTypes>();
  ExpandableNotifier expandableNotifier;
  UserTypes selectAd = UserTypes.fromJson({
    "id": "8",
    "title": "kkmkmkmk",
    "cat_id": "1",
    "phone": "1551",
    "address": "jjnjknjknkjnk",
    "image": "..\/.\/ads_uploads\/default_pin.png",
    "gps_lat": "34.12",
    "gps_long": "33.12"
  });

  ExpandableController expandableController;

  @override
  Future<void> initState() {
    super.initState();
    _getCurrentLocation();
  }

  perms() async {
    var status = await Permission.location.status;
    if (status.isUndetermined || await Permission.location.isRestricted) {
      if (await Permission.location.request().isGranted) {
        _getCurrentLocation();
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      print("first");
      setState(() {
        _currentPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 12.4746);
        _getNewCurrentLocation();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getNewCurrentLocation() async {
    await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      print("second");

      setState(() {
        _currentPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 12.4746);
        mapController
            .animateCamera(CameraUpdate.newCameraPosition(_currentPosition));
      });
    }).catchError((e) {
      print(e);
    });
  }

  void getMarkers(String id) async {
    UserTypeResponse response;
    if (id != "") {
      response = await HomeApi.loadWakalas(filters);

      ads = response.userTypes;
      int i = 0;
      _markers.clear();
      list.clear();
      response.userTypes.forEach((element) {
        if (element.location.isNotEmpty) {
          var lll = element.location.split(",");

          var latlng =
              new LatLng(double.parse(lll.first), double.parse(lll.last));

          list.add(latlng);

          _markers.add(
            Marker(
                markerId: MarkerId(element.id),
                onTap: () {
                  setState(() {
                    selectAd = element;
                    _pinPillPosition = 50;
                  });
                },
                position: latlng,
                icon: BitmapDescriptor.defaultMarker),
          );
          i++;
        }
      });
      if (list.isNotEmpty) {
        list.add(_currentPosition.target);
        var bounds = boundsFromLatLngList(list);
        mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
        setState(() {});
      } else {
        mapController
            .animateCamera(CameraUpdate.newCameraPosition(_currentPosition));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    expandableController = ExpandableController(initialExpanded: false);

    expandableNotifier = ExpandableNotifier(
      controller: expandableController,
      child: ExpandablePanel(
//                            controller: expandableController,
        collapsed: ExpandableButton(
          child: RawMaterialButton(
            onPressed: null,
            child: new Icon(
              Icons.search,
              color: yellowAmber,
              size: 30.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: grey,
            padding: const EdgeInsets.all(5.0),
          ),
        ),
        expanded: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: children(),
        ),
      ),
    );
    return Scaffold(
//        appBar: AppBar(
//          title: Text("as"),
//        ),
      body: SafeArea(
        child: _currentPosition == null
            ? Container(
                child: Center(
                  child: Text(
                    'loading map..',
                    style: TextStyle(
                        fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                  ),
                ),
              )
            : Stack(alignment: AlignmentDirectional.topEnd, children: <Widget>[
                GoogleMap(
                    polylines: _polyLines,
                    markers: _markers,
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    trafficEnabled: true,
                    tiltGesturesEnabled: false,
                    // onCameraMove: (position) {

                    // },
                    padding: EdgeInsets.only(right: 70),
                    zoomControlsEnabled: false,
                    onTap: (asd) {
                      setState(() {
                        _pinPillPosition = -200;
                      });
                    },
                    initialCameraPosition: _currentPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      mapController = controller;
                      getMarkers("");
                      // if (selectAd.location.isNotEmpty) {
                      //   log("here frim fun");
                      //   var lll = selectAd.location.split(",");

                      //   var latlng = new LatLng(
                      //       double.parse(lll.first), double.parse(lll.last));
                      //   CameraUpdate u2 = CameraUpdate.newLatLngBounds(
                      //       LatLngBounds(
                      //           southwest: _currentPosition.target,
                      //           northeast: latlng),
                      //       50);
                      //   this.mapController.animateCamera(u2).then((void v) {
                      //     check(u2, this.mapController);
                      //   });
                      // }
                    }),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(child: expandableNotifier),
                ),
                buildInfoWindow(),
              ]),
      ),
    );
  }

  List<Widget> children() {
    var list = <Widget>[
      ExpandableButton(
        child: RawMaterialButton(
          onPressed: null,
          child: new Icon(
            MaterialCommunityIcons.close,
            color: yellowAmber,
            size: 30.0,
          ),
          shape: new CircleBorder(),
          elevation: 2.0,
          fillColor: grey,
          padding: const EdgeInsets.all(5.0),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
    ];
    var cats = mapUserTypes;
    cats.forEach((key, value) {
      value = value.replaceAll("محل", "");
      list.add(buildInkWell(mapUserTypesImgs[key], value, key));
      list.add(SizedBox(
        height: 5,
      ));
    });
    // services.forEach((key, value) {
    //   if (key != "1") {
    //     list.add(buildInkWell(serviceIcons[key], value, key));
    //     list.add(SizedBox(
    //       height: 5,
    //     ));
    //   }
    // });

    return list;
  }

  InkWell buildInkWell(String image, String label, String id) {
    return InkWell(
        onTap: () {
          if (filters["user_type"] == id) {
            expandableNotifier.controller.toggle();
            filters.clear();
            getMarkers(id);
            _polyLines.clear();
            setState(() {});
          } else {
            expandableNotifier.controller.toggle();
            filters.clear();
            filters["user_type"] = id;
            getMarkers(id);
            setState(() {});
          }
          print(filters.toString());
        },
        child: categoryButton(image, label, id));
  }

  Expanded buildInfo() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(selectAd.shopname ?? "", style: TextStyle(color: yellowAmber)),
            Text(selectAd.address ?? "",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text(userTypes[selectAd.userType] ?? "",
                style: TextStyle(fontSize: 12, color: Colors.grey))
          ], // end of Column Widgets
        ), // end of Column
      ), // end of Container
    );
  }

  Widget categoryButton(String icon, String title, String id) {
    print(filters["user_type"].toString() + "  " + id);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: <Shadow>[
                    Shadow(
                      color: Colors.grey,
                      offset: Offset(3, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
              width: 40.0,
              child: (filters["user_type"] == id)
                  ? Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: navy),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                          child: Icon(
                        Icons.clear,
                        size: 29,
                        color: Colors.black,
                      )))
                  : iconResizeCustom(icon, 40)),
          SizedBox(
            height: 5.0,
          )
        ],
      ),
    );
  }

  Widget buildInfoWindow() {
    return AnimatedPositioned(
      bottom: _pinPillPosition,
      right: 0,
      left: 0,
      duration: Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(30)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 20,
                  offset: Offset.zero,
                  color: Colors.grey.withOpacity(0.5),
                )
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildAvatar(),
              buildInfo(), //
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    callButton(selectAd.phone),
                    divider(5),
                    SizedBox(
                      height: 30.0,
                      width: 70.0,
                      child: GestureDetector(
                        onTap: () {
                          sendRequest();
                          if (selectAd.location.isNotEmpty) {
                            var lll = selectAd.location.split(",");

                            var latlng = new LatLng(double.parse(lll.first),
                                double.parse(lll.last));
                            CameraUpdate u2 = CameraUpdate.newLatLngBounds(
                                LatLngBounds(
                                    southwest: _currentPosition.target,
                                    northeast: latlng),
                                50);
                            log("here frim fun");

                            check(u2, mapController);
                          }
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
                                Trans.I.late("اتجاه"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.navigation,
                                size: 17,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    mapController.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    print(l1.toString());
    print(l2.toString());
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      check(u, c);
  }

  Widget _buildAvatar() {
    return Container(
      margin: EdgeInsets.all(10),
      width: 50,
      height: 50,
      child: ClipOval(
        child: Image.network(
          ppImgDir + selectAd.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  void sendRequest() async {
    _polyLines.clear();
    if (selectAd.location.isNotEmpty) {
      _markers.removeWhere((element) => element.markerId.value != selectAd.id);

      var lll = selectAd.location.split(",");

      var latlng = new LatLng(double.parse(lll.first), double.parse(lll.last));
      String route =
          await MapApi().getRouteCoordinates(_currentPosition.target, latlng);
      createRoute(route);
      setState(() {});
    }
//    _addMarker(destination, "KTHM Collage");
  }

  void createRoute(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_currentPosition.target.toString()),
        width: 4,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.red));
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
