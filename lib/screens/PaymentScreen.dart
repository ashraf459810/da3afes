import 'package:da3afes/consts.dart';
import 'package:da3afes/models/CreditOffersResponse.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var dio = Dio();
  CreditOffers selectedOffer;
  String paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("الدفع"),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          child: FutureBuilder<List<CreditOffers>>(
              future: getOffers(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data.toList();
                  List<Widget> children = [];
                  for (var value in snapshot.data) {
                    if (value.active != "0") {
                      children.add(cover(text(value.text), value));
                    } else
                      data.remove(value);
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        appLogo,
                        Center(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: WheelChooser.custom(
                              listWidth: 200,
                              listHeight: 180,
                              datas: data,
                              startPosition: 0,
                              onValueChanged: (a) => setState(() {
                                selectedOffer = a;
                              }),
                              children: children,
                            ),
                          ),
                        ),
                        (selectedOffer != null)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: yellowAmber, width: 1)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        selectedOffer.amount.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    Trans.I.late("سعر الحزمة المختارة"),
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                ],
                              )
                            : Container(),
                        divider(10),
                        Center(
                            child: Text(
                          Trans.I.late("الدفع عن طريق"),
                          style: Theme.of(context).textTheme.headline5,
                        )),
                        divider(10),
                        Container(
                          width: 300,
                          child: Wrap(
                              runSpacing: 0,
                              spacing: 10,
                              textDirection: TextDirection.rtl,
                              alignment: WrapAlignment.center,
                              children: List.generate(payment_methods.length,
                                  (index) {
                                return InkWell(
                                  onTap: () {
                                    if (index < 2) {
                                      if (selectedOffer != null) {
                                        if (index == 0) {
                                          paymentMethod = "zain_cash";
                                        } else {
                                          paymentMethod =
                                              Trans.I.late("فاست باي");
                                        }
                                        String id = selectedOffer.id;
                                        String token = "";
                                        String url =
                                            "http://daafees.com/main/process.php?cmd=CreateInvoice&payment_method=$paymentMethod&credit_offers=$id";
                                        print(url);
                                        navigate(
                                            context,
                                            new WebviewScaffold(
                                              url: url,
                                              appBar: new AppBar(
                                                title: const Text(
                                                    'Payment Transaciton'),
                                              ),
                                              withZoom: false,
                                              withJavascript: true,
                                              withLocalStorage: true,
                                              hidden: false,
                                            ));
                                        setState(() {});
                                      } else
                                        Fluttertoast.showToast(
                                            msg: Trans.I
                                                .late("يرجى اختيار المبلغ"));
                                    }
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 80,
                                    child: Image.asset(
                                      "images/" +
                                          payment_methods[payment_methods.keys
                                              .toList()[index]],
                                      width: 120,
                                      height: 80,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                );
                              })),
                        ),
                      ],
                    ),
                  );
                } else
                  return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }

  Widget text(String msg) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 16),
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: iconResizeCustom("coin.png", 25),
            ),
          ),
          TextSpan(text: msg),
        ],
      ),
    );
  }

  Widget cover(Widget data, CreditOffers offer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        line(),
        divider(10),
        Container(
          child: Center(child: data),
        ),
        divider(10),
        line(),
      ],
    );
  }

  Container line() {
    return Container(
      color: grey,
      height: 0.5,
    );
  }

  Future<List<CreditOffers>> getOffers() async {
    final response = await dio
        .get('http://daafees.com/main/api/api.php?cmd=GetCreditOffers');
    String co = response.data.toString();
    // print(co);

    var list = await response.data as List;

    print(list.length.toString());

    List<CreditOffers> data =
        list.map((e) => CreditOffers.fromJson(e)).toList();

    return data;
  }
}
