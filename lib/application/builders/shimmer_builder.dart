// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kliknss77/ui/component/handle_error/maintenance_page.dart';
import 'package:kliknss77/ui/component/handle_error/network_error.dart';
import 'package:kliknss77/ui/shimmer/home_shimmer.dart';


  // case 2 = onNetwork Error
class ShimmerBuilder extends StatefulWidget {
  String? shimmer;
  final Function? onSuccess;
  ShimmerBuilder(
      {Key? key,
      this.onSuccess,
      this.shimmer,})
      : super(key: key);

  @override
  _ShimmerBuilderState createState() => _ShimmerBuilderState();
}
  

class _ShimmerBuilderState extends State<ShimmerBuilder> {

  @override
  void initState() {
    super.initState();
    print("shimmer masuk page");
    
  }
  @override
  Widget build(BuildContext context) {
    switch (widget.shimmer) {
      // Floating Header
      case "home":
        return HomeShimmer(
         aspectRatio: 8/5.6,
        );
      default:
        return Container();
    }
  }
}
