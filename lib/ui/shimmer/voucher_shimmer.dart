
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/app_shimmer.dart';
import 'package:shimmer/shimmer.dart';

class VoucherShimmer extends StatelessWidget {
  int state;
  VoucherShimmer({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, Constants.spacing4),
            child: Column(
              children: [
                Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Constants.spacing3),
                      ),
                    ),
                    margin: const EdgeInsets.fromLTRB(Constants.spacing4,
                        Constants.spacing4, Constants.spacing4, 0),
                    // margin:
                    //     const EdgeInsets.only(top: Constants.spacing1),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Constants.spacing3)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 2.5 / 1,
                                  child: Shimmer.fromColors(
                                    baseColor: Constants.gray.shade200,
                                    highlightColor: Colors.white,
                                    child: CachedNetworkImage(
                                        imageBuilder: (context,
                                                imageProvider) =>
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                ),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                        fit: BoxFit.fill,
                                        imageUrl: "",
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                AppShimmer(
                                                    active: state == 2,
                                                    child: const AspectRatio(
                                                        aspectRatio: 2.5 / 1,
                                                        child: SizedBox())),
                                        errorWidget: (context, url, error) =>
                                            Shimmer.fromColors(
                                              baseColor:
                                                  Constants.gray.shade200,
                                              highlightColor: Colors.white,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        Constants.gray.shade200,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                Constants
                                                                    .spacing3))),
                                                width: 55,
                                                height: 60,
                                              ),
                                            )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                              left: -15,
                              child: SizedBox(
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Constants.gray.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )),
                          Positioned(
                              right: -15,
                              child: SizedBox(
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Constants.gray.shade100,
                                      shape: BoxShape.circle),
                                ),
                              )),
                        ],
                      ),
                    )),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Constants.gray.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Constants.white,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: Constants.spacing4,
                  ),
                  child: Column(
                    children: [
                      Container(
                          child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Constants.spacing4,
                            vertical: Constants.spacing2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: state == 2
                                  ? AppShimmer(
                                      active: state == 2,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Container(
                                          color: Constants.gray,
                                          child: const Text(
                                            "",
                                            style: TextStyle(
                                                fontSize: Constants.fontSizeLg),
                                          ),
                                        ),
                                      ))
                                  : const Text(
                                      "",
                                      maxLines: 2,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          fontSize: Constants.fontSizeLg),
                                    ),
                            ),
                            const SizedBox(
                              height: Constants.spacing1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    AppShimmer(
                                      active: state == 2,
                                      child: Icon(
                                        Icons.access_time_rounded,
                                        color: Constants.primaryColor.shade300,
                                        size: 30,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: Constants.spacing2,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: Constants.spacing1,
                                      ),
                                      child: const Text(
                                        "Berlaku Hingga",
                                        style: TextStyle(
                                            color: Constants.gray,
                                            fontSize: Constants.fontSizeXs),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          bottom: Constants.spacing1),
                                      child: state == 2
                                          ? AppShimmer(
                                              active: state == 2,
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                child: Container(
                                                  color: Constants.gray,
                                                  child: const Text(
                                                    "",
                                                    style: TextStyle(
                                                        fontSize: Constants
                                                            .fontSizeLg),
                                                  ),
                                                ),
                                              ))
                                          : const Text(
                                              "",
                                              style: TextStyle(
                                                  fontSize:
                                                      Constants.fontSizeLg),
                                            ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                          ),
                    ],
                  ),
                )
              ],
            ),
          );
          
        });
  }
}
