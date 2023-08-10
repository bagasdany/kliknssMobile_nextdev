// ignore_for_file: avoid_unnecessary_containers

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/app_shimmer.dart';
import 'package:kliknss77/ui/shimmer/banner_shimmer.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:intl/intl.dart' as intl;

class FlashSaleItem extends StatelessWidget {
  final dynamic item;
  int? index;
  dynamic uid, state;
  dynamic expand, aspectRatio;

  double xOffset = 0;
  Offset offset = Offset.zero;
  double yOffset = 0;

  final formatter = intl.NumberFormat.decimalPattern();

  FlashSaleItem(
      this.item, this.index, this.uid, this.state, this.aspectRatio,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String defaultcolor = "#BC4747";
    String getcolor = item != null
        ? item['tag'] != null
            ? item['tag']!['color']!.replaceAll('#', '0xff')
            : defaultcolor.replaceAll('#', '0xff')
        : defaultcolor.replaceAll('#', '0xff');
    var color = int.parse(getcolor);
    double? prosentase = item['qty'] == 0 ? 0: (int.parse((item['qty'].toString())) - (item?['remainingQty'] < 0 ? 0 :    int.parse((item['remainingQty'].toString()))) ) /
        (int.parse((item['qty'].toString()))).round();
    int? selisih = item['priceNormal'] != null
        ? (int.parse((item['priceNormal'].toString())) -
            int.parse((item['price'].toString()))).round()
        : 1;
    int diskon = item['priceNormal'] != null
        ? (((selisih ?? 1) /
            int.parse((item['priceNormal'].toString()))) * 100).round()
        : 0;
    String imageSrc = item != null
        // ignore: prefer_if_null_operators
        ? item['imageUrl'] != null
            ? item['imageUrl']
            : ''
        : '';

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/sparepart/${item['id']}?uid=${uid}");
      },
      child: Container(

      margin:const EdgeInsets.symmetric(vertical: Constants.spacing2),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(Constants.spacing2),
                ),
                
                // color: item?['remainingQty']< 1
                //                   ? Constants.gray : Colors.transparent,
              ),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(

            
            padding:  EdgeInsets.symmetric(vertical: item?['remainingQty']< 1
                                ? 0: 0),
            foregroundDecoration: item?['tag'] != null
                ? RotatedCornerDecoration.withColor(
                    color: Color(color),
                    textSpan: TextSpan(
                      text: item?['tag']['text'],
                      style: const TextStyle(
                          fontSize: Constants.fontSizeXs,
                          overflow: TextOverflow.ellipsis),
                    ),
                    badgeSize: const Size(40, 40),
                  )
                : RotatedCornerDecoration.withColor(
                    color: Color(color),
                    badgeSize: const Size(1, 1),
                  ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(Constants.spacing2),
                ),
                border: Border.all(color: Constants.gray.shade200),
                color: Constants.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  imageSrc == null || imageSrc == ""
                      ? Container()
                      : Row(
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: AppShimmer(
                                  active: state == 2,
                                  child: CachedNetworkImage(
                                    imageUrl: imageSrc,
                                    fit: BoxFit.cover,
                                    imageBuilder: (context, imageProvider) =>
                                        AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(
                                                Constants.spacing2),
                                            topLeft: Radius.circular(
                                                Constants.spacing2),
                                          ),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                    progressIndicatorBuilder:
                                        (context, url, progress) => BannerShimmer(aspectRatio: 1 / 1),
                                    errorWidget: (context, url, error) =>
                                        AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Constants.gray.shade300,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(Constants.spacing3,
                              Constants.spacing1, Constants.spacing3, 0),
                          padding: EdgeInsets.zero,
                          child: Text(
                            item?['name'] ?? "",
                            style:
                                const TextStyle(fontSize: Constants.fontSizeMd),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(Constants.spacing3,
                              Constants.spacing1, Constants.spacing3, 0),
                          child: Text(
                            item?['price'] != null
                                ? 'Rp. ${formatter.format((int.parse(item?['price'].toString() ?? "0")))}'
                                : '',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Constants.black,
                                fontSize: Constants.fontSizeLg),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.zero,
                          margin: const EdgeInsets.fromLTRB(
                              Constants.spacing3, 1, 0, Constants.spacing1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              diskon == null
                                  ? Container()
                                  :   Container(
                                    margin: const EdgeInsets.only(right: Constants.spacing1),
                                      padding: const EdgeInsets.all(
                                          Constants.spacing1),
                                      decoration: BoxDecoration(
                                          color: Constants.primaryColor.shade100
                                              ,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5.0))),
                                      child: Center(
                                          child: Text(
                                        ("${(diskon ?? "")}%" ?? "").toString(),
                                        style: const TextStyle(
                                          color: Constants.primaryColor
                                             ,
                                          fontSize: Constants.fontSizeXs,
                                          fontFamily: Constants.primaryFontBold,
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                    ),
                              Container(
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.only(
                                      left: item?['discountPercentage'] == null
                                          ? 0
                                          : Constants.spacing1),
                                  child: Text(
                                    item?['priceNormal'] != null
                                        ? 'Rp. ${formatter.format(item['priceNormal'])}'
                                        : '',
                                    style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: Constants.fontSizeSm,
                                        color: Constants.gray),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.zero,
                          child: LinearPercentIndicator(
                            animation: true,
                            percent: prosentase == 0 ? 0.1 : prosentase > 1 ? 0.1 : prosentase,
                            progressColor: item?['remainingQty']< 1
                                ? Constants.primaryColor
                                : Constants.primaryColor,
                                backgroundColor: Constants.primaryColor.shade100,
                            lineHeight: 7,
                          ),
                        ),
                        Container(
                                padding: EdgeInsets.zero,
                                margin: const EdgeInsets.fromLTRB(
                                    Constants.spacing2,
                                    Constants.spacing1,
                                    Constants.spacing3,
                                    0),
                                child: item?['remainingQty'] < 1
                                    ? const Text(
                                        "Stock Habis",
                                        style: TextStyle(
                                          fontSize: Constants.fontSizeSm,
                                        ),
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : Text(
                                       prosentase > 0.8 ? "Segera Habis" : "Tersedia",
                                        // "Sisa ${item?['remainingQty'] ?? 0}" ??
                                        //     "Buruan checkout..",
                                        style: const TextStyle(
                                          fontSize: Constants.fontSizeSm,
                                        ),
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
