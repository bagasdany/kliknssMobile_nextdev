// ignore_for_file: avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';

/// Class Component a Item? Discount Card
class motorItem extends StatelessWidget {
  final dynamic item;

  double xOffset = 0;
  Offset offset = Offset.zero;
  double yOffset = 0;

  motorItem(this.item, {Key? key}) : super(key: key);

  String _motorPrice(price) {
    return ((price / 1000000) as double)
        .toStringAsFixed(1)
        .replaceAll(RegExp(r'\.0'), '');
  }

  @override
  Widget build(BuildContext context) {
    String defaultcolor = "#BC4747";
    String getcolor = item?['tag'] != null
        ? item['tag']!['color']!.replaceAll('#', '0xff')
        : defaultcolor.replaceAll('#', '0xff');
    var color = int.parse(getcolor);
    String imageSrc = item?['imageUrl'] ??
        'https://i.pinimg.com/564x/b8/b8/f7/b8b8f787c454cf1ded2d9d870707ed96.jpg';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("/motor/${item['id']}");
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
                badgeSize: const Size(64, 64),
              )
            : RotatedCornerDecoration.withColor(
                color: Color(color), badgeSize: const Size(1, 1),
                // geometry: const BadgeGeometry(width: 1, height: 1),
              ),
        decoration: BoxDecoration(
            // color: Constants.amber,
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF656565).withOpacity(0.15),
                blurRadius: 2.0,
                spreadRadius: 1.0,
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
                  AspectRatio(
                    aspectRatio: 1 / 1,
                    child: CachedNetworkImage(
                        imageUrl: imageSrc,
                        fit: BoxFit.contain,
                        imageBuilder: (context, imageProvider) => AspectRatio(
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
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: Constants.spacing1),
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
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: Constants.spacing1,
                                    bottom: Constants.spacing2),
                                child: Text(
                                  item?['name'] ?? "",
                                  style: const TextStyle(
                                    height: 1,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Constants.fontSizeMd),
                                  maxLines: 1,
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
                                  top: Constants.spacing1,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: Text(
                                      ("OTR mulai dari"),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Constants.gray.shade500,
                                          // fontWeight: FontWeight.w500,
                                          fontSize: Constants.fontSizeXs),
                                    )),
                                    Text(
                                      item['price'] != null
                                          ? "${_motorPrice(item['price'])}jt"
                                          : '-',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Constants.blackText,
                                          fontSize: Constants.fontSizeXl),
                                    ),
                                  ],
                                ),
                              ),
                              item['priceNormal'] == null || item['discountPercentage']? Container():
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: Constants.spacing1),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Text(
                                      item['priceNormal'] != null
                                          ? '${_motorPrice(item['priceNormal'])}jt'
                                          : '',
                                      style: const TextStyle(
                                        height: 1,
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
                              item['reviewRate'] == null ? Container():
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
                                              fontSize: Constants.fontSizeXs),
                                        ),
                                        const SizedBox(
                                          width: Constants.spacing2,
                                        ),
                                        Text(
                                          item['qtySold'] != null
                                              ? "Terjual ${item['qtySold']}"
                                              : "",
                                          style: const TextStyle(
                                              fontSize: Constants.fontSizeXs),
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
