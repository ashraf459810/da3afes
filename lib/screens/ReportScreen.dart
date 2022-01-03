import 'package:da3afes/consts.dart';
import 'package:da3afes/services/ad_api.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
  String id;

  ReportScreen(this.id);
}

class _ReportScreenState extends State<ReportScreen> {
  TextEditingController titleControlers = TextEditingController();
  TextEditingController msgControlers = TextEditingController();

  Map<IconData, String> map = {
    MaterialCommunityIcons.tag_text_outline: Trans.I.late("اعلان مباع"),
    MaterialCommunityIcons.image_multiple: Trans.I.late("اعلان مكرر"),
    MaterialCommunityIcons.alert_circle: Trans.I.late("اعلان مخل بالاداب"),
    MaterialCommunityIcons.folder_alert: Trans.I.late("اعلان في القسم الخطاء"),
    MaterialCommunityIcons.dots_horizontal: Trans.I.late("غير ذلك"),
  };

  var con;

  @override
  Widget build(BuildContext context) {
    con = context;
    return Scaffold(
      appBar: defaultAppBar("تبليغ"),
      body: Container(
        height: double.infinity,
        decoration: appBackground,
        child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: map.length,
            reverse: false,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              var item = map.keys.elementAt(index);
              var name = map[map.keys.elementAt(index)];
              return getSquare(name, item, () {
                if (index == 4) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        elevation: 0.0,
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                top: 66,
                                bottom: 16,
                                right: 16,
                                left: 16,
                              ),
                              margin: EdgeInsets.only(top: 66),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: yellowAmber, width: 2),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 38.0, vertical: 0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      buildMsgField(),
                                      divider(20),
                                      getSubmitButton(context, index)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              right: 16,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 66,
                                child: Icon(
                                  MaterialCommunityIcons.alert_octagon,
                                  size: 120,
                                  color: yellowAmber,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  submitReport(widget.id, index.toString());
                }
              });
            }),
      ),
    );
  }

  Column buildMsgField() {
    return Column(
      children: <Widget>[
        SizedBox(
            width: double.infinity,
            child: Text(
              Trans.I.late("رسالة التبليغ"),
              textAlign: TextAlign.end,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            )),
        Container(
          height: 70,
          child: TextField(
            expands: true,
            maxLines: null,
            controller: msgControlers,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: yellowBorder,
              focusedBorder: yellowBorder,
            ),
          ),
        ),
      ],
    );
  }

  void submitReport(String id, String type, {String notes}) async {
    ProgressDialog pr = ProgressDialog(context);

    pr.style(
        message: 'جاري الارسال',
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        textAlign: TextAlign.right,
        padding: EdgeInsets.all(10));
    await pr.show();
    var response = await AdApi.reportAd(id, type);
    if (response.aZSVR == "success") {
      titleControlers.clear();
      Fluttertoast.showToast(
        msg: Trans.I.late("تم التبليغ بنجاح"),
      );
    } else
      Fluttertoast.showToast(msg: Trans.I.late("يرجى التاكد من تسجيل دخولك"));

    await pr.hide();

    Navigator.pop(context);
  }

  Widget getSubmitButton(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, false);
        if (msgControlers.text.isEmpty) {
          Fluttertoast.showToast(msg: Trans.I.late("يرجى ملئ الحقول"));
        } else {
          submitReport(widget.id, index.toString(),
              notes: msgControlers.text.toString());
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.red),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              Trans.I.late("تبليغ"),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Column buildNameField() {
    return Column(
      children: <Widget>[
        SizedBox(
            width: double.infinity,
            child: Text(
              Trans.I.late("عنوان التبليغ"),
              textAlign: TextAlign.end,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            )),
        Container(
          height: 50,
          child: TextField(
            maxLines: 1,
            controller: titleControlers,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: "",
              filled: true,
              fillColor: Colors.white,
              enabledBorder: yellowBorder,
              focusedBorder: yellowBorder,
            ),
          ),
        ),
      ],
    );
  }

  Widget getSquare(String name, IconData icon, Function ontap) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: ontap,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
              side: new BorderSide(color: yellowAmber, width: 0.5),
              borderRadius: BorderRadius.circular(8.0)),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  color: yellowAmber,
                  size: 55,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
