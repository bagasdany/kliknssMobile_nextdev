// ignore_for_file: must_be_immutable


import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/app_shimmer.dart';

class BannerCarousel extends StatefulWidget {
  final List<dynamic>? banners;
  int? state;

  dynamic aspectRatio;

  BannerCarousel({Key? key, this.banners, required this.aspectRatio,this.state})
      : super(key: key);

  @override
  _BannerCarouselState createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final koma = ",";
  Size imageSize = const Size(0.00, 0.00);
   List<double> result = [];



  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
     result = convertToDoubles(widget.aspectRatio);
    // if (widget.banners != null && (widget.banners ?? []).length > 0) {
    //   String url = (widget.banners ?? [])[0]['imageUrl'] ?? "";
    //   _getImageDimension("${Constants.baseURLImages}/$url");
    // }
    // List<Map<String, dynamic>> flattenedList = [];
    // List<Map<String, dynamic>> flattenedList = [];
    // widget.banners?.forEach((list) => flattenedList.addAll(list.cast<Map<String, dynamic>>()));

    // widget.banners?.forEach((list) => flattenedList.addAll(list));
    print("flattenedList");

    super.initState();
  }

  List<double> convertToDoubles(String input) {
    List<String> parts = input.split('/');
    double part1 = double.parse(parts[0]);
    double part2 = double.parse(parts[1]);
    return [part1, part2];
  }

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      active: widget.state == 2,
      child: CarouselSlider(
          options: CarouselOptions(
            aspectRatio: (result?[0] ?? 17) / (result[1] ?? 5.6),
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: ( widget.banners ?? []).length > 1 ? true : false,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
            // onPageChanged: callbackFunction,
            scrollDirection: Axis.horizontal,
          ),
          items: ( widget.banners ?? [])
              .asMap()
              .map((key, value) => MapEntry(key, Builder(
                    builder: (BuildContext context) {
                      return renderImage(
                          "${Constants.baseURLImages}/${ widget.banners?[key]['props']['src'][0].toString()}",
                           widget.banners?[key]['target'] ?? "");
                    },))).values.toList()),
    );
  }

  Widget renderImage(String url, String target) {
    final image =url;

    AspectRatio imageWidget = AspectRatio(
      aspectRatio: (result?[0] ?? 17) / (result[1] ?? 5.6),
      child: CachedNetworkImage(
          imageUrl: image,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              AspectRatio(
                  aspectRatio: (result?[0] ?? 17) / (result[1] ?? 5.6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Constants.gray.shade300,
                      shape: BoxShape.rectangle,
                    ),
                  )),
          errorWidget: (context, url, error) => AspectRatio(
              aspectRatio:(result?[0] ?? 17) / (result[1] ?? 5.6),
              child: Container(
                key: const ValueKey("image_error"),
                decoration: BoxDecoration(
                  color: Constants.gray.shade300,
                  shape: BoxShape.rectangle,
                ),
              ))),
    );

    return InkWell(
        onTap: () async {
          await Navigator.pushNamed(context, target);
        },
        child: imageWidget);
  }
}
