// ignore_for_file: must_be_immutable


import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/builders/body_builder.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/app_shimmer.dart';

class BannerCarousel extends StatefulWidget {
  final List<dynamic>? items;
  int? state,index;
  

  dynamic aspectRatio;

  BannerCarousel({Key? key, this.items, required this.aspectRatio,this.state,this.index})
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
            aspectRatio: (result?[0] ?? 8) / (result[1] ?? 5.6),
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: ( widget.items ?? []).length > 1 ? true : false,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
            // onPageChanged: callbackFunction,
            scrollDirection: Axis.horizontal,
          ),
          items: ( widget.items ?? [])
              .asMap()
              .map((key, value) => MapEntry(key, Builder(
                    builder: (BuildContext context) {
                      return renderImage(index: key,target: widget.items?[key]['target'] ?? "");
                    },))).values.toList()),
    );
  }

  Widget renderImage({int? index, String? target}) {
    print("indexs image $index");

    return InkWell(
        onTap: () async {
          await Navigator.pushNamed(context, target ?? "");
        },
        child: BodyBuilder(section: widget.items?[index ?? 0]??[],state: widget.state,));

  }
}
