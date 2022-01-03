import 'package:da3afes/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CompanyRegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CompanyRegisterScreenState();
  }
}

class CompanyRegisterScreenState extends State<CompanyRegisterScreen> {
  final _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("amr"),
      ),
      body: Container(
        decoration: appBackground,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(""),
        ),
      ),
    );
  }
}
