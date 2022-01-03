class LoginResponse {
  String aZSVR;
  String eRRORMSG;
  String aCCESSTOKEN;

  LoginResponse({this.aZSVR, this.eRRORMSG, this.aCCESSTOKEN});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    aZSVR = json['AZSVR'];
    eRRORMSG = json['ERROR_MSG'];
    aCCESSTOKEN = json['ACCESS_TOKEN'];
  }

  LoginResponse.fromJsonSec(Map<String, dynamic> json) {
    aZSVR = json['AZSVR'];
    eRRORMSG = json['ERROR_MSG'];
    aCCESSTOKEN = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AZSVR'] = this.aZSVR;
    data['ERROR_MSG'] = this.eRRORMSG;
    data['ACCESS_TOKEN'] = this.aCCESSTOKEN;
    return data;
  }
}
