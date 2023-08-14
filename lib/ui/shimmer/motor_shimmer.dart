
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/app_shimmer.dart';
import 'package:shimmer/shimmer.dart';

class MotorShimmer extends StatelessWidget {
  int state;
  MotorShimmer({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: Constants.spacing4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: state == 2
                                  ? AppShimmer(
                                      active: state == 2,
                                      child: Container(
                                        padding: const EdgeInsets.all(
                                            Constants.spacing4),
                                        child: Container(
                                          color: Constants.gray,
                                          child: const Text(
                                            "....",
                                            style: TextStyle(
                                                fontSize: Constants.fontSizeLg,
                                                fontFamily:
                                                    Constants.primaryFontBold),
                                          ),
                                        ),
                                      ))
                                  : Container(
                                      padding: const EdgeInsets.all(
                                          Constants.spacing4),
                                      color: Constants.black,
                                      child: const Text(
                                        "",
                                        style: TextStyle(
                                            color: Constants.white,
                                            fontSize: Constants.fontSizeLg,
                                            fontFamily:
                                                Constants.primaryFontBold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                            ),
                          ]),
                      ListView.builder(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 6,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 2),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: Constants.spacing4,
                                          horizontal: Constants.spacing4),
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: Constants.white,
                                      ),
                                      child: Wrap(
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .4,
                                                  child: AspectRatio(
                                                    aspectRatio: 1 / 1,
                                                    child: CachedNetworkImage(
                                                        imageUrl: "",
                                                        fit: BoxFit.contain,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            AspectRatio(
                                                              aspectRatio:
                                                                  1 / 1,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      Constants
                                                                          .white,
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  image: DecorationImage(
                                                                      image:
                                                                          imageProvider,
                                                                      fit: BoxFit
                                                                          .contain),
                                                                ),
                                                              ),
                                                            ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Shimmer.fromColors(
                                                              baseColor:
                                                                  Constants.gray
                                                                      .shade200,
                                                              highlightColor:
                                                                  Colors.white,
                                                              child:
                                                                  AspectRatio(
                                                                      aspectRatio:
                                                                          1 / 1,
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Constants
                                                                              .gray
                                                                              .shade300,
                                                                          shape:
                                                                              BoxShape.rectangle,
                                                                        ),
                                                                      )),
                                                            )),
                                                  ),
                                                ),
                                              ),

                                              // Padding(padding: EdgeInsets.only(top: 1.0)),
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
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: Constants
                                                                  .spacing1),
                                                      child: state == 2
                                                          ? AppShimmer(
                                                              active:
                                                                  state == 2,
                                                              child: SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.4,
                                                                child:
                                                                    Container(
                                                                  color:
                                                                      Constants
                                                                          .gray,
                                                                  child:
                                                                      const Text(
                                                                    "",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            Constants
                                                                                .fontSizeXs,
                                                                        fontFamily:
                                                                            Constants.primaryFontBold),
                                                                  ),
                                                                ),
                                                              ))
                                                          : Text(
                                                              // item[index]?['brand'] != null
                                                              //     ? item[index]['brand']
                                                              //         .toString()
                                                              // :
                                                              "",
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: Constants
                                                                      .gray
                                                                      .shade500,
                                                                  fontSize:
                                                                      Constants
                                                                          .fontSizeXs),
                                                            ),
                                                    ),
                                                    // Container(
                                                    //   margin: const EdgeInsets.only(
                                                    //       bottom: Constants.spacing1,
                                                    //       right: 1),
                                                    //   padding: EdgeInsets.all(2),
                                                    //   child: Text(
                                                    //     item[index]?['name'] != null
                                                    //         ? item[index]['name']
                                                    //         : "",
                                                    //     overflow: TextOverflow.ellipsis,
                                                    //     style: const TextStyle(
                                                    //         fontFamily: Constants
                                                    //             .primaryFontBold,
                                                    //         overflow:
                                                    //             TextOverflow.ellipsis,
                                                    //         fontSize:
                                                    //             Constants.fontSizeLg),
                                                    //   ),
                                                    // ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: Constants
                                                                  .spacing1,
                                                              right: 1),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .4,
                                                      child: state == 2
                                                          ? AppShimmer(
                                                              active:
                                                                  state == 2,
                                                              child: SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.4,
                                                                child:
                                                                    Container(
                                                                  color:
                                                                      Constants
                                                                          .gray,
                                                                  child:
                                                                      const Text(
                                                                    "",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            Constants
                                                                                .fontSizeLg,
                                                                        fontFamily:
                                                                            Constants.primaryFontBold),
                                                                  ),
                                                                ),
                                                              ))
                                                          : const Text(
                                                              // item[index]?['name'] != null
                                                              //     ? item[index]['name']
                                                              //     :
                                                              "",
                                                              maxLines: 4,
                                                              // overflow: TextOverflow.clip,
                                                              // softWrap: false,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      Constants
                                                                          .primaryFontBold,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize:
                                                                      Constants
                                                                          .fontSizeLg),
                                                            ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: Constants
                                                                  .spacing2),
                                                      child: Row(
                                                        children: [
                                                          Card(
                                                            margin:
                                                                EdgeInsets.zero,
                                                            shadowColor: Colors
                                                                .transparent,
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                255,
                                                                255,
                                                                255),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14),
                                                              side: BorderSide(
                                                                color: Constants
                                                                    .gray
                                                                    .shade300,
                                                                width: 0.7,
                                                              ),
                                                            ),
                                                            child: SizedBox(
                                                              width: 45,
                                                              height: 20,
                                                              child: Center(
                                                                child: state ==
                                                                        2
                                                                    ? AppShimmer(
                                                                        active:
                                                                            state ==
                                                                                2,
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.08,
                                                                          child:
                                                                              Container(
                                                                            color:
                                                                                Constants.gray,
                                                                            child:
                                                                                const Text(
                                                                              "",
                                                                              style: TextStyle(fontSize: Constants.fontSizeXs, fontFamily: Constants.primaryFontBold),
                                                                            ),
                                                                          ),
                                                                        ))
                                                                    : Text(
                                                                        ("cash"),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Constants.gray.shade500,
                                                                            fontSize: Constants.fontSizeXs),
                                                                      ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: Constants
                                                                  .spacing1),
                                                          Card(
                                                            margin:
                                                                EdgeInsets.zero,
                                                            shadowColor: Colors
                                                                .transparent,
                                                            color: Colors
                                                                .transparent,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14),
                                                              side: BorderSide(
                                                                color: Constants
                                                                    .gray
                                                                    .shade300,
                                                                width: 0.7,
                                                              ),
                                                            ),
                                                            child: SizedBox(
                                                              width: 45,
                                                              height: 20,
                                                              child: Center(
                                                                child: state ==
                                                                        2
                                                                    ? AppShimmer(
                                                                        active:
                                                                            state ==
                                                                                2,
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.08,
                                                                          child:
                                                                              Container(
                                                                            color:
                                                                                Constants.gray,
                                                                            child:
                                                                                const Text(
                                                                              "",
                                                                              style: TextStyle(fontSize: Constants.fontSizeXs, fontFamily: Constants.primaryFontBold),
                                                                            ),
                                                                          ),
                                                                        ))
                                                                    : Text(
                                                                        ("kredit"),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            color: Constants.gray.shade500,
                                                                            // fontWeight: FontWeight.w500,
                                                                            fontSize: Constants.fontSizeXs),
                                                                      ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            margin: const EdgeInsets
                                                                    .symmetric(
                                                                vertical: Constants
                                                                    .spacing1),
                                                            child: state == 2
                                                                ? AppShimmer(
                                                                    active:
                                                                        state ==
                                                                            2,
                                                                    child:
                                                                        SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.4,
                                                                      child:
                                                                          Container(
                                                                        color: Constants
                                                                            .gray,
                                                                        child:
                                                                            const Text(
                                                                          "",
                                                                          style: TextStyle(
                                                                              fontSize: Constants.fontSizeXs,
                                                                              fontFamily: Constants.primaryFontBold),
                                                                        ),
                                                                      ),
                                                                    ))
                                                                : Text(
                                                                    ("Harga OTR mulai dari"),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        color: Constants.gray.shade500,
                                                                        // fontWeight: FontWeight.w500,
                                                                        fontSize: Constants.fontSizeXs),
                                                                  )),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                            bottom: Constants
                                                                .spacing1,
                                                          ),
                                                          child: state == 2
                                                              ? AppShimmer(
                                                                  active:
                                                                      state ==
                                                                          2,
                                                                  child:
                                                                      SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.3,
                                                                    child:
                                                                        Container(
                                                                      color: Constants
                                                                          .gray,
                                                                      child:
                                                                          const Text(
                                                                        "",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                Constants.fontSizeXl,
                                                                            fontFamily: Constants.primaryFontBold),
                                                                      ),
                                                                    ),
                                                                  ))
                                                              : const Text(
                                                                  // "${formatter.format(item[index]?['price']).substring(0, 4)}jt",
                                                                  "",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          Constants
                                                                              .primaryFontBold,
                                                                      color: Constants
                                                                          .primaryColor,
                                                                      fontSize:
                                                                          Constants
                                                                              .fontSizeXl),
                                                                ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          margin: const EdgeInsets
                                                                  .only(
                                                              right: Constants
                                                                  .spacing1),
                                                          decoration: const BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5.0))),
                                                          child: Center(
                                                              child: state == 2
                                                                  ? AppShimmer(
                                                                      active:
                                                                          state ==
                                                                              2,
                                                                      child:
                                                                          SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.08,
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              Constants.gray,
                                                                          child:
                                                                              const Text(
                                                                            "",
                                                                            style:
                                                                                TextStyle(fontSize: Constants.fontSizeXs, fontFamily: Constants.primaryFontBold),
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : const Text(
                                                                      // item[index]?[
                                                                      //             'discountPercentage'] !=
                                                                      //         null
                                                                      //     ? "${item[index]?['discountPercentage']}%"
                                                                      // :
                                                                      '',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              Constants.fontSizeXs),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    )),
                                                        ),
                                                        Container(
                                                            child: state == 2
                                                                ? AppShimmer(
                                                                    active:
                                                                        state ==
                                                                            2,
                                                                    child:
                                                                        SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.08,
                                                                      child:
                                                                          Container(
                                                                        color: Constants
                                                                            .gray,
                                                                        child:
                                                                            const Text(
                                                                          "",
                                                                          style:
                                                                              TextStyle(fontFamily: Constants.primaryFontBold),
                                                                        ),
                                                                      ),
                                                                    ))
                                                                : const Text(
                                                                    "")),
                                                      ],
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          vertical: Constants
                                                              .spacing2),
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
                                                              state == 2
                                                                  ? AppShimmer(
                                                                      active:
                                                                          state ==
                                                                              2,
                                                                      child:
                                                                          SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.04,
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              Constants.gray,
                                                                          child:
                                                                              const Text(
                                                                            "",
                                                                            style:
                                                                                TextStyle(fontSize: Constants.fontSizeXs, fontFamily: Constants.primaryFontBold),
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : const Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: Colors
                                                                          .transparent,
                                                                      size:
                                                                          14.0,
                                                                    ),
                                                              state == 2
                                                                  ? AppShimmer(
                                                                      active:
                                                                          state ==
                                                                              2,
                                                                      child:
                                                                          SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.04,
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              Constants.gray,
                                                                          child:
                                                                              const Text(
                                                                            "",
                                                                            style:
                                                                                TextStyle(fontSize: Constants.fontSizeXs, fontFamily: Constants.primaryFontBold),
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : const Text(
                                                                      // "${item[index]?['reviewRate'] ?? ''}",
                                                                      "",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              Constants.fontSizeXs),
                                                                    ),
                                                              const SizedBox(
                                                                width: Constants
                                                                    .spacing2,
                                                              ),
                                                              state == 2
                                                                  ? AppShimmer(
                                                                      active:
                                                                          state ==
                                                                              2,
                                                                      child:
                                                                          SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.15,
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              Constants.gray,
                                                                          child:
                                                                              const Text(
                                                                            "",
                                                                            style:
                                                                                TextStyle(fontSize: Constants.fontSizeXs, fontFamily: Constants.primaryFontBold),
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : const Text(
                                                                      // item[index]?[
                                                                      //             'qtySold'] !=
                                                                      //         null
                                                                      //     ? "Terjual ${item[index]?['qtySold']}"
                                                                      // :
                                                                      "",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              Constants.fontSizeXs),
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
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
          // } else {
          //   return Container();
          // }
        },
        itemCount: 1);
  }
}
