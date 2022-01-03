import 'dart:async';

import 'package:da3afes/consts.dart';
import 'package:da3afes/models/MapResponse.dart';
import 'package:da3afes/models/UserTypeResponse.dart';
import 'package:da3afes/services/map_api.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class DirectionsScreen extends StatefulWidget {
  UserTypes user;

  DirectionsScreen(this.user);

  @override
  State<StatefulWidget> createState() {
    return DirectionsScreenState();
  }
}

class DirectionsScreenState extends State<DirectionsScreen> {
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

  @override
  Future<void> initState() {
    super.initState();

    var lll = widget.user.location.split(",");
    print("aigoooo >>>>>> " + widget.user.location);
    var latlng = new LatLng(double.parse(lll.first), double.parse(lll.last));

    _markers.add(
      new Marker(
          markerId: MarkerId(widget.user.id),
          onTap: () {},
          position: latlng,
          icon: BitmapDescriptor.defaultMarker),
    );
    list.add(latlng);
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
            zoom: 14.4746);
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
            zoom: 11.4746);
        // mapController
        //     .animateCamera(CameraUpdate.newCameraPosition(_currentPosition));
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(Trans.I.late("اتجاهات")),
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
                    trafficEnabled: true,
                    tiltGesturesEnabled: false,
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
                      sendRequest();
                    }),
              ]),
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
    list.add(_currentPosition.target);
    var bounds = boundsFromLatLngList(list);

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    if (widget.user.location.isNotEmpty) {
      var lll = widget.user.location.split(",");

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
