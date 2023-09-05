// ignore_for_file: must_be_immutable


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:tailwind_style/tailwind_style.dart';

class TocComponent extends StatefulWidget {
  final List<dynamic>? items;
  
  int? state;

  dynamic name,section;

  TocComponent({Key? key, this.items,  this.name,this.state,this.section})
      : super(key: key);

  @override
  _TocComponentState createState() => _TocComponentState();
}

class _TocComponentState extends State<TocComponent> {
  

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    //  result = convertToDoubles(widget.aspectRatio ?? "[8/5.6]");
    print("flattenedList");
    AppDialog.snackBar(text: "masuk init");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: MediaQuery.of(context).size.width,color: Constants.black,height: MediaQuery.of(context).size.height,);
  }
}
