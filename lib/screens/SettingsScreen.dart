import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:country_code/country_code.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/models/ProfileResponse.dart';
import 'package:da3afes/respositries/user_repository.dart';
import 'package:da3afes/services/register_api.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
  Profile profile;

  SettingsScreen(this.profile);
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool dataChanged = false;

  var con;

  @override
  Widget build(BuildContext context) {
    con = context;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, dataChanged);
        return new Future.value(true);
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        appBar: defaultAppBar("الاعدادات"),
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              height: double.infinity,
              decoration: appBackground,
              child: SingleChildScrollView(
                child: Column(
                  children: children(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> children() {
    var list = <Widget>[
      divider(20),
      line(),
      cover(ListTile(
        onTap: () {
          _showDialog();
        },
        leading: Icon(
          MaterialCommunityIcons.map_marker,
          color: navy,
        ),
        title: Text(
          Trans.I.late("تغيير المدينة"),
          style: TextStyle(color: navy, fontWeight: FontWeight.w600),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(provinces[widget.profile.cityId] ?? ""),
            Container(width: 5),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      )),
      line(),
      cover(ListTile(
        onTap: () {
          _showDialogAddress();
        },
        leading: Icon(
          Entypo.address,
          color: navy,
        ),
        title: Text(
          Trans.I.late("الحي/المنطقة"),
          style: TextStyle(color: navy, fontWeight: FontWeight.w600),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(widget.profile.address != null
                ? ((widget.profile.address.isNotEmpty)
                    ? widget.profile.address.trim()
                    : "")
                : ""),
            Container(width: 5),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      )),
      // line(),
      // cover(ListTile(
      //   onTap: () {
      //     _settingModalBottomSheet(context);
      //   },
      //   leading: Icon(
      //     MaterialCommunityIcons.earth,
      //     color: navy,
      //   ),
      //   title: Text(
      //     Trans.I.late("اللغة"),
      //     style: TextStyle(color: navy, fontWeight: FontWeight.w600),
      //   ),
      //   trailing: Row(
      //     mainAxisSize: MainAxisSize.min,
      //     children: <Widget>[
      //       Text(Trans.I.currentLanguage == "ar" ? "عربي" : "English"),
      //       Container(width: 5),
      //       Icon(Icons.arrow_forward_ios),
      //     ],
      //   ),
      // )),
      line(),
      listTile(Trans.I.late("عن التطبيق"), MaterialCommunityIcons.alert_circle,
          () {
        navigate(
            context,
            new WebviewScaffold(
              url: "https://daafees.com",
              appBar: defaultAppBar(
                Trans.I.late("عن التطبيق"),
              ),
              withZoom: false,
              withJavascript: true,
              withLocalStorage: true,
              hidden: false,
            ));
      }),
      line(),
      listTile(Trans.I.late("الاحكام و الشروط"),
          MaterialCommunityIcons.file_document, () {
        navigate(
            context,
            new WebviewScaffold(
              url: "https://daafees.com/index.php/terms/",
              appBar: defaultAppBar(
                Trans.I.late("الاحكام و الشروط"),
              ),
              withZoom: false,
              withJavascript: true,
              withLocalStorage: true,
              hidden: false,
            ));
      }),
      line(),
      listTile(
          Trans.I.late("سياسة المحتوى"), MaterialCommunityIcons.shield_check,
          () {
        navigate(
            context,
            new WebviewScaffold(
              url: "https://daafees.com/index.php/privacy/",
              appBar: defaultAppBar(Trans.I.late("سياسة المحتوى")),
              withZoom: false,
              withJavascript: true,
              withLocalStorage: true,
              hidden: false,
            ));
      }),
      line(),
      divider(20),
      line(),
      listTile(Trans.I.late("تسجيل الخروج"), MaterialCommunityIcons.logout,
          () async {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO,
          animType: AnimType.BOTTOMSLIDE,
          title: Trans.I.late("هل تريد تسجيل الخروج ؟"),
          desc: "",
          dismissOnBackKeyPress: true,
          btnOkColor: yellowAmber,
          dismissOnTouchOutside: true,
          btnOkOnPress: () async {
            await UserRepository().deleteToken();
            Phoenix.rebirth(context);
          },
        )..show();
      }),
      line(),
    ];

    return list;
  }

  _showDialogAddress() async {
    var id = "";
    await showDialog<String>(
      context: context,
      builder: (context) => new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: new TextField(
                  autofocus: false,
                  onChanged: (asd) => id = asd,
                  decoration: new InputDecoration(
                      labelText: 'المنطقة', hintText: 'المنطقة/الحي'),
                ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('الغاء'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('حفظ'),
              onPressed: () {
                if (id.isNotEmpty) {
                  dataChanged == true;
                  RegisterApi.update({"address": id});
                  widget.profile.address = id;
                  Navigator.pop(context);
                  setState(() {});
                } else
                  Navigator.pop(context);
              })
        ],
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: Text(CountryCode.IQ.symbol),
                    title: new Text(' عربي'),
                    onTap: () async {
                      // await Trans.I.setSelectedLanguage("ar");
                      // await Trans.I.load();
                      Phoenix.rebirth(context);
                    }),
                new ListTile(
                  leading: Text(CountryCode.GB.symbol),
                  title: new Text('English'),
                  onTap: () async {
                    // await Trans.I.setSelectedLanguage("en");
                    // await Trans.I.load();

                    Phoenix.rebirth(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  _showDialog() async {
    var id = "";
    await showDialog<String>(
      context: context,
      builder: (context) => new _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Directionality(
                textDirection: TextDirection.rtl,
                child: FormBuilderDropdown(
                  attribute: "city_id",
                  initialValue: widget.profile.cityId,
                  decoration: commonInputDecoration(Icons.location_on, ""),
                  items: provinces.getFields(),
                  onChanged: (value) {
                    id = value;
                  },
                  hint: Text(
                    Trans.I.late("اختر المحافظة"),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('الغاء'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('حفظ'),
                onPressed: () {
                  if (id.isNotEmpty && widget.profile.cityId != id) {
                    dataChanged == true;
                    RegisterApi.update({"city_id": id});
                    widget.profile.cityId = id;
                    Navigator.pop(context);
                    setState(() {});
                  } else
                    Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}

Widget listTile(String title, IconData icon, Function function) {
  return cover(ListTile(
    onTap: function,
    leading: Icon(
      icon,
      color: navy,
    ),
    title: Text(
      title,
      style: TextStyle(color: navy, fontWeight: FontWeight.w600),
    ),
    trailing: Icon(Icons.arrow_forward_ios),
  ));
}

Widget cover(Widget data) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        color: Colors.white,
        child: data,
      ),
    ],
  );
}

Container line() {
  return Container(
    color: yellowAmber,
    height: 0.5,
  );
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
        padding: EdgeInsets.all(20),
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
