class ListReportsResponse {
  String aZSVR;
  List<Reports> reports;

  ListReportsResponse({this.aZSVR, this.reports});

  ListReportsResponse.fromJson(Map<String, dynamic> json) {
    aZSVR = json['AZSVR'];
    if (json['Reports'] != null) {
      reports = new List<Reports>();
      json['Reports'].forEach((v) {
        reports.add(new Reports.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AZSVR'] = this.aZSVR;
    if (this.reports != null) {
      data['Reports'] = this.reports.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reports {
  String id;
  String userId;
  String reportId;
  String vinNumber;
  String localReport;

  Reports(
      {this.id, this.userId, this.reportId, this.vinNumber, this.localReport});

  Reports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    reportId = json['report_id'];
    vinNumber = json['vin_number'];
    localReport = json['local_report'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['report_id'] = this.reportId;
    data['vin_number'] = this.vinNumber;
    data['local_report'] = this.localReport;
    return data;
  }
}
