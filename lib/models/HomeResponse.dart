class HomeReponse {
  List<Ads> ads;
  String aZSVR;

  HomeReponse({this.ads, this.aZSVR});

  HomeReponse.fromJson(Map<String, dynamic> json) {
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

class Ads {
  String id;
  String userId;
  String title;
  String description;
  String dateAdded;
  String catId;
  String makeId;
  String modelId;
  String year;
  String kmCat;
  String isUsed;
  String transmissionType;
  String color;
  String fuelType;
  String images;
  String price = "";
  String cityId;
  String address;
  String status;
  String views;
  String details;
  String imagesFolder;
  String cityText;
  String catText;
  String condition;
  String makeText;
  String modelText;
  String kmText;
  String transmissionText;
  String colorText;
  String fuelText;
  String userFullName;
  String userPhone;
  String userProfilePicture;
  Comments comments;

  Ads(
      {this.id,
      this.userId,
      this.title,
      this.description,
      this.dateAdded,
      this.catId,
      this.makeId,
      this.modelId,
      this.year,
      this.kmCat,
      this.isUsed,
      this.transmissionType,
      this.color,
      this.fuelType,
      this.images,
      this.price,
      this.cityId,
      this.address,
      this.status,
      this.views,
      this.details,
      this.imagesFolder,
      this.cityText,
      this.catText,
      this.condition,
      this.makeText,
      this.modelText,
      this.kmText,
      this.transmissionText,
      this.colorText,
      this.fuelText,
      this.userFullName,
      this.userPhone,
      this.userProfilePicture,
      this.comments});

  Ads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    dateAdded = json['date_added'];
    catId = json['cat_id'];
    makeId = json['make_id'];
    modelId = json['model_id'];
    year = json['year'];
    kmCat = json['km_cat'];
    isUsed = json['is_used'];
    transmissionType = json['transmission_type'];
    color = json['color'];
    fuelType = json['fuel_type'];
    images = json['images'];
    price = json['price'];
    cityId = json['city_id'];
    address = json['address'];
    status = json['status'];
    views = json['views'];
    details = json['details'];
    imagesFolder = json['images_folder'];
    cityText = json['city_text'];
    catText = json['cat_text'];
    condition = json['condition'];
    makeText = json['make_text'];
    modelText = json['model_text'];
    kmText = json['km_text'];
    transmissionText = json['transmission_text'];
    colorText = json['color_text'];
    fuelText = json['fuel_text'];
    userFullName = json['user_full_name'];
    userPhone = json['user_phone'];
    userProfilePicture = json['user_profile_picture'];
    comments = json['comments'] != null
        ? new Comments.fromJson(json['comments'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['date_added'] = this.dateAdded;
    data['cat_id'] = this.catId;
    data['make_id'] = this.makeId;
    data['model_id'] = this.modelId;
    data['year'] = this.year;
    data['km_cat'] = this.kmCat;
    data['is_used'] = this.isUsed;
    data['transmission_type'] = this.transmissionType;
    data['color'] = this.color;
    data['fuel_type'] = this.fuelType;
    data['images'] = this.images;
    data['price'] = this.price;
    data['city_id'] = this.cityId;
    data['address'] = this.address;
    data['status'] = this.status;
    data['views'] = this.views;
    data['details'] = this.details;
    data['images_folder'] = this.imagesFolder;
    data['city_text'] = this.cityText;
    data['cat_text'] = this.catText;
    data['condition'] = this.condition;
    data['make_text'] = this.makeText;
    data['model_text'] = this.modelText;
    data['km_text'] = this.kmText;
    data['transmission_text'] = this.transmissionText;
    data['color_text'] = this.colorText;
    data['fuel_text'] = this.fuelText;
    data['user_full_name'] = this.userFullName;
    data['user_phone'] = this.userPhone;
    data['user_profile_picture'] = this.userProfilePicture;
    if (this.comments != null) {
      data['comments'] = this.comments.toJson();
    }
    return data;
  }
}

class Comments {
  int commentsCount;
  List<Comment> comments;

  Comments({this.commentsCount, this.comments});

  Comments.fromJson(Map<String, dynamic> json) {
    commentsCount = json['CommentsCount'];
    if (json['Comments'] != null) {
      comments = new List<Comment>();
      json['Comments'].forEach((v) {
        comments.add(new Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CommentsCount'] = this.commentsCount;
    if (this.comments != null) {
      data['Comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comment {
  String id;
  String adsId;
  String userId;
  String comment;
  String dateAdded;
  String userFullName;

  Comment(
      {this.id,
      this.adsId,
      this.userId,
      this.comment,
      this.dateAdded,
      this.userFullName});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adsId = json['ads_id'];
    userId = json['user_id'];
    comment = json['comment'];
    dateAdded = json['date_added'];
    userFullName = json['user_full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ads_id'] = this.adsId;
    data['user_id'] = this.userId;
    data['comment'] = this.comment;
    data['date_added'] = this.dateAdded;
    data['user_full_name'] = this.userFullName;
    return data;
  }
}
