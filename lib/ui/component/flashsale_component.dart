import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/item/flashsale_item.dart';
import 'package:kliknss77/ui/component/see_all_component.dart';
import 'package:kliknss77/ui/shimmer/banner_shimmer.dart';
import 'countdown_timer_component.dart';
import 'hexcolor.dart';

/// Class item a Item Discount Card
class FlashSaleComponent extends StatefulWidget {
  dynamic section;
  FlashSaleComponent({Key? key, this.section}) : super(key: key);

  @override
  State<FlashSaleComponent> createState() => _FlashSaleComponentState();
}

class _FlashSaleComponentState extends State<FlashSaleComponent>
    with SingleTickerProviderStateMixin {
  // dynamic section = widget.item;
  dynamic _controller;
  final double maxTranslation = 150;
  int? differenceInSeconds;
  String? textTimer;
  double _value = 20.0;

  // String get hexColor => null;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    DateTime now = DateTime.now();
    DateTime startdate =
        DateTime.parse(widget.section['startDate'] ?? "2023-03-03 10:27:00");

    DateTime endDate =
        DateTime.parse(widget.section['endDate'] ?? "2023-03-03 10:27:00");

    int? differenceStartDate = startdate.difference(now).inSeconds;

    int? differenceendDate = endDate.difference(now).inSeconds;
    // differenceInSeconds = differenceStartDate.inSeconds;
    // differenceInHours = differenceStartDate.inHours;

    startdate.isBefore(now)
        ? textTimer = "Berakhir dalam"
        : textTimer = "Dimulai dalam";
  }
  bool isRemainingQtyLessThanOne(dynamic item) {
  return item['remainingQty'] < 1;
}

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * .4;

    List<Widget> items = [];

    
    if ((widget.section?['items'] ?? []) != null) {
      // // Menambahkan sorting berdasarkan remainingQty
      // dynamic itemsSort = widget.section?['items'] ?? [];
      // itemsSort.sort((a, b) {
      //   if (isRemainingQtyLessThanOne(a) && !isRemainingQtyLessThanOne(b)) {
      //     return 1; // a dianggap lebih besar dari b
      //   } else if (!isRemainingQtyLessThanOne(a) && isRemainingQtyLessThanOne(b)) {
      //     return -1; // a dianggap lebih kecil dari b
      //   } else {
      //     return 0; // tidak ada perubahan urutan
      //   }
      // });
      for (var i = 0; i < widget.section?['items'].length; i++) {
        if (i == 0) {
          items.add(
            widget.section?['coverMobileUrl'] == null ||
                    widget.section?['coverMobileUrl'] == ""
                ? Container(
                    margin: const EdgeInsets.only(left: Constants.spacing4),
                  )
                : Container(
                    width: width,
                  ),
          );
        }

        items.add(
          Container(
            margin: const EdgeInsets.fromLTRB(Constants.spacing1,
                Constants.spacing2, Constants.spacing2, Constants.spacing2),
            width: width,
            child: FlashSaleItem(
                widget.section['items'][i], i, widget.section['uid'], 1, 1 / 3),
          ),
        );
        if (i == widget.section?['items'].length - 1) {
          items.add(Container(
            width: width,
            margin: const EdgeInsets.fromLTRB(Constants.spacing1,
                Constants.spacing2, Constants.spacing2, Constants.spacing2),
            child: SeeAll(
              onClick: () {
                Navigator.of(context).pushNamed("${widget.section?['link']}");
              },
            ),
          ));
        }
      }
    }

    return Container(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(
        bottom: Constants.spacing6,
      ),
      // color: Constants.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          widget.section['title'] == null && widget.section['linkText'] == null
              ? Container()
              : Container(
                  padding:
                      const EdgeInsets.fromLTRB(0, 0, Constants.spacing2, 0),
                  margin:
                      const EdgeInsets.fromLTRB(Constants.spacing4, 0, 0, 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          widget.section['title'] ?? "",
                          style: const TextStyle(
                              fontSize: Constants.fontSizeLg,
                              fontFamily: Constants.primaryFontBold),
                          textAlign: TextAlign.left,
                          maxLines: 3,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed("${widget.section['link'] ?? "/"}");

                          // Navigator.of(context).pushNamed("/sparepart/${item['id']}");
                        },
                        child: Text(
                          widget.section['linkText'] ?? "",
                          style: const TextStyle(
                            fontSize: Constants.fontSizeSm,
                            color: Constants.primaryColor,
                            fontFamily: Constants.primaryFontBold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                ),
          Container(
            padding: EdgeInsets.zero,
            color: Colors.transparent,
            margin: const EdgeInsets.fromLTRB(
                Constants.spacing4, 0, Constants.spacing4, Constants.spacing2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: Constants.spacing1),
                      child: Text(
                        textTimer ?? "",
                        style: const TextStyle(fontSize: Constants.fontSizeSm),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    widget.section['endDate'] == null
                        ? Container()
                        : CountDownTimerComponent(
                            icon: true,
                            shouldShowDays: false,
                            fontColor: "white",
                            endDate: widget.section['endDate'],
                            startDate: widget.section['startDate'],
                            types: widget.section['countdownType'] ??
                                // end
                                "slideCountdown",
                          ),
                  ],
                ),
              ],
            ),
          ),
          (widget.section?['items'] ?? []).isEmpty
              ? Container()
              : AspectRatio(
                  aspectRatio: 1400 / 1250,
                  child: Container(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollUpdateNotification) {
                          _controller?.value =
                              scrollNotification.metrics.pixels /
                                  maxTranslation;
                          print("controller value ${_controller?.value}");
                        }
                        return false;
                      },
                      child: Container(
                        // color: Constants.sky.shade100,
                        decoration: BoxDecoration(
                          color:
                              HexColor(widget.section?['bgColor'] ?? "#82d7d5"),
                          // gradient:
                          // LinearGradient(
                          //     colors: [
                          //       Color(0xFF82d7d5),
                          //       Color(0xFF05B0AC),
                          //     ],
                          //     begin: Alignment.topCenter,
                          //     end: Alignment.bottomCenter,
                          //     stops: [0.0, 1.0],
                          //     tileMode: TileMode.clamp),
                        ),
                        child: SingleChildScrollView(
                          child: AnimatedBuilder(
                              animation: _controller.view,
                              builder: (context, child) {
                                return Stack(
                                  children: [
                                    widget.section?['imageUrl'] == null ||
                                            widget.section?['imageUrl'] == ""
                                        ? Container()
                                        : AspectRatio(
                                            aspectRatio: 1400 / 1250,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              transform:
                                                  Matrix4.translationValues(
                                                -30.0 *
                                                    (_controller?.value ?? ""),
                                                0,
                                                0,
                                              ),
                                              child: Container(
                                                child: Opacity(
                                                  opacity: _controller?.value <
                                                          0.6
                                                      ? (1.0 -
                                                          (_controller?.value ??
                                                              0))
                                                      : 0.4,
                                                  child: 
                                                  widget.section?['imageUrl'] == null ? Container():
                                                  CachedNetworkImage(
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              AspectRatio(
                                                                  aspectRatio:
                                                                      1 / 1,
                                                                  child:
                                                                      BannerShimmer(
                                                                    aspectRatio:
                                                                        1 / 1,
                                                                  )),
                                                      imageUrl:
                                                          "${Constants.baseURLImages}${widget.section?['imageUrl']}",
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container()),
                                                ),
                                              ),
                                            ),
                                          ),
                                    AspectRatio(
                                      aspectRatio: 1400 / 1250,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: items,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
