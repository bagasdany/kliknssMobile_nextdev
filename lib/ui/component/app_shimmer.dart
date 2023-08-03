import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatefulWidget {
  bool active;
  Widget child;

  AppShimmer({required this.child, this.active = true, Key? key})
      : super(key: key);

  @override
  State<AppShimmer> createState() => _AppShimmer();
}

class _AppShimmer extends State<AppShimmer> {
  @override
  Widget build(BuildContext context) {
    return widget.active == true
        ? Shimmer.fromColors(
            baseColor: Constants.gray.shade200,
            highlightColor: Colors.white,
            child: widget.child,
          )
        : widget.child;
  }
}
