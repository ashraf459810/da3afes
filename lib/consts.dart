import 'dart:async';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:da3afes/application.dart';
import 'package:da3afes/screens/profile_screen.dart';
import 'package:da3afes/screens/views/SearchScreen.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart' as intl;
import 'package:url_launcher/url_launcher.dart';

import 'extensions.dart';

String toDo;

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
);

Future<void> handleGoogleSignIn(
    Future<void> func(TrustStatus status, String msg)) async {
  try {
    var result = await _googleSignIn.signIn();
    print(result.id);
    String token = result.id;
    func(TrustStatus.success, token);
  } catch (error) {
    print(error);
    func(TrustStatus.failure, "");
  }
}

Future<void> appleLogIn(
    Future<void> func(
        TrustStatus status, String msg, AppleIdCredential creds)) async {
  if (await AppleSignIn.isAvailable()) {
    //Check if Apple SignIn isn available for the device or not
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        print(result.credential.email.toString());
        print(result.credential.fullName.toString());
        func(TrustStatus.success, result.credential.user, result.credential);
        break; // l the required credentials
      case AuthorizationStatus.error:
        print("Sign in failed: ${result.error.localizedDescription}");
        func(TrustStatus.failure, "${result.error.localizedDescription}", null);
        break;
      case AuthorizationStatus.cancelled:
        print('User cancelled');
        func(TrustStatus.failure, "", null);
        break;
    }
  } else {
    print('Apple SignIn is not available for your device');
    func(TrustStatus.failure, "", null);
  }
}

enum TrustStatus {
  success,
  failure,
}

Future<void> handleFacebookSignIn(
    Future<void> func(TrustStatus status, String msg)) async {
  try {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print(result);
        func(TrustStatus.success, result.accessToken.userId);
        break;
      case FacebookLoginStatus.cancelledByUser:
        func(TrustStatus.failure, "");
        break;
      case FacebookLoginStatus.error:
        func(TrustStatus.failure, "");
        break;
    }
  } catch (error) {
    func(TrustStatus.failure, "");
    print(error);
  }
}

const primaryColor = Color(0xFFFFFFFF);
const yellowAmber = Color(0xFFDBB11F);
const grey = Color(0xFF404040);
const darkGrey = Color(0xFF686868);
const lightGrey = Color(0xFFEEEEEE);
const lightGrey2 = Color(0xFFCECECE);
const grey2 = Color(0xFF25373D);
const navy = Color(0xFF25373D);
const tokenKey = "ACCESS_TOKEN";
const package = "com.daafees.da3afes";
const adImgDir = "http://daafees.com/main/ads_upfvm loads/";
const ppImgDir = "https://daafees.com/main/uploads/users/pp/";

const Map<String, String> fuelTypes = {
  "1": "بنزين",
  "2": "كاز",
  "3": "هايبرد",
};

const Map<String, String> genders = {
  "0": "female",
  "1": "male",
};

const Map<String, String> userTypes = {
  "1": "مستخدم",
  "2": "وكالة",
  "3": "خدمات",
  "4": "محل قطع غيار",
  "5": "محل اكسسوارات",
  "6": "معرض سيارات",
  "7": "شركة شحن",
};

const Map<String, String> mapUserTypes = {
  "1": "غسيل سيارات",
  "12": "بنجرجي",
  "14": "ورش صيانة",
  "3": "تبديل دهن",
  "7": "شركة شحن",
  "4": "محل قطع غيار",
  "5": "محل اكسسوارات",
  "2": "وكالة",
  "114": "ايجارات",
  "15": "الخدمات",
};

const Map<String, String> mapUserTypesImgs = {
  "2": "mapicons/retail.png",
  "4": "mapicons/parts.png",
  "5": "mapicons/accessorie.png",
  "7": "mapicons/shipping.png",
  "1": "mapicons/carwash.png",
  "12": "mapicons/puncture.png",
  "3": "mapicons/oil.png",
  "14": "mapicons/services.png",
  "15": "mapicons/allservices.png",
  "114": "mapicons/rent.png",
};

