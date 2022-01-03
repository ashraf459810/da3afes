import 'dart:io';

import 'package:apple_sign_in/apple_id_credential.dart';
import 'package:da3afes/blocs/bloc.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/utils/LocationPicker.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UserRegisterScreen extends StatefulWidget {
  String userType = "";
  String shopType = "";
  AuthBloc authBloc;
  AppleIdCredential credential;

  UserRegisterScreen(
      this.userType, this.shopType, this.authBloc, this.credential);

  @override
  State<StatefulWidget> createState() {
    return UserRegisterScreenState();
  }
}

class UserRegisterScreenState extends State<UserRegisterScreen> {
  File _image;
  final _fbKey = GlobalKey<FormBuilderState>();
  ImageUploadBloc uploadBloc;
  String userType;
  String title;
  LatLng location;
  String email;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      print("image updated");
      _image = image;
    });
  }

  @override
  void initState() {
    userType = widget.userType;
    uploadBloc = ImageUploadBloc();
    if (widget.credential == null) {
      email = "";
    } else {
      email = widget.credential.email ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userType == "3")
      title = serviceTypes[widget.shopType];
    else
      title = userTypes[userType];
    return Scaffold(
      appBar: defaultAppBar("انشاء حساب $title"),
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
                        width: 60,
                        height: 60,
                        child: (_image == null)
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: yellowAmber)),
                                child: Icon(
                                  Entypo.camera,
                                  color: yellowAmber,
                                  size: 50,
                                ))
                            : Image.file(_image))),
                FormBuilder(
                  key: _fbKey,
                  initialValue: {"email": email},
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: getFields(widget.userType, widget.shopType),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            BlocConsumer<ImageUploadBloc, ImageUploadState>(
                              bloc: uploadBloc,
                              listener: (BuildContext context,
                                  ImageUploadState state) {
                                if (state is UploadedState) {
                                  try {
                                    Fluttertoast.showToast(msg: state.key);
                                  } catch (ee) {}
                                  if (state.key == 'SUCCESS') {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    // Navigator.of(context).pop();
                                    widget.authBloc.add(AuthenticatedEvent());
                                  }
                                }
                              },
                              builder: (BuildContext context,
                                  ImageUploadState state) {
//                        print("state==>" + state.toString());
                                if (state is InitialImageUploadState) {
                                  return uploadButton(null);
                                } else if (state is UploadingState) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is UploadedState) {
                                  if (state.key == 'SUCCESS') {
                                    //   Navigator.of(context).pop();
                                    //   Navigator.of(context).pop();
                                    //   Navigator.of(context).pop();
                                    //   widget.authBloc.add(AuthenticatedEvent());

                                    return uploadButton(state.key);
                                  } else {
                                    return uploadButton(null);
                                  }
                                }
                                return Text(
                                  "unknown",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                );
                              },
//
                            ),
                            userType != "1"
                                ? MaterialButton(
                                    child: Container(
                                      width: 120,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          color: yellowAmber),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            Trans.I.late("اختر الموقع"),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Icon(
                                            Icons.location_on,
                                            color: location == null
                                                ? Colors.white
                                                : Colors.green,
                                          ),
                                        ],
                                      )),
                                    ),
                                    onPressed: () async {
                                      var result =
                                          await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LocationPicker(),
                                        ),
                                      );
                                      setState(() {
                                        location = result;
                                      });
                                      print(result.toString());
                                    },
                                  )
                                : Container(),
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
    if (userType != "1") {
      list.add(divider(10));
      list.add(buildAddressField());
      list.add(divider(10));
      list.add(getStateSpinner());
    }

    list.add(divider(10));
    list.add(buildPhoneField());
    list.add(divider(10));
    list.add(buildPasswordField());
    if (userType == "1") {
      list.add(divider(10));
      list.add(buildGenderField());
      list.add(divider(10));
      list.add(buildBirthDate());
    }

    return list;
  }

  InkWell uploadButton(String msg) {
    return InkWell(
      onTap: () {
        if (_fbKey.currentState.saveAndValidate()) {
//          _image.path ?? print(_image.path);
          var values = _fbKey.currentState.value;
          values["user_type"] = widget.userType;
          values["service_type"] = widget.shopType;
          if (widget.credential != null)
            values["apple_id"] = widget.credential.user;
          if (location != null)
            values["location"] = location.latitude.toString() +
                "," +
                location.longitude.toString();
          print(values);
          // uploadBloc.add(UploadImageEvent(_image, values));

          if (widget.userType == "2" || widget.userType == "3") {
            if (values.containsKey("phone") && values.containsKey("location")) {
              uploadBloc.add(UploadImageEvent(_image, values));
              return;
            } else
              Fluttertoast.showToast(msg: Trans.I.late("يرجى ملئ حميع الحقول"));
          } else
            uploadBloc.add(UploadImageEvent(_image, values));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Colors.green),
          child: Center(
            child: Text(
              Trans.I.late("انشاء الحساب"),
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
