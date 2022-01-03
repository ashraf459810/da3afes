class UserTypeResponse {
  List<UserTypes> userTypes;

  UserTypeResponse({this.userTypes});

  UserTypeResponse.fromJson(Map<String, dynamic> json) {
    if (json['UserTypes'] != null) {
      userTypes = new List<UserTypes>();
      json['UserTypes'].forEach((v) {
        userTypes.add(new UserTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userTypes != null) {
      data['UserTypes'] = this.userTypes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserTypes {
  String id;
  String email;
  String password;
  String fullName;
  String credit;
  String phone;
  String cityId;
  String address;
  String userType;
  String registerDate;
  String image;
  String active;
  String banner;
  String ogType;
  String ogId;
  String verifyMethod;
  String gender;
  String birthdate;
  String details;
  String language;
  String serviceType;
  String shopname;
  String wkOriginalCompany;
  String wkCustomerServiceNumber;
  String wkWebsite;
  String wkPhone2;
  String upgradePostspermonth;
  String upgradeExpire;
  String location;
  String accessToken;
  String lastSeen;

  UserTypes(
      {this.id,
      this.email,
      this.password,
      this.fullName,
      this.credit,
      this.phone,
      this.cityId,
      this.address,
      this.userType,
      this.registerDate,
      this.image,
      this.active,
      this.banner,
      this.ogType,
      this.ogId,
      this.verifyMethod,
      this.gender,
      this.birthdate,
      this.details,
      this.language,
      this.serviceType,
      this.shopname,
      this.wkOriginalCompany,
      this.wkCustomerServiceNumber,
      this.wkWebsite,
      this.wkPhone2,
      this.upgradePostspermonth,
      this.upgradeExpire,
      this.location,
      this.accessToken,
      this.lastSeen});

  UserTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    fullName = json['full_name'];
    credit = json['credit'];
    phone = json['phone'];
    cityId = json['city_id'];
    address = json['address'];
    userType = json['user_type'];
    registerDate = json['register_date'];
    image = json['image'];
    active = json['active'];
    banner = json['banner'];
    ogType = json['og_type'];
    ogId = json['og_id'];
    verifyMethod = json['verify_method'];
    gender = json['gender'];
    birthdate = json['birthdate'];
    details = json['details'];
    language = json['language'];
    serviceType = json['service_type'];
    shopname = json['shopname'];
    wkOriginalCompany = json['wk_original_company'];
    wkCustomerServiceNumber = json['wk_customer_service_number'];
    wkWebsite = json['wk_website'];
    wkPhone2 = json['wk_phone2'];
    upgradePostspermonth = json['upgrade_postspermonth'];
    upgradeExpire = json['upgrade_expire'];
    location = json['location'];
    accessToken = json['access_token'];
    lastSeen = json['last_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['full_name'] = this.fullName;
    data['credit'] = this.credit;
    data['phone'] = this.phone;
    data['city_id'] = this.cityId;
    data['address'] = this.address;
    data['user_type'] = this.userType;
    data['register_date'] = this.registerDate;
    data['image'] = this.image;
    data['active'] = this.active;
    data['banner'] = this.banner;
    data['og_type'] = this.ogType;
    data['og_id'] = this.ogId;
    data['verify_method'] = this.verifyMethod;
    data['gender'] = this.gender;
    data['birthdate'] = this.birthdate;
    data['details'] = this.details;
    data['language'] = this.language;
    data['service_type'] = this.serviceType;
    data['shopname'] = this.shopname;
    data['wk_original_company'] = this.wkOriginalCompany;
    data['wk_customer_service_number'] = this.wkCustomerServiceNumber;
    data['wk_website'] = this.wkWebsite;
    data['wk_phone2'] = this.wkPhone2;
    data['upgrade_postspermonth'] = this.upgradePostspermonth;
    data['upgrade_expire'] = this.upgradeExpire;
    data['location'] = this.location;
    data['access_token'] = this.accessToken;
    data['last_seen'] = this.lastSeen;
    return data;
  }
}