const Map<String, String> numberPlateType = {
  "خصوصي": "خصوصي",
  "حمل": "حمل",
  "نقل": "نقل",
};
const Map<String, String> serviceTypes = {
  "1": "غسيل سيارات",
  "2": "بنجرجي",
  "3": "تبديل دهن",
  "4": "ورش صيانة",
};
const Map<String, IconData> serviceIcons = {
  "1": MaterialCommunityIcons.car_wash,
  "2": MaterialCommunityIcons.car_multiple,
  "3": MaterialCommunityIcons.oil,
  "4": MaterialCommunityIcons.progress_wrench,
};

const Map<String, String> serviceImages = {
  "1": "services/s1.png",
  "2": "services/s2.png",
  "3": "services/s4.png",
  "4": "services/s3.png",
};

const Map<String, String> spareParts = {
  "1": "محلات قطع الغيار",
  "2": "عرض كل قطع الغيار",
};

const Map<String, String> is_usedMap = {
  "0": "جديد",
  "1": "مستعمل",
};
const Map<String, IconData> sparePartsIcons = {
  "1": MaterialCommunityIcons.grid_large,
  "2": MaterialCommunityIcons.cogs,
};

const Map<String, String> payment_methods = {
  "zain_cash": "zaincash_card.png",
};

const Map<String, String> accessories = {
  "1": "محلات الاكسسوارات",
  "2": "عرض كل الاكسسوارات",
};
const Map<String, IconData> accessoriesIcons = {
  "1": MaterialCommunityIcons.grid_large,
  "2": MaterialCommunityIcons.buddhism,
};

const Map<String, String> categories = {
  "1": "سيارات",
  "2": "مستعملة",
  "3": "جديد",
  "14": "معارض",
  "4": "ايجارات",
  "6": "تكسي",
  "15": "الخدمات",
  "5": "دراجات",
  "7": "أرقام سيارات",
  "8": "معدات ثقيلة",
  "9": "سيارات أخرى",
  "10": "قوارب وجتسكي",
};

const Map<String, String> categoriesImages = {
//  "1": "سيارات",
  "2": "categories/c2.png",
  "3": "categories/c2.png",
  "14": "categories/c4.png",
  "4": "categories/c5.png",
  "6": "categories/c6.png",
  "15": "categories/c7.png",
  "5": "categories/c8.png",
  "7": "categories/c9.png",
  "8": "categories/c10.png",
  "9": "categories/c11.png",
  "10": "categories/c12.png",
};

const Map<String, String> years = {
  "2000": "2000",
  "2001": "2001",
  "2002": "2002",
  "2003": "2003",
  "2004": "2004",
  "2005": "2005",
  "2006": "2006",
  "2007": "2007",
  "2008": "2008",
  "2009": "2009",
  "2010": "2010",
  "2011": "2011",
  "2012": "2012",
  "2013": "2013",
  "2014": "2014",
  "2015": "2015",
  "2016": "2016",
  "2017": "2017",
  "2018": "2018",
  "2019": "2019",
  "2020": "2020",
};
const Map<String, String> postTypes = {
  "1": "سيارات",
  // "2": "مستعملة",
  // "3": "جديد",
  // "4": "ايجارات",
  "11": "قطع غيار",
  "12": "اكسسوارات",
  "5": "دراجات",
  // "6": "تكسي",
  "7": "أرقام سيارات",
  "8": "معدات ثقيلة",
  "10": "قوارب وجتسكي",
  "9": "سيارات أخرى",
};

const Map<String, IconData> categoriesIcons = {
  "1": MaterialCommunityIcons.car,
  "2": MaterialCommunityIcons.car_back,
  "3": MaterialCommunityIcons.car_electric,
  "5": MaterialCommunityIcons.motorbike,
  "4": MaterialCommunityIcons.car_key,
  "7": MaterialCommunityIcons.counter,
  "8": MaterialCommunityIcons.dump_truck,
  "9": MaterialCommunityIcons.van_utility,
  "6": MaterialCommunityIcons.taxi,
  "10": MaterialCommunityIcons.ferry,
  "15": MaterialCommunityIcons.cogs,
  "11": MaterialCommunityIcons.cogs,
  "12": MaterialCommunityIcons.buddhism,
  "14": MaterialCommunityIcons.store,
};

const Map<String, String> transmissionTypes = {
  "1": "اوتوماتيك",
  "2": "عادي",
  "3": "اخرى",
};
const Map<String, String> kmCats = {
  "1": "0-19999",
  "2": "20000-49999",
  "3": "50000-99999",
  "4": "100000-149999",
  "5": "150000-199999",
  "6": "200000+",
};

