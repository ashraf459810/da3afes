import 'package:da3afes/application.dart';
import 'package:da3afes/blocs/bloc.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/screens/PaymentScreen.dart';
import 'package:da3afes/screens/auth/login_screen.dart';
import 'package:da3afes/screens/vin_reports_screen.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:da3afes/widgets/tile_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ReportsView extends StatefulWidget {
  @override
  _ReportsViewState createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> with WidgetsBindingObserver {
  var authBLoc = new AuthBloc();

  bool refreshed = true;

  Future<String> fetchAlbum() async {
    final response = await http
        .get(Uri.parse('https://daafees.com/main/api/api.php?cmd=reporter'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
    }
  }

  Future<String> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();

    eventBus.on<onAuthentcatedResume>().listen((event) {
      // All events are of type UserLoggedInEvent (or subtypes of it).
      print(event);
      authBLoc.add(AuthenticatedEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<String>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == "true")
              return Scaffold(
                  appBar: appBar(context),
                  body: Container(
                    width: double.infinity,
                    decoration: appBackground,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        iconResizeCustom("coming-soon.png", 150),
                        Text(
                          "قريبا ستتوفر هذه الميزة",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ));
            else
              return SafeArea(
                child: BlocBuilder<AuthBloc, AuthState>(
                  bloc: authBLoc,
                  builder: (BuildContext context, AuthState state) {
                    if (state is AuthenticatedState) {
                      return buildReports();
                    } else if (state is NotAuthenticatedState) {
                      refreshed = false;
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
          } else if (snapshot.hasError) {
            return SafeArea(
              child: BlocBuilder<AuthBloc, AuthState>(
                bloc: authBLoc,
                builder: (BuildContext context, AuthState state) {
                  if (state is AuthenticatedState) {
                    return buildReports();
                  } else if (state is NotAuthenticatedState) {
                    refreshed = false;
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
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }

  Widget buildReports() {
    return Scaffold(
      appBar: appBar(context),
      body: Container(
        decoration: appBackground,
        child: Center(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  divider(5),
                  iconTransform("car_crash.jpg", 0.7),
                  divider(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      Trans.I.late(
                          "نوفر لك اسهل واسرع طريقة لمعرفة تقرير سيارتك الوارد وللتآكد من الضرر"),
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  divider(10),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      decoration: commonInputDecoration(
                          Icons.search, Trans.I.late("ادخل رقم الشاصي")),
                    ),
                  ),
                  divider(10),
                  RaisedButton(
                    textColor: Colors.white,
                    color: yellowAmber,
                    onPressed: () {
                      navigate(context, PaymentScreen());
                    },
                    child: Text("بحث"),
                  ),
                  divider(10),
                  Wrap(
                    spacing: 80,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      TileButton(
                        text: Trans.I.late("تقاريري"),
                        iconData: Icons.featured_play_list,
                        onTap: () {
                          navigate(context, VinReportsScreen());
                        },
                      ),
                      Container(child: iconTransform("clear_vin.png", 0.91)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("شراء تقرير"),
      body: Container(
        decoration: appBackground,
        child: Center(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  divider(10),
                  appLogo,
                  divider(20),
                  Text(
                    Trans.I.late("نوفر لك اسهل و اسرع طريقة"),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  divider(10),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      decoration: commonInputDecoration(
                          Icons.search, Trans.I.late("ادخل رقم الشاصي")),
                    ),
                  ),
                  divider(10),
                  RaisedButton(
                    textColor: Colors.white,
                    color: yellowAmber,
                    onPressed: () {
                      navigate(context, PaymentScreen());
                    },
                    child: Text("بحث"),
                  ),
                  divider(10),
                  iconTransform("clear_vin.png", 0.8)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
