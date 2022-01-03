class MapResponse {
  List<MapAds> mapAds;
  String aZSVR;

  MapResponse({this.mapAds, this.aZSVR});

  MapResponse.fromJson(Map<String, dynamic> json) {
    if (json['MapAds'] != null) {
      mapAds = new List<MapAds>();
      json['MapAds'].forEach((v) {
        mapAds.add(new MapAds.fromJson(v));
      });
    }
    aZSVR = json['AZSVR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mapAds != null) {
      data['MapAds'] = this.mapAds.map((v) => v.toJson()).toList();
    }
    data['AZSVR'] = this.aZSVR;
    return data;
  }
}

class MapAds {
  String id;
  String title;
  String catId;
  String phone;
  String address;
  String image;
  String gpsLat;
  String gpsLong;

  MapAds(
      {this.id,
      this.title,
      this.catId,
      this.phone,
      this.address,
      this.image,
      this.gpsLat,
      this.gpsLong});

  MapAds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    catId = json['cat_id'];
    phone = json['phone'];
    address = json['address'];
    image = json['image'];
    gpsLat = json['gps_lat'];
    gpsLong = json['gps_long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['cat_id'] = this.catId;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['image'] = this.image;
    data['gps_lat'] = this.gpsLat;
    data['gps_long'] = this.gpsLong;
    return data;
  }
}
