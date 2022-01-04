import 'package:da3afes/consts.dart';
import 'package:da3afes/utils/Trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class VideoCategoriesScreen extends StatelessWidget {
  List<List<String>> videoCategories = [
    [
      Trans.I.late("تعديل السيارات"),
      "12wsa.png",
      "https://youtube.com/playlist?list=PLgI7NsbS_lXeX_cZ_2tEeYcGiJ4ezH0MF"
    ],
    [
      Trans.I.late("تزويد السيارات"),
      "129.png",
      "https://youtube.com/playlist?list=PLgI7NsbS_lXd8QtshyYe-4cytw2W6-QEr"
    ],
    [
      Trans.I.late("تجارب الاداء"),
      "12345d.png",
      "https://youtube.com/playlist?list=PLgI7NsbS_lXcStHidESq1Xf67EyydFd0u"
    ],
    [
      Trans.I.late("اعادة تأهيل سيارات الكلاسك"),
      "129.png",
      "https://youtube.com/playlist?list=PLgI7NsbS_lXeX_cZ_2tEeYcGiJ4ezH0MF"
    ],
    [
      Trans.I.late("اكتشاف الاعطال"),
      "1234567y.png",
      "https://www.youtube.com/playlist?list=PLgI7NsbS_lXfWEJ1eyLTByvlo9CqiJ04v"
    ],
    [
      Trans.I.late("قوانين السياقة"),
      "12wsde.png",
      "https://youtube.com/playlist?list=PLgI7NsbS_lXeVM93Akk2P-q-A_uDmDKod"
    ],
    [
      Trans.I.late("اختبار المتانة"),
      "12sa.png",
      "https://youtube.com/playlist?list=PLgI7NsbS_lXd1fIrpSa_aYovzyLw6jOjS"
    ],
    [
      Trans.I.late("اغرب حوادث السيارات"),
      "w1234.png",
      "https://youtube.com/playlist?list=PLgI7NsbS_lXea-jpgjoptovIJRfQ6BIia"
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SafeArea(
        child: Container(
          decoration: appBackground,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                divider(10),
                GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: videoCategories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 1.5),
                    itemBuilder: (BuildContext context, int index) {
                      return VideoCategoryCard(
                          videoCategories[index][0],
                          videoCategories[index][1],
                          videoCategories[index][2],
                          context);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget VideoCategoryCard(
      String text, String img, String link, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          navigate(
              context,
              new WebviewScaffold(
                url: link,
                appBar: new AppBar(
                  backgroundColor: yellowAmber,
                  title: Text(text),
                ),
                withZoom: false,
                withJavascript: true,
                withLocalStorage: true,
                hidden: false,
              ));
        },
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          elevation: 5,
          child: Container(
            child: Stack(
              children: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Opacity(
                    child: Image.asset("images/" + img),
                    opacity: 0.2,
                  ),
                )),
                Center(
                    child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
