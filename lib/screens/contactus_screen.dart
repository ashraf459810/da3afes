import 'package:da3afes/consts.dart';
import 'package:da3afes/models/ProfileResponse.dart';
import 'package:da3afes/services/contactus_api.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ContactUsScreen extends StatefulWidget {
  Profile profile;

  ContactUsScreen(this.profile);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextEditingController titleControlers = TextEditingController();
  TextEditingController msgControlers = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(Trans.I.late("تواصل معنا")),
      body: SafeArea(
          child: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              divider(20),
              appLogo,
              divider(20),
              headline(Trans.I.late("اتصل بنا")),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    info("07712312312", MaterialCommunityIcons.whatsapp),
                    divider(5),
                    info("info@daafees.com", MaterialCommunityIcons.email),
                    divider(5),
                    info("Daafees - دعافيس", MaterialCommunityIcons.facebook),
                  ],
                ),
              ),
              headline(Trans.I.late("او يمكنك ارسال ملاحظاتك")),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: Column(
                  children: <Widget>[
                    buildNameField(),
                    divider(10),
                    buildmsgField(),
                    getSubmitButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Column buildNameField() {
    return Column(
      children: <Widget>[
        SizedBox(
            width: double.infinity,
            child: Text(
              Trans.I.late("ما نوع ملاحظاتك"),
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
              hintText: Trans.I.late("اقتراح, شكر, شكوى"),
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

  uploadMsg() async {
    var response = await ContactApi.submit(
        titleControlers.text.toString(), msgControlers.text.toString());
    if (response.aZSVR.toLowerCase() == "success") {
      titleControlers.clear();
      msgControlers.clear();
      Fluttertoast.showToast(msg: Trans.I.late("تم الارسال بنجاح"));
    } else {
      Fluttertoast.showToast(msg: Trans.I.late("يرجى المحاول مرة اخرى"));
    }
  }

  Widget getSubmitButton() {
    return InkWell(
      onTap: () {
        if (titleControlers.text.isEmpty || msgControlers.text.isEmpty) {
          Fluttertoast.showToast(msg: Trans.I.late("يرجى ملئ الحقول"));
        } else
          uploadMsg();
      },
      child: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.green),
        child: Center(
          child: Text(
            Trans.I.late("ارسال"),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Column buildmsgField() {
    return Column(
      children: <Widget>[
        SizedBox(
            width: double.infinity,
            child: Text(
              Trans.I.late("الرسالة"),
              textAlign: TextAlign.end,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            )),
        Container(
          height: 100,
          child: TextField(
            controller: msgControlers,
            maxLines: 1,
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

  Container headline(String text) {
    return Container(
      color: lightGrey2,
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
      )),
    );
  }

  Widget info(String text, IconData icon) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: yellowAmber, width: 1),
          borderRadius: BorderRadius.circular(8)),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  icon,
                  color: yellowAmber,
                )),
            Center(
              child: Text(
                text,
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
