import 'package:da3afes/blocs/bloc.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/models/HomeResponse.dart';
import 'package:da3afes/screens/ad_screen.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../../extensions.dart';

class AdEditScreen extends StatefulWidget {
  String city = "";
  String postType = "";

  Ads ad;

  AdEditScreen(this.ad);

  @override
  State<StatefulWidget> createState() {
    return AdEditScreenState();
  }
}

class AdEditScreenState extends State<AdEditScreen> {
  final _fbKey = GlobalKey<FormBuilderState>();
  CreateAdBloc uploadBloc;
  Map<String, dynamic> _adInfo = new Map<String, dynamic>();
  int radioGroup = 0;
  List<dynamic> images = [];

  ContactUsBlocBloc cbloc;

  @override
  void initState() {
    uploadBloc = CreateAdBloc();
    _adInfo = widget.ad.toJson();
    widget.city = _adInfo["city_id"];
    widget.postType = _adInfo["cat_id"];
    cbloc = ContactUsBlocBloc();
    if (widget.ad.images.isNotEmpty) {
      var list = widget.ad.images.split(",");
      list.removeWhere((element) => element.isEmpty);
      images.addAll(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
      appBar: defaultAppBar("اضافة اعلان"),
      body: Padding(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
        ),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            FormBuilder(
              key: _fbKey,
              // autovalidate: true,
              initialValue: widget.ad.toJson(),
              child: Column(
                children: <Widget>[
                  divider(20),
                  Column(
                    children: getFields(widget.ad),
                  ),
                  uploadButton("msg"),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget getCarModel(Map<String, dynamic> map, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButtonFormField<String>(
          isDense: true,
          value: value,
          decoration: commonInputDecoration(
            MaterialCommunityIcons.car,
            "",
          ),
          items: makes.getFields(),
          onChanged: (value) {
            map["make_id"] = value;
            cbloc.add(LoadMakes(value));
            print(map.toString());
          },
          hint: Text(
            Trans.I.late("نوع السيارة"),
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getFields(Ads ad) {
    List<Widget> list = new List<Widget>();
    if (widget.postType == "1") {
      list.add(buildImageButton());
      list.add(buildGridView());
      list.add(divider(20));

      list.add(getCarModel(_adInfo, ad.makeId));
      list.add(BlocBuilder<ContactUsBlocBloc, ContactUsBlocState>(
        bloc: cbloc,
        builder: (context, state) {
          if (state is MakesLoaded) {
            var value;
            if (state.makes.containsValue(_adInfo["model_id"]))
              value = _adInfo["model_id"];
            else
              value = null;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: DropdownButtonFormField<String>(
                  key: new GlobalKey(),
                  isDense: true,
                  value: value,
                  decoration: commonInputDecoration(
                    MaterialCommunityIcons.car,
                    "",
                  ),
                  items: state.makes.getFields(),
                  onChanged: (value) {
                    _adInfo["model_id"] = value;
                    print(_adInfo.toString());
                  },
                  hint: Text(
                    Trans.I.late("اختر الفئة"),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            );
          } else
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: DropdownButtonFormField<String>(
                  isDense: true,
                  decoration: commonInputDecoration(
                    MaterialCommunityIcons.car,
                    "",
                  ),
                  items: [],
                  onChanged: (value) {},
                  hint: Text(
                    Trans.I.late("اختر الفئة"),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            );
        },
      ));

//      list.add(getCarName(_adInfo, null));
      list.add(getYearsDropDown(_adInfo, ad.year));
      list.add(radioCustom(_adInfo, ad.isUsed.toInt()));

      list.add(getDropDown(
        map: _adInfo,
        value: ad.kmCat,
        key: "km_cat",
        hint: Trans.I.late("الكيلومترات"),
        items: kmCats,
        icon: MaterialCommunityIcons.radar,
      ));
      list.add(getTransmissionSpinner(_adInfo, ad.transmissionType));
      list.add(getDropDown(
        map: _adInfo,
        value: ad.color,
        key: "color",
        hint: Trans.I.late("اختر اللون"),
        items: colors,
        icon: MaterialCommunityIcons.format_color_fill,
      ));
      list.add(getFuelSpinner(_adInfo, ad.fuelType));
      list.add(getAdDescription(_adInfo, ad.description));

      list.add(getAdPriceField(_adInfo, ad.price));
    } else if (widget.postType == "11" || widget.postType == "12") {
      list.add(buildImageButton());
      list.add(buildGridView());
      list.add(divider(20));
      list.add(getAdTitleField(_adInfo, ad.title, postTypes[widget.postType]));

      list.add(getCarModel(_adInfo, ad.makeId));
      list.add(getYearsDropDown(_adInfo, ad.year));
      if (ad.isUsed != null) if (ad.isUsed == '1')
        radioGroup = 1;
      else
        radioGroup = 0;
      list.add(radio(_adInfo, radioGroup));

      list.add(getAdPriceField(_adInfo, null));
    } else if (widget.postType == "7") {
      list.add(buildImageButton());
      list.add(buildGridView());
      list.add(divider(20));
      list.add(getDropDown(
        map: _adInfo,
        value: ad.description,
        key: "description",
        hint: Trans.I.late("نوع الرقم"),
        items: numberPlateType,
        icon: MaterialCommunityIcons.counter,
      ));
      list.add(getNumberPlateField(_adInfo, ad.title));
      list.add(getAdPriceField(_adInfo, ad.price));
    }

    return list;
  }

  Widget radioCustom(Map<String, dynamic> map, int group) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          onTap: () {
            map["is_used"] = "3";
            setState(() {});
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: map["is_used"] == "3" ? Colors.grey[300] : Colors.white,
              border: Border.all(color: yellowAmber),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    Trans.I.late("تكسي"),
                  ),
                ),
                iconSmallResize("categories/c66.png")
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            map["is_used"] = "2";
            setState(() {});
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: map["is_used"] == "2" ? Colors.grey[300] : Colors.white,
              border: Border.all(color: yellowAmber),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    Trans.I.late("جديد"),
                  ),
                ),
                iconResize("carnew.png")
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            map["is_used"] = "1";
            setState(() {});
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: map["is_used"] == "1" ? Colors.grey[300] : Colors.white,
              border: Border.all(color: yellowAmber),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Text(
                    Trans.I.late("مستعمل"),
                  ),
                ),
                iconSmallResize("categories/c2.png")
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildGridView() {
    if (images.isNotEmpty)
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          children: List.generate(images.length, (index) {
            var asset = images[index];
            return Container(
              height: 308,
              width: 308,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  children: <Widget>[
                    (asset is Asset)
                        ? AssetThumb(
                            asset: asset,
                            width: 300,
                            height: 300,
                          )
                        : Image.network(adImgDir + asset.toString()),
                    InkWell(
                      onTap: () {
                        setState(() {
                          images.removeAt(index);
                        });
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.cancel,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      if (images == null) images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = images + resultList;
    });
  }

  Widget radio(Map<String, dynamic> map, int group) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: <Widget>[
            Text(
              Trans.I.late("الحالة"),
              textAlign: TextAlign.end,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            ),
            SizedBox(
              width: 20,
            ),
            new Radio(
              value: 0,
              groupValue: group,
              onChanged: (value) {
                group = value;
                radioGroup = value;
                map["is_used"] = value;
                print(map.toString());
                setState(() {});
              },
            ),
            new Text(
              'جديد',
              style: new TextStyle(fontSize: 16.0),
            ),
            new Radio(
              value: 1,
              groupValue: group,
              onChanged: (value) {
                radioGroup = value;
                map["is_used"] = value;
                print(map.toString());
                setState(() {});
              },
            ),
            new Text(
              'مستعمل',
              style: new TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  FlatButton buildImageButton() {
    return FlatButton(
        onPressed: () {
//          getImage();
          loadAssets();
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: yellowAmber, width: 3)),
            width: 100.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                MaterialCommunityIcons.camera_plus,
                size: 60,
                color: yellowAmber,
              ),
            )));
  }

  Widget uploadButton(String msg) {
    return BlocBuilder<CreateAdBloc, CreateAdState>(
        bloc: uploadBloc,
        builder: (BuildContext context, CreateAdState state) {
          print("state is " + state.toString());
          if (state is LoadingCreateAd)
            return Center(child: CircularProgressIndicator());
          else if (state is SubmittedAd) {
            if (state.response.aZSVR == "success" ||
                state.response.aZSVR == "SUCCESS") {
              Fluttertoast.showToast(msg: Trans.I.late("تم تحديث البيانات"));
              Future.delayed(Duration(milliseconds: 500), () {
                Navigator.pop(context, false);
                navigate(context, AdView(Ads(id: widget.ad.id), false));
              });
            } else
              Fluttertoast.showToast(msg: Trans.I.late("حدث خطاء"));
            return getSubmitButton();
          } else
            return getSubmitButton();
        });
  }

  Widget getSubmitButton() {
    return InkWell(
      onTap: () {
        uploadBloc.add(Update(_adInfo, images));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: yellowAmber),
          child: Center(
            child: Text("حفظ التغييرات"),
          ),
        ),
      ),
    );
  }
}
