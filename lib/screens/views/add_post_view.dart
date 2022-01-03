import 'package:da3afes/blocs/auth/auth_bloc.dart';
import 'package:da3afes/blocs/auth/auth_event.dart';
import 'package:da3afes/blocs/auth/auth_state.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/screens/auth/login_screen.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../ad_posting_screen.dart';

class PostTypeScreen extends StatefulWidget {
  @override
  _PostTypeScreenState createState() => _PostTypeScreenState();
}

class _PostTypeScreenState extends State<PostTypeScreen> {
  String city = "";
  String adType = "";
  var authBLoc = new AuthBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    UserRepository().persistToken(
//        "ea5df72e6ada58de48cb9af23fc354ea0eb5f057a4bd8b6db02e8258e041ecdf");
    return SafeArea(
      child: BlocBuilder<AuthBloc, AuthState>(
        bloc: authBLoc,
        builder: (BuildContext context, AuthState state) {
          if (state is AuthenticatedState) {
            return buildScaffold();
          } else if (state is NotAuthenticatedState) {
            return LoginScreen(authBLoc, context);
          } else if (state is InitialAuthState) {
            authBLoc.add(AuthenticateEvent());
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: CircularProgressIndicator()),
              ],
            );
          }
          return Text("unknown state");
        },
      ),
    );
  }

  Scaffold buildScaffold() {
    return Scaffold(
      appBar: defaultAppBar(Trans.I.late("اضافة اعلان جديد")),
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

    list.add(divider(10));
    list.add(appLogo);

    list.add(divider(10));
    list.add(getStateSpinner());
    list.add(getPostTypeSpinner());

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
        if (city.isEmpty || adType.isEmpty)
          Fluttertoast.showToast(msg: Trans.I.late("يرجى ملئ جميع الحقول"));
        else
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdPostScreen(city, adType)),
          );
      },
    );
  }

  Padding getStateSpinner() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButtonFormField<String>(
          decoration: commonInputDecoration(Icons.location_on, ""),
          items: provinces.getFields(),
          onChanged: (value) {
            print("value: $value");
            setState(() {
              city = value;
            });
          },
          hint: Text(
            Trans.I.late("اختر محافظتك"),
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Padding getPostTypeSpinner() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButtonFormField<String>(
          decoration: commonInputDecoration(Icons.build, ""),
          items: postTypes.getFields(),
          onChanged: (value) {
            print("value: $value");
            setState(() {
              adType = value;
            });
          },
          hint: Text(
            Trans.I.late("اختر القسم الذي تود الاعلان به"),
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
