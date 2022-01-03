import 'dart:math' as math;

import 'package:da3afes/blocs/bloc.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/models/HomeResponse.dart';
import 'package:da3afes/models/UserTypeResponse.dart';
import 'package:da3afes/screens/ad_screen.dart';
import 'package:da3afes/screens/service_screen.dart';
import 'package:da3afes/services/home_api.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:da3afes/widgets/my_ads_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../../extensions.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin<HomeView> {
  HomeBloc bloc;
  Map<String, dynamic> filters = {};
  Map<String, dynamic> usersfilters = {};
  final _fbKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    bloc = BlocProvider.of<HomeBloc>(context);
    bloc.add(LoadAds(filters));

    super.initState();
  }

  AppBar getAppBar() {
    return filters.isEmpty && usersfilters.isEmpty
        ? appBar(context)
        : AppBar(
            backgroundColor: yellowAmber,
            leading: InkWell(
                onTap: () {
                  usersfilters.clear();
                  filters.clear();
//                  Navigator.pop(context);
                  bloc.add(LoadAds(filters));
                },
                child: Icon(Icons.close)),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: BlocBuilder<HomeBloc, HomeState>(
                bloc: bloc,
                builder: (context, state) {
                  if (state is LoadingHome) {
                    return getScaffold(Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Material(
                              elevation: 3,
                              child: Container(
                                color: primaryColor,
                                height: 90,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      buildHeaderTabs(
                                          "2.png", Trans.I.late("السيارات"),
                                          () {
                                        bloc.add(SwitchTabEvent(
                                            TabCategory.Cars, null));
                                      }),
                                      buildHeaderTabs(
                                          "9.png", Trans.I.late("قطع الغيار"),
                                          () {
                                        bloc.add(SwitchTabEvent(
                                            TabCategory.SparePartsView, null));
                                      }),
                                      buildHeaderTabs("accessories.png",
                                          Trans.I.late("اكسسوارات"), () {
                                        bloc.add(SwitchTabEvent(
                                            TabCategory.AccessoriesView, null));
                                      }),
                                      buildHeaderTabs(
                                          "6.png", Trans.I.late("الوكلاء"), () {
                                        bloc.add(SwitchTabEvent(
                                            TabCategory.RetailersView, null));
                                      }),
                                      buildHeaderTabs(
                                          "5.png", Trans.I.late("شركات الشحن"),
                                          () {
                                        bloc.add(SwitchTabEvent(
                                            TabCategory.ShippingView, null));
                                      }),
                                    ].reversed.toList(),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  appLogo,
                                  JumpingDotsProgressIndicator(
                                    fontSize: 30.0,
                                    color: yellowAmber,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )));
                  } else if (state is LoadedHome) {
                    var response = state.adsList;
                    var size = MediaQuery.of(context).size;
                    if (filters.isNotEmpty &&
                        filters.containsKey("cat_id") &&
                        filters.length == 1) filters["all"] = "0";
                    /*24 is for notification bar on Android*/
                    return getScaffoldSec(buildLoadedHome(size, response));
                  } else if (state is SwitchTabState) {
                    if (state.tab == TabCategory.Cars) {
                      filters.clear();
                      filters["cat_id"] = "1";

                      return getScaffold(buildCarsView());
                    } else if (state.tab == TabCategory.Models) {
                      if (state.filters != null) if (state.filters.isNotEmpty)
                        filters = state.filters;

                      return getScaffold(buildModelsView());
                    } else if (state.tab == TabCategory.UserTypes) {
                      if (state.filters != null) if (state.filters.isNotEmpty)
                        usersfilters = state.filters;

                      return getScaffold(buildUserTypes());
                    } else if (state.tab == TabCategory.Services) {
                      if (state.filters != null) if (state.filters.isNotEmpty)
                        usersfilters = state.filters;

                      usersfilters["user_type"] = "3";
                      return getScaffold(buildServicesView());
                    } else if (state.tab == TabCategory.SparePartsView) {
                      filters.clear();
                      filters["cat_id"] = "11";
                      return getScaffold(buildSparePartsView());
                    } else if (state.tab == TabCategory.AccessoriesView) {
                      filters.clear();
                      filters["cat_id"] = "12";
                      return getScaffold(buildAccessoriesView());
                    } else if (state.tab == TabCategory.RetailersView) {
                      usersfilters.clear();
                      usersfilters["user_type"] = "2";
                      return getScaffold(buildUserTypes());
                    } else if (state.tab == TabCategory.ShippingView) {
                      usersfilters.clear();
                      usersfilters["user_type"] = "7";
                      return getScaffold(buildUserTypes());
                    }
                  }

                  return Text("hello");
                })));
  }

  buildFilterSheet(BuildContext context) {
    return showBottomSheet(
//        isScrollControlled: true,
//        enableDrag: false,
//        isDismissible: true,
        context: context,
        backgroundColor: Colors.transparent,
        elevation: 20,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
                height: 750,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white),
                child: FormBuilder(
                  key: _fbKey,
                  initialValue: filters,
                  child:
                      Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                    divider(10),
                    Center(
                        child: Text(
                      Trans.I.late("الفلترة"),
                      style: Theme.of(context).textTheme.headline5,
                    )),
                    buildInfoRow("القسم", "2", true, categories, "cat_id"),
                    buildInfoRow("المدينة", "a", false, provinces, "city_id"),
                    buildSortBy(),
                    buildPriceRow(),
                    divider(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2.0,
                                      spreadRadius: 0,
                                      offset: Offset(0.0, 1.3))
                                ],
                                border:
                                    Border.all(color: yellowAmber, width: 1),
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 19.0, vertical: 8),
                                child: Center(
                                  child: Text("الغاء"),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            bloc.add(LoadAds(_fbKey.currentState.value));
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 2.0,
                                        spreadRadius: 0,
                                        offset: Offset(0.0, 1.3))
                                  ],
                                  border:
                                      Border.all(color: yellowAmber, width: 1),
                                  borderRadius: BorderRadius.circular(4),
                                  color: yellowAmber),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 19.0, vertical: 8),
                                child: Center(
                                  child: Text("تطبيق"),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    divider(20),
                  ]),
                )),
          );
        });
  }

  Widget buildBroadCrump(bool type,
      {bool filterData = false, bool dad = false}) {
    Map<String, String> crumps = {};

    Iterable<MapEntry<String, dynamic>> list;

    Map<String, dynamic> map = {};

    if (type)
      map = filters;
    else {
      print("asd" + filters.toString());
      if (filters.isNotEmpty &&
          filters.containsKey("cat_id") &&
          filters.length == 1) map.addAll(filters);
      map.addAll(usersfilters);
    }

    map.remove("token");
    list = map.entries;

    print(filters.toString());
    print(list.toString());
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              dad
                  ? InkWell(
                      onTap: () {
                        buildFilterSheet(context);
                      },
                      child: Icon(
                        MaterialCommunityIcons.filter_variant,
                        color: yellowAmber,
                        size: 37,
                      ),
                    )
                  : Container(),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      var item = list.elementAt(index);
                      return InkWell(
                        onTap: () {
                          if (index != list.length - 1) {
                            if (item.key == "cat_id") {
                              if (item.value == "1")
                                bloc.add(
                                    SwitchTabEvent(TabCategory.Cars, null));
                              else if (item.value == "11")
                                bloc.add(SwitchTabEvent(
                                    TabCategory.SparePartsView, null));
                              else if (item.value == "12")
                                bloc.add(SwitchTabEvent(
                                    TabCategory.AccessoriesView, null));
                            } else if (item.key == "is_used") {
                              bloc.add(SwitchTabEvent(
                                  TabCategory.Models,
                                  filters
                                    ..remove("make_id")
                                    ..remove("all")));
                            } else if (item.key == "user_type") {
                              if (item.value == "3") {
                                bloc.add(SwitchTabEvent(TabCategory.Services,
                                    filters..remove("service_type")));
                              }
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2.0,
                                    spreadRadius: 0,
                                    offset: Offset(0.0, 1.3))
                              ],
                              border: Border.all(color: yellowAmber, width: 1),
                              borderRadius: BorderRadius.circular(12),
                              color: (index == list.length - 1)
                                  ? yellowAmber
                                  : Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 4),
                              child: Center(
                                  child: Text(getMap(item.key)[item.value])),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          divider(20),
          Container(
            height: 1,
            color: Colors.black,
          )
        ],
      ),
    );
  }

  SliverToBoxAdapter buildBroadCrumpSec(bool type,
      {bool filterData = false, bool dad = false}) {
    Map<String, String> crumps = {};

    Iterable<MapEntry<String, dynamic>> list;

    Map<String, dynamic> map = {};

    if (type)
      map = filters;
    else {
      print("asd" + filters.toString());
      if (filters.isNotEmpty &&
          filters.containsKey("cat_id") &&
          filters.length == 1) map.addAll(filters);
      map.addAll(usersfilters);
    }

    map.remove("token");
    list = map.entries;

    print(filters.toString());
    print(list.toString());
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                dad
                    ? InkWell(
                        onTap: () {
                          buildFilterSheet(context);
                        },
                        child: Icon(
                          MaterialCommunityIcons.filter_variant,
                          color: yellowAmber,
                          size: 37,
                        ),
                      )
                    : Container(),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        var item = list.elementAt(index);
                        return InkWell(
                          onTap: () {
                            if (index != list.length - 1) {
                              if (item.key == "cat_id") {
                                if (item.value == "1")
                                  bloc.add(
                                      SwitchTabEvent(TabCategory.Cars, null));
                                else if (item.value == "11")
                                  bloc.add(SwitchTabEvent(
                                      TabCategory.SparePartsView, null));
                                else if (item.value == "12")
                                  bloc.add(SwitchTabEvent(
                                      TabCategory.AccessoriesView, null));
                                else
                                  bloc.add(
                                      SwitchTabEvent(TabCategory.Cars, null));
                              } else if (item.key == "is_used") {
                                bloc.add(SwitchTabEvent(
                                    TabCategory.Models,
                                    filters
                                      ..remove("make_id")
                                      ..remove("all")));
                              } else if (item.key == "user_type") {
                                if (item.value == "3") {
                                  bloc.add(SwitchTabEvent(TabCategory.Services,
                                      filters..remove("service_type")));
                                }
                              }
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2.0,
                                      spreadRadius: 0,
                                      offset: Offset(0.0, 1.3))
                                ],
                                border:
                                    Border.all(color: yellowAmber, width: 1),
                                borderRadius: BorderRadius.circular(12),
                                color: (index == list.length - 1)
                                    ? yellowAmber
                                    : Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 4),
                                child: Center(
                                    child: Text(getMap(item.key)[item.value])),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            divider(20),
            Container(
              height: 1,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  Scaffold getScaffold(Widget widget) {
    if (filters.isEmpty && usersfilters.isEmpty)
      return Scaffold(
        appBar: getAppBar(),
        body: SafeArea(
            child: Container(
          decoration: appBackground,
          height: double.infinity,
          child: widget,
        )),
      );
    else
      return Scaffold(
        appBar: getAppBar(),
        body: SafeArea(
            child: Container(
          decoration: appBackground,
          height: double.infinity,
          child: LiquidPullToRefresh(
              showChildOpacityTransition: false,
              onRefresh: () async {
                bloc.add(RefreshHome());
              },
              child: ListView(
                children: <Widget>[
                  widget,
                ],
              )),
        )),
      );
  }

  Scaffold getScaffoldSec(Widget widget) {
    return Scaffold(
      appBar: getAppBar(),
      body: SafeArea(
          child: Container(
              decoration: appBackground,
              height: double.infinity,
              child:
                  // RefreshIndicator(
                  //         onRefresh: () async {
                  //           bloc.add(RefreshHome());
                  //         },
                  //         child:
                  widget
              // ),
              )),
    );
  }

  Widget backbutton() {
    return Container();
  }

  Widget buildUserTypes() {
    return FutureBuilder(
      future: HomeApi.loadWakalas(usersfilters),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildUserTypesGridView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildCarsView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          backbutton(),
          buildBroadCrump(true),

//          buildHeader(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text("اختر الفئة",
                  style: Theme.of(context).textTheme.headline3),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categories.length - 1,
                reverse: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  index = index + 1;
                  var id = categories.keys.elementAt(index);
                  var item = categories[categories.keys.elementAt(index)];
                  return getImagedSquare(item, categoriesImages[id], () {
                    if (id == "2" || id == "3") {
                      if (id == "2")
                        filters["is_used"] = "1";
                      else
                        filters["is_used"] = "0";
                      bloc.add(SwitchTabEvent(TabCategory.Models, filters));
                    } else if (id == "14") {
                      usersfilters.clear();
                      usersfilters["user_type"] = "6";
                      bloc.add(
                          SwitchTabEvent(TabCategory.UserTypes, usersfilters));
                    } else if (id == "15") {
                      bloc.add(SwitchTabEvent(TabCategory.Services, null));
                    } else {
                      filters["cat_id"] = id;
                      bloc.add(LoadAds(filters));
                    }
                  });
                }),
          ),
        ],
      ),
    );
  }

  Widget buildSparePartsView() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          backbutton(),
