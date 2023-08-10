// ignore_for_file: avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:intl/intl.dart' as intl;

/*
NOTES // 
      // qty kosong = tidak ada response qty ?

"sections": [
        "type": "SparepartList",
            "title": "DISKON SPESIAL RAMADHAN ! UP TO 25%!!",
            "description": "TOP BEST SELLER!!",
            "items": [
                {
                  //Response API per 4 oktober 2022
                    "thumbnailType": "sparepart",
                    "id": 40761,
                    "brand": "",
                    "name": "Baut (Screw Tapping 4X12) ADV 150, BeAT eSP K81, Scoopy eSP",
                    "imageUrl": "https://www.kliknss.co.id/images/thumbs/3e9f1f80c02f63a2b3916a2387754209.jpg",
                    "price": 3000,
                    "target": "/sparepart/40761;/9390334380-baut-(screw-tapping-4x12)-adv-150-beat-esp-k81-scoopy-esp",
                    "reviewRate": 4.9
                },
  #handle nullable with Container() // != emptyWidget
*/

// TODO : Api response untuk dibawah ini masih kosong
/*
    // item['brand'] = "*AHM";
    // item['qtySold'] = 995;
    // item['qty'] = 0;
*/
/// Class Component a Item? Discount Card
class SparepartItemComponent extends StatelessWidget {
  final dynamic item;

  double xOffset = 0;
  dynamic expand;
  Offset offset = Offset.zero;
  double yOffset = 0;

  final formatter = intl.NumberFormat.decimalPattern();

  SparepartItemComponent(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String defaultcolor = "#BC4747";
    String getcolor = item?['tag'] != null
        ? item['tag']!['color']!.replaceAll('#', '0xff')
        : defaultcolor.replaceAll('#', '0xff');
    var color = int.parse(getcolor);
    String imageSrc = item != null
        // ignore: prefer_if_null_operators
        ? item['imageUrl'] != null
            ? item['imageUrl']
            : item['defaultImageUrl'] != null
                ? item['defaultImageUrl']
                : 'https://i.pinimg.com/564x/b8/b8/f7/b8b8f787c454cf1ded2d9d870707ed96.jpg'
        : 'https://i.pinimg.com/564x/b8/b8/f7/b8b8f787c454cf1ded2d9d870707ed96.jpg';

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/sparepart/${item['id']}");
      },
      child: Container(
        foregroundDecoration: item?['tag'] != null
            ? RotatedCornerDecoration.withColor(
                color: Color(color),
                // geometry: const BadgeGeometry(width: 40, height: 40),
                // ignore: unnecessary_const
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
                // geometry: const BadgeGeometry(width: 1, height: 1),
                badgeSize: const Size(1, 1),
              ),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF656565).withOpacity(0.15),
                blurRadius: 2.0,
                spreadRadius: 1.0,
                //           offset: Offset(4.0, 10.0)
              )
            ]),
        child: Wrap(
          children: <Widget>[
            Container(
              color: Constants.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //
                  AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        CachedNetworkImage(
                            imageUrl: imageSrc,
                            fit: BoxFit.contain,
                            imageBuilder: (context, imageProvider) =>
                                AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Constants.white,
                                      // shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                                ),
                            errorWidget: (context, url, error) => AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Constants.gray.shade300,
                                  ),
                                ))),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.spacing2,
                                vertical: Constants.spacing1),
                            color: item.containsKey("qty")
                                ? Colors.transparent
                                : Constants.black.withOpacity(0.8),
                            margin: const EdgeInsets.fromLTRB(
                                Constants.spacing3, 0, 0, Constants.spacing1),
                            child: Text(
                              item.containsKey("qty") ? "" : "Stock Kosong",
                              style: const TextStyle(
                                  color: Constants.white,
                                  fontSize: Constants.fontSizeXs),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: Constants.spacing3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: Constants.spacing3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  item?['brand'] ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: Constants.fontSizeXs),
                                ),
                                margin: const EdgeInsets.fromLTRB(
                                    0, 0, 0, Constants.spacing1),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    bottom: Constants.spacing1),
                                child: Text(
                                  item?['name'] ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Constants.fontSizeMd),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: Constants.spacing3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: Constants.spacing2,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: Text(
                                      ("Harga"),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Constants.gray.shade500,
                                          // fontWeight: FontWeight.w500,
                                          fontSize: Constants.fontSizeXs),
                                    )),
                                    Container(
                                      child: Text(
                                        // item['price'] != null
                                        //     ? "${_motorPrice(item['price'])}jt"
                                        //     : '-',
                                        item['price'] != null
                                            ? 'Rp. ${formatter.format(item['price'])}'
                                            : '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Constants.primaryColor,
                                            fontSize: Constants.fontSizeLg),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: Constants.spacing1),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Text(
                                      // item['priceNormal'] != null
                                      //     ? '${_motorPrice(item['priceNormal'])}jt'
                                      //     : '',
                                      item['priceNormal'] != null
                                          ? 'Rp. ${formatter.format(item['priceNormal'])}'
                                          : '',
                                      style: const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: Constants.fontSizeSm),
                                    )),
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: Constants.spacing1),
                                      decoration: BoxDecoration(
                                          color:
                                              item['discountPercentage'] != null
                                                  ? Constants.lime
                                                  : Colors.transparent,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5.0))),
                                      child: Center(
                                          child: Text(
                                        item['discountPercentage'] != null
                                            ? "${item['discountPercentage']}%"
                                            : '',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: Constants.fontSizeXs),
                                        textAlign: TextAlign.center,
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: Constants.spacing2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          color: item['reviewRate'] != null
                                              ? const Color.fromARGB(
                                                  255, 255, 196, 0)
                                              : Colors.transparent,
                                          size: 14.0,
                                        ),
                                        Text(
                                          "${item['reviewRate'] ?? ''}",
                                          style: const TextStyle(
                                              // color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11),
                                        ),
                                        const SizedBox(
                                          width: Constants.spacing2,
                                        ),
                                        Text(
                                          item['qtySold'] != null
                                              ? "Terjual ${item['qtySold']}"
                                              : "",
                                          style: const TextStyle(
                                            // color: Colors.white,
                                            fontSize: 12,
                                            // fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
