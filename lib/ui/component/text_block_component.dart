// ignore_for_file: must_be_immutable


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:tailwind_style/tailwind_style.dart';

class TextBlockComponent extends StatefulWidget {
  final List<dynamic>? items;
  
  int? state;

  dynamic name,section;

  TextBlockComponent({Key? key, this.items,  this.name,this.state,this.section})
      : super(key: key);

  @override
  _TextBlockComponentState createState() => _TextBlockComponentState();
}

class _TextBlockComponentState extends State<TextBlockComponent> {
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
    //  result = convertToDoubles(widget.aspectRatio ?? "[8/5.6]");
    print("flattenedList");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextTailwind(
      text: widget.section?['text'] ?? "",
      mainClass: widget.section?['class'] ?? "",
    );
  }
}
