import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:da3afes/blocs/bloc.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/models/ProfileResponse.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  Profile profile;

  EditProfileScreen(this.profile);

  @override
  State<StatefulWidget> createState() {
    return EditProfileScreenState();
  }
}

class EditProfileScreenState extends State<EditProfileScreen> {
  String userType, shopType;
  File _image;
  final _fbKey = GlobalKey<FormBuilderState>();
  ImageUploadBloc uploadBloc;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      print("image updated");
      _image = image;
    });
  }

  @override
  void initState() {
    shopType = widget.profile.serviceType;
    userType = widget.profile.userType;
    uploadBloc = ImageUploadBloc();
  }

  @override
  Widget build(BuildContext context) {
    var json = widget.profile.toJson();
    if (widget.profile.cityId == "0") {
      json.remove('city_id');
    }
    return Scaffold(
      appBar: defaultAppBar("تعديل المعلومات"),
      body: Container(
        decoration: appBackground,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
          ),
          child: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                new FlatButton(
                    onPressed: () {
                      getImage();
                    },
                    child: SizedBox(
                      width: 120.0,
                      child: getProfileImage(),
                    )),
                FormBuilder(
                  initialValue: json,
                  key: _fbKey,
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: getFields(userType, shopType),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            BlocBuilder<ImageUploadBloc, ImageUploadState>(
                              bloc: uploadBloc,
                              builder: (BuildContext context,
                                  ImageUploadState state) {
                                if (state is InitialImageUploadState) {
                                  return uploadButton(null);
                                } else if (state is UploadingState) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is UploadedState) {
                                  try {
                                    if (state.key == "SUCCESS" ||
                                        state.key == "success") {
                                      Fluttertoast.showToast(
                                          msg: Trans.I
                                              .late("تم تحديث البيانات"));
                                      Navigator.pop(context, true);
                                      return uploadButton(state.key);
                                    } else
                                      Fluttertoast.showToast(msg: state.key);
                                  } catch (ee) {}
                                }

                                return Text(
                                  "unknown",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                );
                              },
//
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }

  Widget getProfileImage() {
    if (widget.profile.image.isNotEmpty && _image == null) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: yellowAmber, width: 2),
          borderRadius: BorderRadius.circular(60),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60.0),
            child: CachedNetworkImage(
              imageUrl: ppImgDir.toString() + widget.profile.image.toString(),
              fit: BoxFit.cover,
              width: 110,
              height: 110,
            ),
          ),
        ),
      );
    } else {
      (_image == null)
          ? Image.asset("images/add_image.png")
          : Image.file(_image);
    }
  }

  List<Widget> getFields(String userType, String shopType) {
    List<Widget> list = new List<Widget>();

    if (userType == "1")
      list.add(buildFullNameField());
    else if (userType == "2")
      list.add(buildShopNameField("شركة"));
    else
      list.add(buildShopNameField(userTypes[userType]));

    if (userType == "2") {
      list.add(buildCustomField(
          "wk_original_company", Trans.I.late("اسم شركة الوكالة التابعة لها")));
      list.add(buildCustomField("wk_customer_service_number",
          Trans.I.late("رقم الهاتف الخاص بخدمة العملاء"),
          type: TextInputType.number));
      list.add(buildCustomField("wk_phone2", Trans.I.late("رقم الهاتف الثاني"),
          type: TextInputType.number));
      list.add(buildCustomField(
          "wk_website", Trans.I.late("الموقع الالكتروني الخاص بالشركة")));
    }

    list.add(divider(10));
    list.add(buildEmailField());
    print(userType);
    if (userType != "1") {
      list.add(divider(10));
      list.add(buildAddressField());
    }
    list.add(divider(10));
    print(widget.profile.toJson().toString());

    list.add(getStateSpinner());
    list.add(divider(10));
    list.add(buildPhoneField());
    list.add(divider(10));
//    list.add(buildPasswordField());
//    if (userType == "1") {
//      list.add(divider(10));
//      list.add(buildGenderField());
//      list.add(divider(10));
////      list.add(buildBirthDate());
//    }

    return list;
  }

  InkWell uploadButton(String msg) {
    return InkWell(
      onTap: () {
        if (_fbKey.currentState.saveAndValidate()) {
//          _image.path ?? print(_image.path);
          var values = _fbKey.currentState.value;

          print(values);

          uploadBloc.add(ProfileEditEvent(_image, values));
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
            child: Text("حفظ التغييرات"),
          ),
        ),
      ),
    );
  }
}
