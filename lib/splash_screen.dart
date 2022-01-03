import 'package:da3afes/application.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/screens/main_view.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: double.infinity,
        decoration: appBackground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(child: appLogo),
            FutureBuilder<String>(
              future: Trans.I.getSelectedLanguage(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  moveOn(context);
                  return Container();
                } else
                  return Container();
              },
            ),
          ],
        ),
      )),
    );
  }

  moveOn(BuildContext context) async {
    // await Trans.I.load();
    await refreshData();
    Future.delayed(Duration(seconds: 0), () {
      navigate(context, MainView());
    });
  }
}
