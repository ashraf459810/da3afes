import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:da3afes/consts.dart';
import 'package:da3afes/models/HomeResponse.dart';
import 'package:da3afes/screens/ad_screen.dart';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget getAdsGridItem(Ads ad, String imglink, BuildContext context) {
  var price = ad.price;
  return FractionallySizedBox(
    widthFactor: 1,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      elevation: 8.0,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              AspectRatio(
                child: Image.network(
                  "" + imglink,
                  fit: BoxFit.cover,
                  // loadStateChanged: (ExtendedImageState state) {
                  //   if (state.extendedImageLoadState == LoadState.failed) {
                  //     return Image(image: AssetImage("images/background.png"));
                  //   }
                  //   return null;
                  // },
                ),
                aspectRatio: 16 / 11,
              ),
              (ad.comments.commentsCount == 0)
                  ? Container()
                  : Positioned(
                      top: -8,
                      left: -28,
                      child: Transform.rotate(
                        angle: -math.pi / 4,
                        origin: Offset(-1, 0),
                        child: Container(
                          color: yellowAmber,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 19.0, right: 29, left: 29, bottom: 9),
                            child: Shimmer.fromColors(
                              baseColor: Colors.white,
                              highlightColor: Colors.black12,
                              child: Text(
                                "مميز",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: 35.0,
                          height: 35.0,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: yellowAmber, width: 1),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60.0),
                                child: CachedNetworkImage(
                                  //TEMPORARY PLACEHOLDER
                                  imageUrl: (ppImgDir + ad.userProfilePicture),
                                  fit: BoxFit.cover,
                                  width: 32,
                                  height: 32,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              (ad.title.isNotEmpty)
                                  ? ad.title
                                  : (ad.makeText ?? "") +
                                      " " +
                                      (ad.modelText ?? "") +
                                      " " +
                                      (ad.year ?? ""),
                              maxLines: 1,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    divider(5),
                    Text((ad.makeText ?? "") + " - " + (ad.year ?? "")),
                    divider(5),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(ad.cityText ?? ""),
                    ),
                    divider(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        futureWishlistWidget(ad.id),
//                        Icon(
//                          Icons.star_border,
//                          size: 30,
//                        ),
                        Expanded(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              (ad.price != null ? "$price دينار " : ""),
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget getAdsListItem(BuildContext context, Ads ads, {Widget widget = null}) {
  var price = ads.price;

  return InkWell(
    onTap: () {
      navigate(context, AdView(ads, false));
    },
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 3,
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
//                mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            ads.title,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text((ads.condition ?? "") +
                              " - " +
                              (ads.catText ?? "")),
                          Text(ads.cityText ?? ""),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              callButton(ads.userPhone),
                              Flexible(
                                fit: FlexFit.tight,
                                child: SizedBox(),
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  (ads.price != null ? "$price دينار " : ""),
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: CachedNetworkImage(
                      imageUrl: (adImgDir + ads.images),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ],
              ),
              widget ?? Container(),
            ],
          ),
        ),
      ),
    ),
  );
}
