class CreditOffers {
  String id;
  String amount;
  String text;
  String active;

  CreditOffers({this.id, this.amount, this.text, this.active});

  CreditOffers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    text = json['text'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['text'] = this.text;
    data['active'] = this.active;
    return data;
  }
}