const Map<String, String> carModels = {
  "1": "Versa",
  "2": "Range Rover Sport",
  "3": "Evora",
  "4": "Land Cruiser",
  "5": "Altima",
  "6": "Corolla",
  "7": "Xterra",
  "8": "Panamera",
  "9": "Verona",
  "10": "Camry",
};

const Map<String, String> colors = {
  "1": "أبيض",
  "2": "أسود",
  "3": "أحمر",
  "4": "أخضر",
  "5": "أزرق",
  "6": "أصفر",
  "7": "برتقالي",
  "8": "بنفسجي",
  "9": "خمري",
  "10": "وردي",
  "11": "فضي",
  "12": "ذهبي",
  "13": "لون آخر",
};

const Map<String, String> provinces = {
  "1": "أربيل",
  "2": "بغداد",
  "3": "البصرة",
  "4": "الأنبار",
  "5": "بابل",
  "6": "حلبجة",
  "7": "دهوك",
  "8": "الديوانية",
  "9": "ديالي",
  "10": "ذي قار",
  "11": "السليمانية",
  "12": "كركوك",
  "13": "كربلاء",
  "14": "المثنى",
  "15": "ميسان",
  "16": "النجف",
  "17": "نينوى",
  "18": "واسط",
};

Map<String, String> getMap(String mapname) {
  if (mapname == "cat_id") {
    return postTypes;
  } else if (mapname == "is_used") {
    return is_usedMap;
  } else if (mapname == "make_id") {
    return newmakes();
  } else if (mapname == "user_type")
    return userTypes;
  else if (mapname == "service_type")
    return serviceTypes;
  else if (mapname == "all") return {"0": "الكل"};
  return {};
}

Widget futureWishlistWidget(String id) {
  return FutureBuilder<bool>(
    future: checkMyWishlist(id),
    builder: (context, snapshot) {
//      print("wihslist=>" + snapshot.data.toString());
      if (snapshot.hasData) {
        return wishListStar(snapshot.data);
      } else
        return Container();
    },
  );
}

