import 'package:apple_sign_in/apple_id_credential.dart';
import 'package:da3afes/blocs/auth/auth_bloc.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/screens/auth/user_signup.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserTypeScreen extends StatefulWidget {
  AuthBloc bloc;
  AppleIdCredential credential;
  // UserTypeScreen(this.bloc);
  UserTypeScreen(this.bloc, this.credential);

  @override
  _UserTypeScreenState createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  String userType = "";
  String serviceType = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("اختر نوع الحساب"),
      body: SafeArea(
        child: Container(
          decoration: appBackground,
          child: Column(
            children: getChildren(),
          ),
        ),
      ),
    );
  }

  List<Widget> getChildren() {
    List<Widget> list = new List<Widget>();

    list.add(SizedBox(
      height: 30,
    ));
    list.add(appLogo);
    list.add(SizedBox(
      height: 10,
    ));
    list.add(getUserTypeSpinner());
    if (userType == "3") {
      list.add(getShopTypeSpinner());
    }

    list.add(getNextButton());
    return list;
  }

  Widget getNextButton() {
    return RaisedButton(
      color: yellowAmber,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0),
        child: Text(
          Trans.I.late("التالي"),
          style: TextStyle(color: Colors.white),
        ),
      ),
      onPressed: () {
        if (userType.isEmpty)
          Fluttertoast.showToast(msg: Trans.I.late("يرجى ملئ جميع الحقول"));
        else if (userType == "3" && serviceType.isEmpty) {
          Fluttertoast.showToast(msg: Trans.I.late("يرجى ملئ جميع الحقول"));
        } else
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserRegisterScreen(
                    userType, serviceType, widget.bloc, widget.credential)),
          );
      },
    );
  }

  Padding getUserTypeSpinner() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButtonFormField<String>(
          decoration: commonInputDecoration(Icons.account_circle, ""),
          items: userTypes.getFields(),
          onChanged: (value) {
            print("value: $value");
            setState(() {
              userType = value;
            });
          },
          hint: Text(
            Trans.I.late("نوع الحساب"),
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Padding getShopTypeSpinner() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButtonFormField<String>(
          decoration: commonInputDecoration(Icons.build, ""),
          items: serviceTypes.getFields(),
          onChanged: (value) {
            print("value: $value");
            setState(() {
              serviceType = value;
            });
          },
          hint: Text(
            Trans.I.late("نوع الخدمة"),
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
