import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:tailwind_style/tailwind_style.dart';

class Article1Component extends StatefulWidget {
  final dynamic section,onClick;
  const Article1Component({
    Key? key,
    this.section,
    this.onClick,
  }) : super(key: key);

  @override
  State<Article1Component> createState() => _Article1ComponentState();
}

class _Article1ComponentState extends State<Article1Component> {


  @override
  Widget build(BuildContext context) {
    return ContainerTailwind(
      // padding: EdgeInsets.symmetric(horizontal: Constants.spacing4,vertical: Constants.spacing4),
      extClass: widget.section['class'] ?? '',
      child: Html(data: widget.section['htmlText'] ?? "")
      );
  }
}
