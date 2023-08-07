// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:shimmer/shimmer.dart';


class BannerShimmer extends StatelessWidget {
  double aspectRatio;
  BannerShimmer({Key? key, required this.aspectRatio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Constants.gray.shade200,
      highlightColor: Colors.white,
      child: CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
            aspectRatio: aspectRatio ,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: false,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
          ),
          items: [
            Container(
              decoration: BoxDecoration(
                color: Constants.gray.shade100,
              ),
            ),
          ]),
    );
  }
}
