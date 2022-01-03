import 'package:da3afes/models/ProfileResponse.dart';
import 'package:da3afes/screens/PaymentScreen.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../consts.dart';

class WalletScreen extends StatefulWidget {
  ProfileResponse response;
  WalletScreen(this.response);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    String credit = widget.response.profile[0].credit;
    return Scaffold(
      appBar: defaultAppBar(Trans.I.late("محفظتي")),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          appLogo,
          divider(20),
          iconResizeCustom("coin.png", 90),
          Text(
            Trans.I.late("لديك $credit دينار"),
            style: Theme.of(context).textTheme.headline5,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: TextDirection.rtl,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: roundedDecoration,
                    child: InkWell(
                      onTap: () => navigate(context, PaymentScreen()),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              Trans.I.late("شراء رصيد"),
                              style: TextStyle(
                                  color: yellowAmber,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              MaterialCommunityIcons.coin,
                              color: yellowAmber,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: roundedDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            Trans.I.late("بروموكود"),
                            style: TextStyle(
                                color: yellowAmber,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            MaterialCommunityIcons.tag_text_outline,
                            color: yellowAmber,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          divider(30),
          headline("التعاملات المالية")
        ],
      )),
    );
  }

  Container headline(String text) {
    return Container(
      color: lightGrey2,
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
      )),
    );
  }
}
