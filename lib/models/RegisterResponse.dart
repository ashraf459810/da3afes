class RegisterResponse {
  String aZSVR;
  String eRRORMSG;
  String aCCESSTOKEN;

  RegisterResponse({this.aZSVR, this.eRRORMSG, this.aCCESSTOKEN});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    aZSVR = json['AZSVR'];
    eRRORMSG = json['ERROR_MSG'];
    aCCESSTOKEN = json['ACCESS_TOKEN'];
  }

  @override
  String toString() {
    return 'RegisterResponse{aZSVR: $aZSVR, eRRORMSG: $eRRORMSG, aCCESSTOKEN: $aCCESSTOKEN}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AZSVR'] = this.aZSVR;
    data['ERROR_MSG'] = this.eRRORMSG;
    data['ACCESS_TOKEN'] = this.aCCESSTOKEN;
    return data;
  }
}