Widget getNetworkSquarePriced(String path, Function ontap, String price) {
  return InkWell(
    onTap: ontap,
    child: Column(
      children: <Widget>[
        Card(
          elevation: 8,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
              side: new BorderSide(color: yellowAmber, width: 0.5),
              borderRadius: BorderRadius.circular(8.0)),
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Stack(
              children: <Widget>[
                Image.network(
                  path,
                  fit: BoxFit.fitWidth,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(price),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget getNetworkSquare(String path, Function ontap) {
  return InkWell(
    onTap: ontap,
    child: Column(
      children: <Widget>[
        Card(
          elevation: 8,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
              side: new BorderSide(color: yellowAmber, width: 0.5),
              borderRadius: BorderRadius.circular(8.0)),
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Image.network(
              path,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget wishListStar(bool isAdded) {
  return InkWell(
    onTap: () {},
    child: (isAdded)
        ? Icon(
            Icons.star,
            size: 35,
            color: yellowAmber,
          )
        : Icon(
            Icons.star_border,
            size: 35,
            color: yellowAmber,
          ),
  );
}

extension mapClean on Map<String, dynamic> {
  String getKey(String cc) =>
      this.keys.firstWhere((k) => this[k] == cc, orElse: () => null);

  Map<String, dynamic> clean() {
    this.removeWhere((key, value) => value == null
        ? true
        : value.toString().isEmpty || value.toString() == " "
            ? true
            : false);
    return this;
  }
}

extension asd on DropdownMenuItem {
  string() {
    print(this.key);
  }
}

extension mapExtension on Map<String, String> {
  String getKey(String cc) =>
      this.keys.firstWhere((k) => this[k] == cc, orElse: () => null);

  List<DropdownMenuItem<String>> getFields() {
    print(provinces.toString());
    return this.keys.map((e) {
      var x = getDropDownItem(e, this[e]);

      return x;
    }).toList();
  }

  List<DropdownMenuItem<String>> getCenteredFields() =>
      this.keys.map((e) => getCenteredDropDownItem(e, this[e])).toList();
}

extension stringExtension on String {
  int toInt() {
    if (this == null) {
      return null;
    } else {
      if (int.parse(this) != null) {
        return int.parse(this);
      } else {
        return null;
      }
    }
  }

  bool isSuccess() => this == "SUCCESS" || this == "success" ? true : false;

  double toDouble() => double.parse(this) ?? 0.0;
}

var appLogo = SizedBox(
  height: 100.0,
  child: Image.asset("images/d_logo.png"),
);
const appBackground = BoxDecoration(
  color: Colors.white,
  image: DecorationImage(
      image: AssetImage("images/background.png"),
      fit: BoxFit.fitWidth,
      alignment: Alignment.bottomCenter),
);

final roundedDecoration = BoxDecoration(
  border: Border.all(color: yellowAmber),
  borderRadius: BorderRadius.circular(8),
);

Widget getFuelSpinner(Map<String, dynamic> map, String value) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonFormField<String>(
        isDense: true,
        value: value,
        validator: FormBuilderValidators.required(),
        decoration: commonInputDecoration(
          MaterialCommunityIcons.gas_station,
          "",
        ),
        items: fuelTypes.getFields(),
        onChanged: (value) {
          map["fuel_type"] = value;
          print(map.toString());
        },
        hint: Text(
          "نوع الوقود",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}

Widget getYearsDropDown(Map<String, dynamic> map, String value) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonFormField<String>(
        isDense: true,
        value: value,
        decoration: commonInputDecoration(
          MaterialCommunityIcons.bullseye_arrow,
          "",
        ),
        items: years.getFields(),
        onChanged: (value) {
          map["year"] = value;
          print(map.toString());
        },
        hint: Text(
          "موديل السيارة",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}

Widget getCarModel(Map<String, dynamic> map, String value) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonFormField<String>(
        isDense: true,
        value: value,
        decoration: commonInputDecoration(
          MaterialCommunityIcons.car,
          "",
        ),
        items: makes.getFields(),
        onChanged: (value) {
          print(map.toString());
        },
        hint: Text(
          "نوع السيارة",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}

Future<Map<String, String>> getMakes(String id) async {
  Map<String, String> map = {};

  print("triggers");
  await Future.forEach(kakma.entries, (element) {
    MapEntry<String, String> item = element;
    if (item.value == id) {
      print("triggers");

      var model_name = moodel[item.key];
      map[item.key] = model_name;
    }
  });
  print("result is" + map.toString());
  return map;
//  await kakma.forEach((key, value)
//  {
//    if (value == "id") {
//      var model_id = makes[key];
//      map[model_id] = key;
//    }
//  });
}

Widget getCarName(Map<String, dynamic> map, String value) {
  print("getCarname is called");
  var id = map["make_id"] ?? "";
  return FutureBuilder<Map<String, String>>(
      future: getMakes(id),
      builder: (context, snapshot) {
        print("hasdata " + snapshot.hasData.toString());
        print(snapshot.data.toString());
        if (snapshot.hasData)
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: DropdownButtonFormField<String>(
                isDense: false,
                decoration: commonInputDecoration(
                  MaterialCommunityIcons.car,
                  "",
                ),
                items: snapshot.data.getFields(),
                onChanged: (value) {
                  map["model_id"] = value;
                  print(map.toString());
                },
                hint: Text(
                  "اختر الفئة",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        else
          return CircularProgressIndicator();
      });
}

Widget getAddressField(Map<String, dynamic> map, String text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: <Widget>[
        SizedBox(
            width: double.infinity,
            child: Text(
              "العنوان",
              textAlign: TextAlign.end,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            )),
        FormBuilderTextField(
          initialValue: text ?? null,
          onChanged: (text) {
            map["address"] = text;
            print(map.toString());
          },
          attribute: "address",
          textAlign: TextAlign.right,
          decoration: textFieldDecor,
        ),
      ],
    ),
  );
}

Widget getAdTitleField(Map<String, dynamic> map, String text, String postType) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: <Widget>[
        FormBuilderTextField(
          initialValue: text ?? null,
          maxLines: 1,
          onChanged: (text) {
            map["title"] = text;
            print(map.toString());
          },
          attribute: "title",
          textAlign: TextAlign.right,
          decoration: textFieldDecorHinted("اسم $postType"),
        ),
      ],
    ),
  );
}

Widget getNumberPlateField(Map<String, dynamic> map, String text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: <Widget>[
        SizedBox(
            width: double.infinity,
            child: Text(
              "الرقم",
              textAlign: TextAlign.end,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            )),
        FormBuilderTextField(
          initialValue: text ?? null,
          maxLines: 1,
          onChanged: (text) {
            map["title"] = text;
            print(map.toString());
          },
          attribute: "title",
          textAlign: TextAlign.right,
          decoration: textFieldDecor,
        ),
      ],
    ),
  );
}

const _locale = 'en';

String _formatNumber(String string) {
  final format = intl.NumberFormat.decimalPattern(_locale);
  return format.format(int.parse(string));
}

Widget getAdPriceField(Map<String, dynamic> map, String text) {
  final _controller = TextEditingController(text: text ?? null);
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: <Widget>[
        // SizedBox(
        //     width: double.infinity,
        //     child: Text(
        //       "السعر",
        //       textAlign: TextAlign.end,
        //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
        //     )),
        FormBuilderTextField(
          controller: _controller,
          keyboardType:
              TextInputType.numberWithOptions(signed: true, decimal: false),
          // initialValue: text ?? null,
          maxLines: 1,
          inputFormatters: [
            // BlacklistingTextInputFormatter.singleLineFormatter,
          ],
          onChanged: (text) {
            map["price"] = text.toString().toInt();
            print(map.toString());
          },
          attribute: "price",
          textAlign: TextAlign.right,
          decoration: textFieldDecor.copyWith(
              hintText: Trans.I.late("السعر"),
              prefixIcon: Icon(
                MaterialCommunityIcons.cash,
                color: yellowAmber,
              )),
        ),
      ],
    ),
  );
}

Widget getAdDescription(Map<String, dynamic> map, String text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: <Widget>[
        // SizedBox(
        //     width: double.infinity,
        //     child: Text(
        //       "وصف الاعلان",
        //       textAlign: TextAlign.end,
        //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
        //     )),
        FormBuilderTextField(
          initialValue: text ?? null,
          maxLines: 1,
          onChanged: (text) {
            map["description"] = text;
            print(map.toString());
          },
          attribute: "description",
          textAlign: TextAlign.right,
          decoration: textFieldDecorHinted(Trans.I.late("وصف الاعلان")),
        ),
      ],
    ),
  );
}

Widget getTransmissionSpinner(Map<String, dynamic> map, String value) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonFormField<String>(
        isDense: true,
        value: value,
        decoration: commonInputDecoration(MaterialCommunityIcons.cogs, ""),
        items: transmissionTypes.getFields(),
        onChanged: (value) {
          map["transmission_type"] = value;
          print(map.toString());
        },
        hint: Text(
          "نوع ناقل الحركة",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}

Widget getDropDown(
    {Map<String, dynamic> map,
    String value,
    String key,
    String hint,
    Map<String, String> items,
    IconData icon}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonFormField<String>(
        isDense: true,
        value: value ?? null,
        decoration: commonInputDecoration(icon, ""),
        items: items.getFields(),
        onChanged: (value) {
          map[key] = value;
          print(map.toString());
        },
        hint: Text(
          hint,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}

Future<bool> navigate(BuildContext context, Widget widget) async {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

SizedBox iconResize(String path) {
  return SizedBox(
    width: 40.0,
    height: 40.0,
    child: Image.asset("images/" + path),
  );
}

Widget iconTransform(String path, double scale) {
  return Transform.scale(scale: scale, child: Image.asset("images/" + path));
}

Future<void> launchPhone(String url) async {
  if (await canLaunch('tel:$url')) {
    await launch('tel:$url');
  } else {
    throw 'Could not launch $url';
  }
}

SizedBox callButton(String phone) {
  return SizedBox(
    height: 30.0,
    width: 70.0,
    child: GestureDetector(
      onTap: () {
        launchPhone(phone);
      },
      child: Container(
        decoration: BoxDecoration(
          color: yellowAmber,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "اتصال",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.call,
              size: 17,
              color: Colors.white,
            ),
          ],
        ),
      ),
    ),
  );
}

SizedBox iconResizeLarge(String path) {
  return SizedBox(
    width: 50.0,
    height: 50.0,
    child: Image.asset("images/" + path),
  );
}

SizedBox iconResizeCustom(String path, double size) {
  return SizedBox(
    width: size,
    height: size,
    child: Image.asset("images/" + path),
  );
}

SizedBox iconSmallResize(String path) {
  return SizedBox(
    width: 30.0,
    height: 30.0,
    child: Image.asset("images/" + path),
  );
}

AppBar defaultAppBar(String text) {
  return new AppBar(
    backgroundColor: primaryColor,
    title: Text(
      text,
      style: Theme.of(singletonContext).textTheme.headline6,
    ),
    centerTitle: true,
  );
}

AppBar appBar(BuildContext context) {
  return AppBar(
    backgroundColor: primaryColor,
    elevation: 0,
    leading: Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () => navigate(context, SearchScreen()),
        child: Material(
          elevation: 5.0,
          shape: CircleBorder(),
          child: new Icon(
            Icons.search,
            size: 30,
          ),
        ),
      ),
    ),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(pageBuilder: (_, __, ___) => ProfileScreen()),
            );
          },
          child: Material(
            child: iconResize("profile.png"),
            elevation: 5,
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
          ),
        ),
      )
    ],
    centerTitle: true,
    title: SizedBox(height: 60.0, child: Image.asset("images/d_logo.png")),
  );
}

const yellowBorder = OutlineInputBorder(
  borderSide: BorderSide(color: yellowAmber, width: 2.0),
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
);

const yellowSolidBorder = OutlineInputBorder(
  borderSide: BorderSide(color: yellowAmber, width: 1.0),
  borderRadius: BorderRadius.all(Radius.circular(0.0)),
);

const greyBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.grey, width: 2.0),
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
);

const roundedBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.grey, width: 0.0),
  borderRadius: BorderRadius.all(Radius.circular(5.0)),
);
const textFieldDecor = InputDecoration(
  hintText: "",
  filled: true,
  fillColor: Colors.white,
  enabledBorder: yellowBorder,
  focusedBorder: yellowBorder,
);

InputDecoration textFieldDecorHinted(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    enabledBorder: yellowBorder,
    focusedBorder: yellowBorder,
  );
}

DropdownMenuItem<String> getDropDownItem(String value, String label) {
  return DropdownMenuItem<String>(
    value: value,
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: new TextStyle(
            fontSize: 13.0,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    ),
  );
}

DropdownMenuItem<String> getCenteredDropDownItem(String value, String label) {
  return DropdownMenuItem<String>(
    value: value,
    child: Center(
      child: Text(
        label,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Column buildPhoneField() {
  return Column(
    children: <Widget>[
      SizedBox(
          width: double.infinity,
          child: Text(
            "رقم الهاتف",
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          )),
      divider(5),
      Container(
        height: 50,
        child: FormBuilderTextField(
          maxLines: 1,
          keyboardType:
              TextInputType.numberWithOptions(signed: true, decimal: false),
          attribute: "phone",
          textAlign: TextAlign.right,
          decoration: textFieldDecor,
        ),
      ),
    ],
  );
}

Column buildFullNameField() {
  return Column(
    children: <Widget>[
      SizedBox(
          width: double.infinity,
          child: Text(
            "الاسم الكامل",
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          )),
      divider(5),
      Container(
        height: 50,
        child: FormBuilderTextField(
          maxLines: 1,
          attribute: "full_name",
          textAlign: TextAlign.right,
          decoration: textFieldDecor,
        ),
      ),
    ],
  );
}

Column buildShopNameField(String title) {
  return Column(
    children: <Widget>[
      SizedBox(
          width: double.infinity,
          child: Text(
            "اسم $title",
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          )),
      divider(5),
      Container(
        height: 50,
        child: FormBuilderTextField(
          maxLines: 1,
          attribute: "shopname",
          textAlign: TextAlign.right,
          decoration: textFieldDecor,
        ),
      ),
    ],
  );
}

InputDecoration commonInputDecoration(IconData _icon, String _placeholder) {
  return InputDecoration(
    prefixIcon: Icon(
      _icon,
      color: yellowAmber,
    ),
    focusColor: Colors.red,
    filled: true,
    fillColor: Colors.white,
    hintText: _placeholder,
    errorStyle: TextStyle(color: Colors.grey),
    focusedBorder: yellowBorder,
    enabledBorder: yellowBorder,
  );
}

InputDecoration commentInputDecoration() {
  return InputDecoration(
    focusColor: Colors.red,
    filled: true,
    contentPadding: EdgeInsets.all(5),
    fillColor: Colors.white,
    hintText: "اكتب تعليق",
    focusedBorder: roundedBorder,
    enabledBorder: roundedBorder,
  );
}

Widget buildBirthDate() {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: FormBuilderDateTimePicker(
      attribute: "birthdate",
      inputType: InputType.date,
      decoration:
          commonInputDecoration(Icons.cake, "تاريخ الميلاد (غير إجبارى)"),
    ),
  );
}

Widget buildGenderField() {
  return Column(
    children: <Widget>[
      SizedBox(
        width: double.infinity,
        child: Text(
          "الجنس (غير إجبارى) ",
          textAlign: TextAlign.end,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
      ),
      divider(5),
      Container(
        height: 60,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: FormBuilderDropdown(
            attribute: "gender",
            decoration: commonInputDecoration(Icons.accessibility, "الجنس"),
            // initialValue: 'Male',
            onChanged: (value) {},
            hint: Text(
              '',
            ),
            items: genders.getFields(),
          ),
        ),
      ),
    ],
  );
}

Widget convertWidget(String attr) {
  if (attr == "email") {
    return buildEmailField();
  } else if (attr == "shopname") {
    return buildShopNameField("");
  } else if (attr == "full_name") {
    return buildFullNameField();
  } else if (attr == "address") {
    return buildAddressField();
  } else if (attr == "gender") {
    return buildGenderField();
  }
}

Widget divider(double i) {
  return Container(
    height: i,
  );
}

InputDecoration yellowInputDecoration(IconData _icon, String _placeholder) {
  return InputDecoration(
    prefixIcon: Icon(
      _icon,
      color: Colors.black,
    ),
    focusColor: Colors.red,
    filled: true,
    fillColor: Colors.white,
    hintText: _placeholder,
    errorStyle: TextStyle(color: Colors.grey),
    focusedBorder: yellowBorder,
    enabledBorder: yellowBorder,
  );
}

Column buildEmailField() {
  return Column(
    children: <Widget>[
      SizedBox(
          width: double.infinity,
          child: Text(
            "البريد الالكتروني",
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          )),
      divider(5),
      Container(
        height: 50,
        child: FormBuilderTextField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          attribute: "email",
          textAlign: TextAlign.right,
          decoration: textFieldDecor,
        ),
      ),
    ],
  );
}

Column buildPasswordField() {
  return Column(
    children: <Widget>[
      SizedBox(
          width: double.infinity,
          child: Text(
            "كلمة السر",
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          )),
      divider(5),
      Container(
        height: 50,
        child: FormBuilderTextField(
          attribute: "password",
          maxLines: 1,
          obscureText: true,
          textAlign: TextAlign.right,
          decoration: textFieldDecor,
        ),
      ),
    ],
  );
}

Column buildAddressField() {
  return Column(
    children: <Widget>[
      SizedBox(
          width: double.infinity,
          child: Text(
            "العنوان",
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          )),
      divider(5),
      FormBuilderTextField(
        attribute: "address",
        textAlign: TextAlign.right,
        decoration: textFieldDecor,
      ),
    ],
  );
}

Widget getStateSpinner() {
  print(provinces.getFields().toString());
  return Directionality(
    textDirection: TextDirection.rtl,
    child: FormBuilderDropdown(
      attribute: "city_id",
      decoration: commonInputDecoration(Icons.location_on, ""),
      items: provinces.getFields(),
      initialValue: null,
      onChanged: (value) {},
      hint: Text(
        "اختر المحافظة",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
  );
}

Column buildCustomField(String attribute, String placeholder,
    {TextInputType type = TextInputType.text}) {
  return Column(
    children: <Widget>[
      divider(5),
      SizedBox(
          width: double.infinity,
          child: Text(
            placeholder,
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          )),
      divider(5),
      FormBuilderTextField(
        keyboardType: type,
        attribute: attribute,
        textAlign: TextAlign.right,
        decoration: textFieldDecor,
      ),
    ],
  );
}
