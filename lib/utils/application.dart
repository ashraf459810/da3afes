import 'dart:ui';

class Application {
  static final Application _application = Application._internal();

  factory Application() {
    return _application;
  }

  Application._internal();

  final List<Locale> supportedLanguages = [
    const Locale("en", "GB"),
    const Locale("ar", "IQ"),
    const Locale("ar", "KR"),
  ];
  //function to be invoked when changing the language
  LocaleChangeCallback onLocaleChanged;
}

Application application = Application();

typedef LocaleChangeCallback = void Function(Locale locale);
