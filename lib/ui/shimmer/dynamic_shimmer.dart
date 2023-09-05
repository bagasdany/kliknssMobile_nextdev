// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/builders/body_builder.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/app_shimmer.dart';
import 'package:kliknss77/ui/shimmer/banner_shimmer.dart';
import 'package:shimmer/shimmer.dart';


class DynamicShimmer extends StatelessWidget {
  dynamic section;
  DynamicShimmer({Key? key, this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            AppShimmer(
              active: true,
              child: Container(
                color: Constants.amber,
                margin: EdgeInsets.symmetric(vertical: Constants.spacing4),
                child: BodyBuilder(section: section),
              ),
            ),
             AppShimmer(

              active: true,
              child: Container(
                color: Constants.gray,
                margin: EdgeInsets.symmetric(vertical: Constants.spacing4),
                child: AppShimmer(active: true,child: Container(height: 100,width: MediaQuery.of(context).size.width,)),
                         ),
             )
          ],
        ),
      ),
    );
  }
}
