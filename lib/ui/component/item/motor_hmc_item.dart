import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/shimmer/banner_shimmer.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:intl/intl.dart' as intl;

class motorHmcItem extends StatelessWidget {
  dynamic item;
  String? nameCategory;
  dynamic mobileImageUrl;
  motorHmcItem(this.item, this.nameCategory, this.mobileImageUrl, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat.decimalPattern();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          mobileImageUrl == null || mobileImageUrl == []
              ? Container()
              : AspectRatio(
                  aspectRatio: 800 / 130,
                  child: 
                  mobileImageUrl[0] == null || mobileImageUrl[0] == "" ? Container():
                  CachedNetworkImage(
                      imageUrl: "${Constants.baseURLImages}/${ mobileImageUrl[0].toString()}" ??
                          "https://www.kliknss.co.id/images/logo2210253.png",
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) => AspectRatio(
                            aspectRatio: 800 / 130,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Constants.white,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.contain),
                              ),
                            ),
                          ),
                      placeholder: (context, url) => BannerShimmer(
                            aspectRatio: 800 / 130,
                          ),
                      errorWidget: (context, url, error) => AspectRatio(
                          aspectRatio: 800 / 130,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Constants.gray.shade300,
                            ),
                          ))),
                ),
          ListView.builder(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: item.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context)
                        .pushNamed("/motor/${item?[index]?['id'] ?? 74}");
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 2),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: item?[index]?['reviewRate'] == null &&
                                        item?[index]?['qtySold'] == null &&
                                        item?[index]?['discountPercentage'] ==
                                            null &&
                                        item?[index]?['priceNormal'] == null
                                    ? Constants.spacing1
                                    : item?[index]?['reviewRate'] == null &&
                                            item?[index]?['qtySold'] == null
                                        ? Constants.spacing2
                                        : item?[index]?['discountPercentage'] ==
                                                    null &&
                                                item?[index]?['priceNormal'] ==
                                                    null
                                            ? Constants.spacing2
                                            : Constants.spacing4,
                                horizontal: Constants.spacing4),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Constants.white,
                            ),
                            foregroundDecoration: item?[index]?['tag'] != null
                                ? RotatedCornerDecoration.withColor(
                                    // String getcolor = item?['tag'] != null
                                    //     ? item?['tag']!.color!.replaceAll('#', '0xff')
                                    //     : defaultcolor.replaceAll('#', '0xff');
                                    color: Color(
                                        item?[index]?['tag']!['color'] != null
                                            ? int.parse(item?[index]
                                                    ?['tag']!['color']!
                                                .replaceAll('#', '0xff'))
                                            : int.parse("0xffffff")),
                                    // color: Color(item?[index]?['tag']!.color),
                                    // geometry: const BadgeGeometry(
                                    //     width: 94, height: 44),
                                    // ignore: unnecessary_const
                                    textSpan: TextSpan(
                                      text: item?[index]?['tag'] != null
                                          ? item[index]['tag']['text']
                                              .toString()
                                          : "",
                                      // text: TextSpan(text: ' world!'),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        // textBaseline: ,
                                        overflow: TextOverflow.ellipsis,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              blurRadius: 2)
                                        ],
                                      ),
                                    ),
                                    badgeSize: const Size(94, 44),
                                  )
                                : const RotatedCornerDecoration.withColor(
                                    color: Constants.primaryColor,
                                    badgeSize: Size(1, 1),
                                    // geometry:
                                    //     BadgeGeometry(width: 1, height: 1),
                                  ),
                            child: Wrap(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            "/motor/${item?[index]?['id'] ?? 74}");
                                      },
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .4,
                                        child: 
                                        item?[index]?['imageUrl'] == null || item?[index]?['imageUrl'] == "" ? Container():
                                        CachedNetworkImage(
                                            fit: BoxFit.contain,
                                            //test
                                            imageUrl:
                                                // widget.kendaraansaya?['imageUrl'] ?? imageNetwork,
                                                item?[index]?['imageUrl'] ?? "",
                                            imageBuilder: (context,
                                                    imageProvider) =>
                                                SizedBox(
                                                  child: AspectRatio(
                                                    aspectRatio: 1 / 1,
                                                    child: SizedBox(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Constants.white,
                                                          image: DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit
                                                                  .contain),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            errorWidget: (context, url,
                                                    error) =>
                                                SizedBox(
                                                  child: AspectRatio(
                                                      aspectRatio: 1 / 1,
                                                      child: SizedBox(
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color:
                                                                Constants.white,
                                                            shape: BoxShape
                                                                .rectangle,
                                                          ),
                                                        ),
                                                      )),
                                                )),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: Constants.spacing4,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: Constants.spacing1),
                                            child: Text(
                                              item?[index]?['brand'] != null
                                                  ? item[index]['brand']
                                                      .toString()
                                                  : "",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color:
                                                      Constants.gray.shade500,
                                                  fontSize:
                                                      Constants.fontSizeXs),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: Constants.spacing1,
                                                right: 1),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .4,
                                            child: Text(
                                              item?[index]?['name'] != null
                                                  ? item[index]['name']
                                                  : "",
                                              maxLines: 4,
                                              // overflow: TextOverflow.clip,
                                              // softWrap: false,
                                              style: const TextStyle(
                                                  fontFamily:
                                                      Constants.primaryFontBold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize:
                                                      Constants.fontSizeLg),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: Constants.spacing2),
                                            child: Row(
                                              children: [
                                                Card(
                                                  margin: EdgeInsets.zero,
                                                  // shadowColor:
                                                  //     Colors.transparent,
                                                  color: Constants.gray.shade100,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Constants.spacing1),
                                                    side: BorderSide(
                                                      color: Constants
                                                          .gray.shade400,
                                                      width: 0.7,
                                                    ),
                                                  ),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: Constants.spacing2,vertical: Constants.spacing1),
                                                    // width: 45,
                                                    // height: 20,
                                                    child: Center(
                                                      child: Text(
                                                        ("Cash / kredit"),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Constants
                                                                .gray.shade500,
                                                            fontSize: Constants
                                                                .fontSizeSm),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                
                                              ],
                                            ),
                                          ),
                                          item?[index]?['price'] == null
                                              ? Container()
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        margin: const EdgeInsets.fromLTRB(0, Constants.spacing2, 0, Constants.spacing1),
                                                        child: const Text(
                                                          ("Harga OTR mulai dari"),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: Constants
                                                                  .blackText,
                                                              // fontWeight: FontWeight.w500,
                                                              fontSize: Constants
                                                                  .fontSizeSm),
                                                        )),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                        bottom:
                                                            Constants.spacing1,
                                                      ),
                                                      child: Text(
                                                        "${formatter.format(item[index]?['price']).substring(0, 4)}jt",
                                                        style: const TextStyle(
                                                            fontFamily: Constants
                                                                .primaryFontBold,
                                                            color: Constants
                                                                .primaryColor,
                                                            fontSize: Constants
                                                                .fontSizeXl),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          item?[index]?['discountPercentage'] ==
                                                      null &&
                                                  item?[index]
                                                          ?['priceNormal'] ==
                                                      null
                                              ? Container()
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: Constants
                                                                  .spacing1),
                                                      decoration: BoxDecoration(
                                                          color: item?[index]?[
                                                                      'discountPercentage'] !=
                                                                  null
                                                              ? Constants.lime
                                                              : Colors
                                                                  .transparent,
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          5.0))),
                                                      child: Center(
                                                          child: Text(
                                                        item?[index]?[
                                                                    'discountPercentage'] !=
                                                                null
                                                            ? "${item?[index]?['discountPercentage']}%"
                                                            : '',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: Constants
                                                                .fontSizeXs),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                    ),
                                                    Container(
                                                        child: item?[index]?[
                                                                    'price'] !=
                                                                item?[index]?[
                                                                    'priceNormal']
                                                            ? Text(
                                                                item?[index]?[
                                                                            'priceNormal'] !=
                                                                        null
                                                                    ? 'Rp. ${formatter.format(item?[index]?['priceNormal']).substring(0, 4)} jt'
                                                                    : "",
                                                                style:
                                                                    const TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  // fontWeight: FontWeight.bold,
                                                                  // color: CustomColor.primaryRedColor,
                                                                ),
                                                              )
                                                            : item?[index]?[
                                                                        'price'] ==
                                                                    item?[index]
                                                                        ?[
                                                                        'priceNormal']
                                                                ? Text(
                                                                    item?[index]?['priceNormal'] !=
                                                                            null
                                                                        ? 'Rp. ${formatter.format(item?[index]?['priceNormal'])}'
                                                                        : '',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          Constants
                                                                              .primaryFontBold,
                                                                      // color: CustomColor.primaryRedColor,
                                                                    ),
                                                                  )
                                                                : const Text(
                                                                    "")),
                                                  ],
                                                ),
                                          item?[index]?['reviewRate'] == null &&
                                                  item?[index]?['qtySold'] ==
                                                      null
                                              ? Container()
                                              : Container(
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      vertical:
                                                          Constants.spacing2),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.star,
                                                            color: item?[index]
                                                                        ?[
                                                                        'reviewRate'] !=
                                                                    null
                                                                ? const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    255,
                                                                    196,
                                                                    0)
                                                                : Colors
                                                                    .transparent,
                                                            size: 14.0,
                                                          ),
                                                          Text(
                                                            "${item?[index]?['reviewRate'] ?? ''}",
                                                            style: const TextStyle(
                                                                fontSize: Constants
                                                                    .fontSizeXs),
                                                          ),
                                                          const SizedBox(
                                                            width: Constants
                                                                .spacing2,
                                                          ),
                                                          Text(
                                                            item?[index]?[
                                                                        'qtySold'] !=
                                                                    null
                                                                ? "Terjual ${item?[index]?['qtySold']}"
                                                                : "",
                                                            style: const TextStyle(
                                                                fontSize: Constants
                                                                    .fontSizeXs),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    // } else {
    //   return Container();
    // }
  }
}
