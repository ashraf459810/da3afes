import 'dart:io';

import 'package:da3afes/bloc_delegate.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../extensions.dart';

class AdPostScreen extends StatefulWidget {
  String city = "";
  String postType = "";

  AdPostScreen(this.city, this.postType);

  @override
  State<StatefulWidget> createState() {
    return AdPostScreenState();
  }
}

class AdPostScreenState extends State<AdPostScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  File _image;
  final _fbKey = GlobalKey<FormBuilderState>();
  CreateAdBloc uploadBloc;
  Map<String, dynamic> _adInfo = new Map<String, dynamic>();
  int radioGroup = 1;
  List<Asset> images = [];
  String _error;

  ContactUsBlocBloc cbloc;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      print("image updated");
      _image = image;
    });
  }

  @override
  void initState() {
    cbloc = ContactUsBlocBloc();
    BlocSupervisor.delegate = MyShopBlocDelegate();
    uploadBloc = CreateAdBloc();
    _adInfo["is_used"] = "1";
    _adInfo["city_id"] = widget.city;
    _adInfo["cat_id"] = widget.postType;
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
              initialValue: {"transmission_type": "2", "is_used": "1"},
              child: Column(
                children: <Widget>[
                  divider(20),
                  Column(
                    children: getFields(widget.city, widget.postType),
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

  List<Widget> getFields(String userType, String shopType) {
    List<Widget> list = new List<Widget>();
    if (widget.postType == "1" ||
        widget.postType == "2" ||
        widget.postType == "3" ||
        widget.postType == "4" ||
        widget.postType == "5" ||
        widget.postType == "6" ||
        widget.postType == "8" ||
        widget.postType == "9" ||
        widget.postType == "10") {
      list.add(buildImageButton());
      list.add(buildGridView());
      list.add(divider(20));

      list.add(getCarModel(_adInfo, null));
      list.add(BlocBuilder<ContactUsBlocBloc, ContactUsBlocState>(
        bloc: cbloc,
        builder: (context, state) {
          if (state is MakesLoaded) {
            var value;
            if (state.makes.containsKey(_adInfo["model_id"]))
              value = _adInfo["model_id"];
            else
              value = null;
            final fields = state.makes;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: DropdownButtonFormField<String>(
                  key: ValueKey(state.makes),
                  isDense: true,
                  value: value,
                  decoration: commonInputDecoration(
                    MaterialCommunityIcons.car,
                    "",
                  ),
                  items: fields.getFields(),
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
      list.add(getYearsDropDown(_adInfo, null));
      // list.add(radio(_adInfo, radioGroup));
      list.add(radioCustom(_adInfo, radioGroup));

      list.add(getDropDown(
        map: _adInfo,
        value: null,
        key: "km_cat",
        hint: Trans.I.late("الكيلومترات"),
        items: kmCats,
        icon: MaterialCommunityIcons.radar,
      ));
      list.add(getTransmissionSpinner(_adInfo, null));
      list.add(getDropDown(
        map: _adInfo,
        value: null,
        key: "color",
        hint: Trans.I.late("اختر اللون"),
        items: colors,
        icon: MaterialCommunityIcons.format_color_fill,
      ));
      list.add(getFuelSpinner(_adInfo, null));
      list.add(getAdDescription(_adInfo, null));

      list.add(getAdPriceField(_adInfo, null));
    } else if (widget.postType == "11" || widget.postType == "12") {
      list.add(buildImageButton());
      list.add(buildGridView());
      list.add(divider(20));
      list.add(getAdTitleField(_adInfo, null, postTypes[widget.postType]));

      list.add(getCarModel(_adInfo, null));
      list.add(getYearsDropDown(_adInfo, null));
      list.add(radio(_adInfo, radioGroup));

      list.add(getAdPriceField(_adInfo, null));
    } else if (widget.postType == "7") {
      list.add(buildImageButton());
      list.add(buildGridView());
      list.add(divider(20));
      list.add(getDropDown(
        map: _adInfo,
        value: null,
        key: "description",
        hint: Trans.I.late("نوع الرقم"),
        items: numberPlateType,
        icon: MaterialCommunityIcons.counter,
      ));
      list.add(getNumberPlateField(_adInfo, null));
      list.add(getAdPriceField(_adInfo, null));
    }

    return list;
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
            Asset asset = images[index];
            return Container(
              height: 308,
              width: 308,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  children: <Widget>[
                    AssetThumb(
                      asset: asset,
                      width: 300,
                      height: 300,
                    ),
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
      if (error == null) _error = 'No Error Dectected';
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
          ],
        ),
      ),
    );
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
            child: (_image == null)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      MaterialCommunityIcons.camera_plus,
                      size: 60,
                      color: yellowAmber,
                    ),
                  )
                : Image.file(_image)));
  }

  Widget uploadButton(String msg) {
    return BlocBuilder<CreateAdBloc, CreateAdState>(
        bloc: uploadBloc,
        builder: (BuildContext context, CreateAdState state) {
          print("state is " + state.toString());
          if (state is LoadingCreateAd)
            return Center(child: CircularProgressIndicator());
          else if (state is SubmittedAd) {
            if (state.response.aZSVR == "success")
              Future.delayed(Duration(milliseconds: 500), () {
                Navigator.pop(context, false);
                navigate(context,
                    AdView(Ads(id: state.response.nEWID.toString()), false));
              });
            else
              Fluttertoast.showToast(
                  msg: Trans.I.late("يرجى التاكد من جميع الحقول"));
            return getSubmitButton();
          } else
            return getSubmitButton();
        });
  }

  Widget getSubmitButton() {
    return InkWell(
      onTap: () {
        if (widget.postType == "1") {
          if (_adInfo.containsKey("make_id") &&
              _adInfo.containsKey("model_id") &&
              _adInfo.containsKey("is_used") &&
              _adInfo.containsKey("km_cat") &&
              _adInfo.containsKey("transmission_type") &&
              _adInfo.containsKey("color") &&
              _adInfo.containsKey("fuel_type") &&
              _adInfo.containsKey("description") &&
              _adInfo.containsKey("price") &&
              images.isNotEmpty) {
            uploadBloc.add(Submit(_adInfo, images));
            return;
          } else
            Fluttertoast.showToast(
                msg: Trans.I
                    .late("يرجى ملئ حميع الحقول و صورة واحدة على الاقل"));
        } else if (widget.postType == "11" || widget.postType == "12") {
          if (_adInfo.containsKey("title") &&
              _adInfo.containsKey("make_id") &&
              _adInfo.containsKey("year") &&
              _adInfo.containsKey("is_used") &&
              _adInfo.containsKey("price") &&
              images.isNotEmpty) {
            uploadBloc.add(Submit(_adInfo, images));
            return;
          } else
            Fluttertoast.showToast(
                msg: Trans.I
                    .late("يرجى ملئ حميع الحقول و صورة واحدة على الاقل"));
        } else if (widget.postType == "7") {
          if (_adInfo.containsKey("description") &&
              _adInfo.containsKey("title") &&
              _adInfo.containsKey("price") &&
              images.isNotEmpty) {
            uploadBloc.add(Submit(_adInfo, images));
            return;
          } else
            Fluttertoast.showToast(
                msg: Trans.I
                    .late("يرجى ملئ حميع الحقول و صورة واحدة على الاقل"));
        }
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
            child: Text("نشر الاعلان"),
          ),
        ),
      ),
    );
  }
}
