import 'package:da3afes/application.dart';
import 'package:da3afes/blocs/home/home_bloc.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/models/HomeResponse.dart';
import 'package:da3afes/screens/views/add_post_view.dart';
import 'package:da3afes/screens/views/home_view.dart';
import 'package:da3afes/screens/views/reports_view.dart';
import 'package:da3afes/screens/views/services_view.dart';
import 'package:da3afes/screens/views/videos_view.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'ad_screen.dart';

class MainView extends StatefulWidget {
  MainView();

  @override
  State<StatefulWidget> createState() {
    return MainViewState();
  }
}

class MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<Widget> _children = [
    BlocProvider<HomeBloc>(create: (context) => HomeBloc(), child: HomeView()),
    ServicesScreen(),
    PostTypeScreen(),
    VideoCategoriesScreen(),
    ReportsView(),
  ];

  List<PersistentBottomNavBarItem> tabsList;
  PersistentTabController tabController;

  var navBarHeight = 60.0;

  @override
  void initState() {
    super.initState();

    tabController = PersistentTabController(initialIndex: 0);

    print(Trans.I.late("الرئيسية"));
    eventBus.on<SwitchTab>().listen((event) {
      tabController.jumpToTab(event.index);
      context.widget.toString();
    });
    tabsList = [
      PersistentBottomNavBarItem(
          icon: new Icon(Icons.home),
          title: Trans.I.late("الرئيسية"),
          activeColor: yellowAmber,
          inactiveColor: grey),
      PersistentBottomNavBarItem(
          icon: new Icon(Icons.location_on),
          title: Trans.I.late("الخدمات"),
          activeColor: yellowAmber,
          inactiveColor: grey),
      PersistentBottomNavBarItem(
          icon: new Icon(
            Icons.add_circle,
            size: 34,
          ),
          title: " ",
          activeColor: yellowAmber,
          inactiveColor: grey),
      PersistentBottomNavBarItem(
        icon: new Icon(Icons.ondemand_video),
        title: Trans.I.late("الفيديو"),
        activeColor: yellowAmber,
        inactiveColor: grey,
      ),
      PersistentBottomNavBarItem(
        icon: new Icon(Icons.featured_play_list),
        activeColor: yellowAmber,
        title: Trans.I.late("تقارير السيارات"),
        inactiveColor: grey,
      )
    ];
    _tabController = new TabController(length: _children.length, vsync: this);
    if (toDo != null)
      SchedulerBinding.instance.addPostFrameCallback((a) {
        Fluttertoast.showToast(msg: "hola");
        print(
            "mainvieww OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AdView(Ads(id: toDo), false),
          ),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    singletonContext = context;
    bool _isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (_isKeyboardOpen)
      navBarHeight = 0.0;
    else
      navBarHeight = 60.0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: PersistentTabView(
        controller: tabController,
        items: tabsList,
        screens: _children,
        navBarHeight: navBarHeight,
        backgroundColor: Color(0xFFe2e2e2),
        handleAndroidBackButtonPress: true,
        popAllScreensOnTapOfSelectedTab: false,
        confineInSafeArea: true,
//        showElevation: true,
        navBarStyle: NavBarStyle.style3,
      ),
    );
  }

  Widget iconTransform(String path) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Transform.scale(scale: 2.0, child: Image.asset("images/" + path)),
    );
  }

  Text titleStyle(String msg) {
    return Text(
      msg,
      style: TextStyle(color: Colors.black, fontSize: 14.0),
    );
  }
}
