class DefaultResponse {
  String aZSVR;
  int nEWID;

  DefaultResponse({this.aZSVR, this.nEWID});

  DefaultResponse.fromJson(Map<String, dynamic> json) {
    aZSVR = json['AZSVR'];
    nEWID = json['NEW_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AZSVR'] = this.aZSVR;
    data['NEW_ID'] = this.nEWID;
    return data;
  }
}
