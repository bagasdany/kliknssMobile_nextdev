// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kliknss77/ui/component/header/dynamic_transparent_header.dart';
import 'package:kliknss77/ui/component/multiguna_view/m2w_footer_view.dart';


class FooterBuilder extends StatefulWidget {
  dynamic section,type,page,state;
  final Function? onRefresh;
  final dynamic warna;



  ScrollController? controller;

  bool transparentMode;

  final double scrollOffset;
  dynamic keyMark;
  final Function(Map)? onLocationChange;
  FooterBuilder(
      {Key? key,
      this.section,
      this.onRefresh,
      this.warna,
      this.keyMark,
      this.onLocationChange,
      this.scrollOffset = 0.0,
      this.transparentMode = false,
      this.controller,
      this.state,
      this.type,})
      : super(key: key);

  @override
  _FooterBuilderState createState() => _FooterBuilderState();
}

class _FooterBuilderState extends State<FooterBuilder> {

  @override
  Widget build(BuildContext context) {
    // var master = {'master': widget.section['url'] == "/multiguna-motor" ? "FooterM2W" : "MasterDetail"};
    // (widget.section ?? {}).isNotEmpty ? (widget.section).addAll(master) : null;
  
    switch (widget.section['type']) {

      // Floating Header
      case "SiteLink1":
        return 
        M2WFooterView(
          state: widget.state,
          section: widget.section,
          // page: widget.page,
          // section: widget.section,
        );
     
      default:
        return Container();
    }
  }
}