//          buildHeader(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text("قطع الغيار",
                  style: Theme.of(context).textTheme.headline3),
            ),
          ),
          Wrap(
            runSpacing: 0,
            spacing: 10,
            textDirection: TextDirection.rtl,
            alignment: WrapAlignment.center,
            children: List.generate(spareParts.length, (index) {
              var id = spareParts.keys.elementAt(index);
              var item = spareParts[spareParts.keys.elementAt(index)];
              var function = () {
                if (id == "2") {
                  bloc.add(LoadAds(filters));
                } else if (id == "1") {
                  usersfilters['user_type'] = "4";
                  bloc.add(SwitchTabEvent(TabCategory.UserTypes, usersfilters));
                }
              };
              return InkWell(
                onTap: function,
                child: Container(
                  height: 100,
                  width: 100,
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
                            sparePartsIcons[id],
                            color: yellowAmber,
                            size: 45,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 4),
                            child: Center(
                              child: Text(
                                item,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildAccessoriesView() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          backbutton(),
//          buildHeader(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text("الاكسسوارات",
                  style: Theme.of(context).textTheme.headline3),
            ),
          ),
          Wrap(
            runSpacing: 0,
            spacing: 10,
            textDirection: TextDirection.rtl,
            alignment: WrapAlignment.center,
            children: List.generate(accessories.length, (index) {
              var id = accessories.keys.elementAt(index);
              var item = accessories[accessories.keys.elementAt(index)];
              var function = () {
                if (id == "2") {
                  bloc.add(LoadAds(filters));
                } else if (id == "1") {
                  usersfilters.clear();
                  usersfilters['user_type'] = "5";
                  bloc.add(SwitchTabEvent(TabCategory.UserTypes, usersfilters));
                }
              };
              return InkWell(
                onTap: function,
                child: Container(
                  height: 110,
                  width: 110,
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
                            accessoriesIcons[id],
                            color: yellowAmber,
                            size: 45,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 4),
                            child: Center(
                              child: Text(
                                item,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildServicesView() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          backbutton(),
//          buildHeader(),
          buildBroadCrump(false),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text("اختر نوع الخدمة",
                  style: Theme.of(context).textTheme.headline3),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: serviceTypes.length,
                reverse: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  var id = serviceTypes.keys.elementAt(index);
                  var item = serviceTypes[serviceTypes.keys.elementAt(index)];
                  return getImagedSquare(item, serviceImages[id], () {
                    usersfilters["user_type"] = "3";
                    usersfilters["service_type"] = id;
                    bloc.add(
                        SwitchTabEvent(TabCategory.UserTypes, usersfilters));
                  });
                }),
          ),
        ],
      ),
    );
  }

  Widget buildUserTypesGridView(UserTypeResponse response) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          backbutton(),
          buildBroadCrump(false),
//          buildHeader(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(userTypes[usersfilters['user_type']] ?? "",
                  style: Theme.of(context).textTheme.headline4),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: response.userTypes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, childAspectRatio: 1 / 1.5),
                  itemBuilder: (BuildContext context, int index) {
                    var item = response.userTypes[index];
                    return getNetworkSquare(
                        item.shopname, ppImgDir + item.image, () {
                      navigate(context, ServiceScreen(item));
                    });
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildModelsView() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          backbutton(),
          buildBroadCrump(true),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text("اختر نوع السيارة",
                  style: Theme.of(context).textTheme.headline3),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: makesImages.length + 1,
                reverse: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return getImagedSquarePadded("الكل", "grid.png", () {
                      filters['all'] = "0";
                      bloc.add(LoadAds(filters));
                    });
                  } else {
                    var id = makesImages.keys.elementAt(index);
                    var item = makes[makesImages.keys.elementAt(index)];
                    var image = makesImages[id];
                    return getImagedSquare(item, image, () {
                      filters["make_id"] = id;
                      print(filters.toString());
                      bloc.add(LoadAds(filters));
                    });
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget getSquare(String name, IconData icon, Function ontap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                  size: 45,
                ),
                Center(
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getImagedSquare(String name, String path, Function ontap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                iconResize(path),
                Text(
                  name,
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getImagedSquarePadded(String name, String path, Function ontap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: Image.asset("images/" + path),
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getNetworkSquare(String name, String path, Function ontap) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: <Widget>[
          Card(
            elevation: 8,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: yellowAmber, width: 0.5),
                borderRadius: BorderRadius.circular(8.0)),
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Image.network(
                path,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          divider(10),
          Center(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoadedHome(Size size, List<Ads> response) {
    /*24 is for notification bar on Android*/
//    final double itemHeight = (size.height - kToolbarHeight - 26) / 2.5;
    final double itemHeight = 280;
    final double itemWidth = size.width / 2;
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          (filters.isEmpty && usersfilters.isEmpty)
              ? SliverPersistentHeader(
                  floating: true,
                  pinned: false,
                  delegate: buildHeader(),
                )
//            : SliverPersistentHeader(
//                floating: true,
//                pinned: true,
//                delegate: _SliverAppBarDelegate(
//                    minHeight: 0,
//                    maxHeight: 90,
//                    child:
//                        buildBroadCrumpSec(true, filterData: true, dad: true)),
//              ),

              : buildBroadCrumpSec(true, filterData: true, dad: true),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1));
              bloc.add(RefreshHome());
            },
            refreshTriggerPullDistance: 120,
            refreshIndicatorExtent: 100,
          ),
          (response.isNotEmpty)
              ? SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: (itemWidth / itemHeight),
                      crossAxisCount: 2),
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    final item = response[index];
                    //get your item data here ...
                    var images = item.images.split(",");
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AdView(item, true),
                          ),
                        );
                      },
                      child: GridTile(
                        child: getAdsGridItem(
                            item,
                            "http://daafees.com/main/ads_uploads/" + images[0],
                            context),
                      ),
                    );
                  }, childCount: response.length))
              : SliverToBoxAdapter(
                  child: Center(
                      child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Text("لا توجد اعلانات في هذا المحتوى"),
                ))),
        ],
      ),
    );
  }

  SliverPersistentHeaderDelegate buildHeader() {
    return _SliverAppBarDelegate(
      minHeight: 0.0,
      maxHeight: 90.0,
      child: Material(
        elevation: 3,
        child: Container(
          color: primaryColor,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildHeaderTabs("2.png", Trans.I.late("السيارات"), () {
                  bloc.add(SwitchTabEvent(TabCategory.Cars, null));
                }),
                buildHeaderTabs("9.png", Trans.I.late("قطع الغيار"), () {
                  bloc.add(SwitchTabEvent(TabCategory.SparePartsView, null));
                }),
                buildHeaderTabs("accessories.png", Trans.I.late("اكسسوارات"),
                    () {
                  bloc.add(SwitchTabEvent(TabCategory.AccessoriesView, null));
                }),
                buildHeaderTabs("6.png", Trans.I.late("الوكلاء"), () {
                  bloc.add(SwitchTabEvent(TabCategory.RetailersView, null));
                }),
                buildHeaderTabs("5.png", Trans.I.late("شركات الشحن"), () {
                  bloc.add(SwitchTabEvent(TabCategory.ShippingView, null));
                }),
              ].reversed.toList(),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildInfoRow(String title, String text, bool isenabled,
      Map<String, String> map, String attr) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 5.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 60,
              child: Center(
                child: FormBuilderDropdown(
                  attribute: attr,
                  decoration: InputDecoration(
                      enabledBorder: yellowSolidBorder,
                      disabledBorder: yellowSolidBorder,
                      focusedBorder: yellowSolidBorder),
                  items: map.getCenteredFields(),
                  readOnly: isenabled,
                  onChanged: (value) {
//                    _fbKey.currentState.value[""]
                  },
                  hint: Text(
                    isenabled ? "" : Trans.I.late("اختر المحافظة"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          ConstrainedBox(
            constraints: new BoxConstraints(
              maxHeight: 60,
              maxWidth: 140,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: yellowAmber),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    title,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildPriceRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 5.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 60,
              child: FlutterSlider(
                values: [100, 7000],
                max: 10000,
                min: 0,
                trackBar: FlutterSliderTrackBar(
                  // inactiveTrackBar: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(20),
                  //   color: Colors.black12,
                  //   border: Border.all(width: 3, color: Colors.blue),
                  // ),
                  activeTrackBar: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: yellowAmber),
                ),
                // tooltip: FlutterSliderTooltip(
                //   leftPrefix: iconResizeCustom("coin.png", 20),
                //   rightSuffix: iconResizeCustom("coin.png", 20),
                // ),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: yellowAmber),
                ),
                rangeSlider: true,
                onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                  _fbKey.currentState.value["price_from"] = lowerValue;
                  _fbKey.currentState.value["price_to"] = upperValue;
                },
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          ConstrainedBox(
            constraints: new BoxConstraints(
              maxHeight: 60,
              maxWidth: 140,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: yellowAmber),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    Trans.I.late("حدد السعر"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _currentSelection = 1;
  Map<int, Widget> _children = {
    1: Text('الاحدث'),
    0: Text('الاقل سعر'),
    2: Text('الأعلى سعر'),
  };

  Padding buildSortBy() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 5.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 60,
              child: MaterialSegmentedControl(
                children: _children,
                selectionIndex: _currentSelection,
                borderColor: Colors.grey,
                selectedColor: yellowAmber,
                verticalOffset: 18,
                horizontalPadding: EdgeInsets.all(0),
                unselectedColor: Colors.white,
                disabledColor: lightGrey,
                borderRadius: 1.0,
                onSegmentChosen: (index) {
                  setState(() {
                    _fbKey.currentState.value["sort_by"] = index;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          ConstrainedBox(
            constraints: new BoxConstraints(
              maxHeight: 60,
              maxWidth: 140,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: yellowAmber),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    Trans.I.late("الترتيب حسب"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderTabs(String img, String text, Function function) {
    return InkWell(
      onTap: function,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Material(
                  elevation: 5.0,
                  shape: CircleBorder(),
                  child: Image.asset("images/" + img)),
            ),
          ),
          // iconResizeLarge(img)),
          Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class HomeTabs extends StatefulWidget {
  AppBar appBar;
  Widget widget;
  HomeBloc homeBloc;

  HomeTabs(this.appBar, this.widget, this.homeBloc);

  @override
  _HomeTabsState createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: SafeArea(
          child: Container(
        child: RefreshIndicator(
            onRefresh: () async {
              widget.homeBloc.add(RefreshHome());
            },
            child: ListView(
              children: <Widget>[
                widget,
              ],
            )),
      )),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
