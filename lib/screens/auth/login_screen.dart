import 'dart:io';

import 'package:da3afes/blocs/auth/bloc.dart';
import 'package:da3afes/blocs/bloc.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/screens/user_type_screen.dart';
import 'package:da3afes/services/login_api.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../application.dart';

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

TextEditingController titleControlers = TextEditingController();

Widget LoginScreen(AuthBloc bloc, BuildContext context) {
  eventBus.on<AppleLogin>().listen((event) {
// All events are of type UserLoggedInEvent (or subtypes of it).
    print("trigerred bus");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserTypeScreen(bloc, event.cred)),
    );
  });

  final loginBloc = new LoginBloc();
  return Scaffold(
      appBar: defaultAppBar("تسجيل الدخول او انشاء حساب "),
      body: SafeArea(
        child: new Container(
          width: double.infinity,
          height: double.infinity,
          decoration: appBackground,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
//                SizedBox(
//                  height: 10,
//                ),
//                AppleSignInButton(
//                  style: ButtonStyle.black,
//                  type: ButtonType.continueButton,
//                  onPressed: appleLogIn,
//                ),
                SizedBox(
                  height: 100.0,
                  child: Image.asset("images/d_logo.png"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: buildEmailField(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: buildPasswordField(),
                ),
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  type: MaterialType.button,
                  color: yellowAmber,
                  child: BlocBuilder<LoginBloc, LoginState>(
                    bloc: loginBloc,
                    builder: (BuildContext context, LoginState state) {
//                        print("state==>" + state.toString());
                      if (state is InitialLoginState) {
                        return loginButton(loginBloc);
                      } else if (state is LoadingLogin) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is FailedLogin) {
                        Fluttertoast.showToast(
                            msg: Trans.I.late("يرجى انشاء حساب جديد"));
                        return loginButton(loginBloc);
                      } else if (state is SuccessLogin) {
                        OneSignal.shared
                            .sendTag("email", _emailController.text.toString());
                        bloc.add(AuthenticatedEvent());
                        return Text("");
                      }
                      return Text(
                        "unknown",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      );
                    },
//
                  ),
                ),
                divider(5),
                SignInButton(
                  Buttons.Facebook,
                  onPressed: () {
                    handleFacebookSignIn(callback(loginBloc, "og_id"));
                  },
                ),
                if (Platform.isIOS)
                  SignInButton(
                    Buttons.AppleDark,
                    onPressed: () {
                      appleLogIn(callbackApple(loginBloc, "apple_id"));
                    },
                  )
                else
                  Container(),
                SignInButton(
                  Buttons.GoogleDark,
                  onPressed: () {
                    handleGoogleSignIn(callback(loginBloc, "og_type"));
                  },
                ),
                divider(5),
                FlatButton(
                  onPressed: () {
                    forgetPassswordDialog(context);
                  },
                  child: Text("هل نسيت كلمة السر ؟"),
                ),
                divider(5),
                RaisedButton(
                  shape: roundedBorder,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserTypeScreen(bloc, null)),
                    );
                  },
                  color: Colors.green,
                  child: Text(
                    Trans.I.late("انشاء حساب جديد"),
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
}

Function callback(LoginBloc bloc, String id) {
  return (s, m) async {
    if (s == TrustStatus.success) {
      bloc.add(ThirdLogin("$id", m));
    }
  };
}

Function callbackApple(LoginBloc bloc, String id) {
  return (s, m, c) async {
    if (s == TrustStatus.success) {
      bloc.add(AppleLogin("$id", m, c));
    }
  };
}

InkWell loginButton(LoginBloc loginBloc) {
  return InkWell(
    onTap: () {
      loginBloc.add(Login(_emailController.text.toString(),
          _passwordController.text.toString()));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: Text(
        Trans.I.late("تسجيل الدخول"),
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}

Column buildEmailField() {
  return Column(
    children: <Widget>[
      SizedBox(
          width: double.infinity,
          child: Text(
            Trans.I.late("البريد الالكتروني"),
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          )),
      divider(5),
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        enableSuggestions: false,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        controller: _emailController,
        maxLines: 1,
        textAlign: TextAlign.center,
        decoration: commonInputDecoration(Icons.email, ""),
      ),
    ],
  );
}

Widget getSubmitButton(BuildContext con, BuildContext context) {
  return InkWell(
    onTap: () async {
      if (titleControlers.text.isNotEmpty) {
        Navigator.pop(con);

        final ProgressDialog pr = ProgressDialog(context);
        pr.style(
            message: 'جاري الارسال',
            backgroundColor: Colors.white,
            progressWidget: CircularProgressIndicator(),
            insetAnimCurve: Curves.easeInOut,
            progress: 0.0,
            textAlign: TextAlign.right,
            padding: EdgeInsets.all(10));
        await pr.show();
        var response = await LoginApi.recover(titleControlers.text.toString());
        if (response.aZSVR == "success") {
          titleControlers.clear();
          Fluttertoast.showToast(
            msg: Trans.I.late("تفقد بريدك الالكتروني من فضلك"),
          );
        } else
          Fluttertoast.showToast(msg: Trans.I.late("يرجى المحاولة مرة اخرى"));

        await pr.hide();
      } else
        Fluttertoast.showToast(msg: Trans.I.late("يرجى ملئ الحقل"));
    },
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: yellowAmber),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            Trans.I.late("ارسال"),
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
          child: Text("البريد الالكتروني",
              textAlign: TextAlign.end,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0))),
      divider(5),
      Container(
        height: 50,
        child: Center(
          child: TextField(
            maxLines: 1,
            controller: titleControlers,
            textAlign: TextAlign.right,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              prefixIcon: Icon(Icons.email),
              hintText: "",
              filled: true,
              fillColor: Colors.white,
              enabledBorder: yellowBorder,
              focusedBorder: yellowBorder,
            ),
          ),
        ),
      ),
    ],
  );
}

void forgetPassswordDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (con) {
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
                border: Border.all(color: yellowAmber, width: 2),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        Trans.I.late("نسيت كلمة السر"),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: yellowAmber),
                      ),
                      divider(5),
                      Text(
                        Trans.I.late(
                            "سوف نرسل لك تعليمات حول كيفية اعادة تعيين كلمة المرور الخاصة بك عن طريق البريد الالكتروني"),
                        textAlign: TextAlign.center,
                      ),
                      divider(5),
                      buildNameField(),
                      divider(10),
                      getSubmitButton(con, context)
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
                  MaterialCommunityIcons.lock_reset,
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
}

Column buildPasswordField() {
  return Column(
    children: <Widget>[
      SizedBox(
          width: double.infinity,
          child: Text(
            Trans.I.late("كلمة السر"),
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          )),
      divider(5),
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        enableSuggestions: false,
        autocorrect: false,
        controller: _passwordController,
        maxLines: 1,
        textAlign: TextAlign.center,
        obscureText: true,
        decoration: commonInputDecoration(Icons.vpn_key, ""),
      ),
    ],
  );
}
