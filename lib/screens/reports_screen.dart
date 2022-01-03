import 'package:flutter/material.dart';

import '../consts.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: commonInputDecoration(Icons.translate, ""),
                    items: [
                      DropdownMenuItem<String>(
                        value: "1",
                        child: Text(
                          "First",
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: "2",
                        child: Text(
                          "Second",
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      print("value: $value");
                    },
                    hint: Text(
                      "Please select the number!",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
