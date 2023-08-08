// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/header/dynamic_transparent_header.dart';
import 'package:kliknss77/ui/header/floating_header.dart';


class HeaderBuilder extends StatefulWidget {
  dynamic section,type;
  final Function? onRefresh;
  final dynamic warna;


  ScrollController? controller;

  bool transparentMode;

  final double scrollOffset;
  dynamic keyMark;
  final Function(Map)? onLocationChange;
  HeaderBuilder(
      {Key? key,
      this.section,
      this.onRefresh,
      this.warna,
      this.keyMark,
      this.onLocationChange,
      this.scrollOffset = 0.0,
      this.transparentMode = false,
      this.controller,
      this.type,})
      : super(key: key);

  @override
  _HeaderBuilderState createState() => _HeaderBuilderState();
}

class _HeaderBuilderState extends State<HeaderBuilder> {
  @override
  Widget build(BuildContext context) {
    switch (widget.section['type']) {
      // Floating Header
      case "Header1":
        return 
        // Container(height: 120,color: Constants.slBarColor,width: 200,);
        
        DynamicTransparentHeader(
          key: const ValueKey("appbar"),
          warna: widget.warna,
          transparentMode: true,
          controller: widget.controller,
          // section: widget.section,
        );
     
      default:
        return Container();
    }
  }
}
