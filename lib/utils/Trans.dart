import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as time_ago;

const Locale defaultLocale = Locale("ar", "IQ");

class Trans {
  static final Trans I = Trans._internal();
  Trans._internal() {
    // load();
    time_ago.setLocaleMessages('ar', time_ago.ArMessages());
    time_ago.setLocaleMessages('ar_short', time_ago.ArShortMessages());
  }

  Locale locale;
  Map<String, dynamic> _localisedValues;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  String get currentLanguage => locale.languageCode;

  // Future<String> init() async {
  //   var asd = await getSelectedLanguage();
  //   this.locale = Locale((asd == "empty") ? defaultLocale.languageCode : asd);
  //   return await getSelectedLanguage();
  // }

//   Future<void> load() async {
//     var asd = await getSelectedLanguage();
//     final String _locale = (asd == "empty") ? defaultLocale.languageCode : asd;
//     final String jsonContent =
//         await rootBundle.loadString("langs/$_locale.json");
//     _localisedValues = await json.decode(jsonContent) as Map<String, dynamic>;
// //    print("asdasd" + Trans.I.late("الكل"));
//     this.locale = Locale(_locale);
//   }

  String late(String key) {
    // if (_localisedValues != null) {
    //   if (_localisedValues[key] != null) {
    //     return _localisedValues[key] ?? "$key";
    //   } else {
    //     // Dio().get("http://207.154.244.51/add.php",
    //     //     queryParameters: {"key": key, "value": key});
    //     // return "$key";
    //   }
    // } else {
    return key;
    // }
  }

  String ago(DateTime date) =>
      time_ago.format(date, locale: locale.languageCode);

  Future<String> getSelectedLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("selected_language") ?? "empty";
  }

  Future<bool> setSelectedLanguage(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("selected_language", value);
  }
}
