import 'HomeResponse.dart';

class ProfileResponse {
  FollowingObject following;
  FollowingObject followers;
  int countUsers;
  int countAds;
  CountAdsViews countAdsViews;
  List<Profile> profile;
  GetLastSeen getLastSeen;
  WishList wishList;
  MyAds myAds;
  FollowingAds followingAds;

  ProfileResponse(
      {this.following,
      this.followers,
      this.countUsers,
      this.countAds,
      this.countAdsViews,
      this.profile,
      this.getLastSeen,
      this.wishList,
      this.myAds,
      this.followingAds});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    following = json['Following'] != null
        ? new FollowingObject.fromJson(json['Following'])
        : null;
    followers = json['Followers'] != null
        ? new FollowingObject.fromJson(json['Followers'])
        : null;
    countUsers = json['CountUsers'];
    countAds = json['CountAds'];
    countAdsViews = json['CountAdsViews'] != null
        ? new CountAdsViews.fromJson(json['CountAdsViews'])
        : null;
    if (json['Profile'] != null) {
      profile = new List<Profile>();
      json['Profile'].forEach((v) {
        profile.add(new Profile.fromJson(v));
      });
    }
    getLastSeen = json['GetLastSeen'] != null
        ? new GetLastSeen.fromJson(json['GetLastSeen'])
        : null;
    wishList = json['WishList'] != null
        ? new WishList.fromJson(json['WishList'])
        : null;
    myAds = json['MyAds'] != null ? new MyAds.fromJson(json['MyAds']) : null;
    followingAds = json['FollowingAds'] != null
        ? new FollowingAds.fromJson(json['FollowingAds'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.following != null) {
      data['Following'] = this.following.toJson();
    }
    if (this.followers != null) {
      data['Followers'] = this.followers.toJson();
    }
    data['CountUsers'] = this.countUsers;
    data['CountAds'] = this.countAds;
    if (this.countAdsViews != null) {
      data['CountAdsViews'] = this.countAdsViews.toJson();
    }
    if (this.getLastSeen != null) {
      data['GetLastSeen'] = this.getLastSeen.toJson();
    }
    if (this.wishList != null) {
      data['WishList'] = this.wishList.toJson();
    }
    if (this.myAds != null) {
      data['MyAds'] = this.myAds.toJson();
    }
    if (this.profile != null) {
      data['Profile'] = this.profile.map((v) => v.toJson()).toList();
    }
    if (this.followingAds != null) {
      data['FollowingAds'] = this.followingAds.toJson();
    }
    return data;
  }
}

class GetLastSeen {
  String aZSVR;
  List<Ads> items;

  GetLastSeen({this.aZSVR, this.items});

  GetLastSeen.fromJson(Map<String, dynamic> json) {
    aZSVR = json['AZSVR'];
    if (json['Items'] != null) {
      items = new List<Ads>();
      json['Items'].forEach((v) {
        if (v['AdObject'] != null) items.add(new Ads.fromJson(v['AdObject']));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AZSVR'] = this.aZSVR;
    if (this.items != null) {
      data['Items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WishList {
  String aZSVR;
  List<Ads> wishlist;

  WishList({this.aZSVR, this.wishlist});

  WishList.fromJson(Map<String, dynamic> json) {
    aZSVR = json['AZSVR'];
    if (json['Wishlist'] != null) {
      wishlist = new List<Ads>();
      json['Wishlist'].forEach((v) {
        if (v['AdObject'] != null)
          wishlist.add(new Ads.fromJson(v['AdObject']));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AZSVR'] = this.aZSVR;
    if (this.wishlist != null) {
      data['Wishlist'] = this.wishlist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyAds {
  List<Ads> ads;
  String aZSVR;

  MyAds({this.ads, this.aZSVR});

  MyAds.fromJson(Map<String, dynamic> json) {
    if (json['Ads'] != null) {
      ads = new List<Ads>();
      json['Ads'].forEach((v) {
        ads.add(new Ads.fromJson(v));
      });
    }
    aZSVR = json['AZSVR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ads != null) {
      data['Ads'] = this.ads.map((v) => v.toJson()).toList();
    }
    data['AZSVR'] = this.aZSVR;
    return data;
  }
}

class FollowingObject {
  List<Following> following;
  String aZSVR;

  FollowingObject({this.following, this.aZSVR});

  FollowingObject.fromJson(Map<String, dynamic> json) {
    if (json['Following'] != null) {
      following = new List<Following>();
      json['Following'].forEach((v) {
        following.add(new Following.fromJson(v));
      });
    } else if (json['Followers'] != null) {
      following = new List<Following>();
      json['Followers'].forEach((v) {
        following.add(new Following.fromJson(v));
      });
    }
    aZSVR = json['AZSVR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.following != null) {
      data['Following'] = this.following.map((v) => v.toJson()).toList();
    }
    data['AZSVR'] = this.aZSVR;
    return data;
  }
}

class Following {
  String id;
  String followerId;
  String followingId;
  String fullName;

  Following({this.id, this.followerId, this.followingId, this.fullName});

  Following.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    followerId = json['follower_id'];
    followingId = json['following_id'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['follower_id'] = this.followerId;
    data['following_id'] = this.followingId;
    data['full_name'] = this.fullName;
    return data;
  }
}

class Followers {
  List<Following> followers;
  String aZSVR;

  Followers({this.followers, this.aZSVR});

  Followers.fromJson(Map<String, dynamic> json) {
    if (json['Followers'] != null) {
      followers = new List<Following>();
      json['Followers'].forEach((v) {
        followers.add(new Following.fromJson(v));
      });
    }
    aZSVR = json['AZSVR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.followers != null) {
      data['Followers'] = this.followers.map((v) => v.toJson()).toList();
    }
    data['AZSVR'] = this.aZSVR;
    return data;
  }
}

class CountAdsViews {
  String aZSVR;
  String sumViews;

  CountAdsViews({this.aZSVR, this.sumViews});

  CountAdsViews.fromJson(Map<String, dynamic> json) {
    aZSVR = json['AZSVR'];
    sumViews = json['SumViews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AZSVR'] = this.aZSVR;
    data['SumViews'] = this.sumViews;
    return data;
  }
}

class Profile {
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
  String appleId;
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

  Profile(
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
      this.appleId,
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

  Profile.fromJson(Map<String, dynamic> json) {
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
    appleId = json['apple_id'];
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
    data['apple_id'] = this.appleId;
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

class FollowingAds {
  List<Ads> ads;
  String aZSVR;

  FollowingAds({this.ads, this.aZSVR});

  FollowingAds.fromJson(Map<String, dynamic> json) {
    if (json['Ads'] != null) {
      ads = new List<Ads>();
      json['Ads'].forEach((v) {
        ads.add(new Ads.fromJson(v));
      });
    }
    aZSVR = json['AZSVR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ads != null) {
      data['Ads'] = this.ads.map((v) => v.toJson()).toList();
    }
    data['AZSVR'] = this.aZSVR;
    return data;
  }
}
