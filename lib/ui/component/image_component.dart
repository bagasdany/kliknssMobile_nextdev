// ignore_for_file: must_be_immutable


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:tailwind_style/tailwind_style.dart';

class ImageCarousel extends StatefulWidget {
  final List<dynamic>? items;
  
  int? state;

  dynamic aspectRatio,section;

  ImageCarousel({Key? key, this.items, required this.aspectRatio,this.state,this.section})
      : super(key: key);

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
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
     result = convertToDoubles(widget.aspectRatio ?? "[8.0/5.6]");
    print("flattenedList");

    super.initState();
  }

  List<double> convertToDoubles(String input) {
    final start = input.indexOf("[") + 1;
    final end = input.indexOf("]");
    final extracted = input.substring(start, end);
    List<String> parts = extracted.split('/');
    double part1 = double.parse(parts[0]);
    double part2 = double.parse(parts[1]);
    return [part1, part2];
  }

  @override
  Widget build(BuildContext context) {
    print("widget.items carousel ${widget.items}");
    return renderImage(
      widget.items?[0].isEmpty ||  widget.items?[0] == [] || (widget.items ?? []).isEmpty ? "https://www.kliknss.co.id/images/logo202001.png" :
      "https://kliknss.co.id/images/${widget.items?[0].toString()}","");
  }

  Widget renderImage(String url, String target) {
    print("url image carousel $url");
    final image =url;
    return LayoutBuilder(
    builder: (context, constraints) {
      final parentAspectRatio = constraints.maxWidth / constraints.maxHeight;
      final childAspectRatio =  result[0] / result[1];

      double width, height;
      //parents kan 2 , childAspectratio 1.4
      if (childAspectRatio < parentAspectRatio) {
        result[0] = constraints.maxWidth;
        result[1] = constraints.maxHeight  ;
      } else {
        // height = constraints.maxHeight;
        // width = height * childAspectRatio;
      }
      AspectRatio imageWidget =  AspectRatio(
      aspectRatio: (result?[0] ?? 1) / (result[1] ?? 1),
      child: 
      image == null || image == "" ||  image == "null" || image.contains("///") || image.contains("file:///") ? Container():
      
      // CachedNetworkImage(
      //                 imageUrl: image , 
      //                 // width: MediaQuery.of(context).size.width * 0.2,
      //                 // height: MediaQuery.of(context).size.width * 0.2,
      //                 fit: BoxFit.cover,
      //                 errorWidget: (context, url, error) => Container(),
      //                             ),
      Image.network(
        image ,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Constants.gray.shade200,
            child: const Center(
              child: Icon(
                Icons.broken_image,
                color: Colors.white,
                size: 30,

              ),
            ),
          );
        },
        fit: BoxFit.contain,
      )
      );

      return InkWell(
        onTap: () async {
          await Navigator.pushNamed(context, target);
        },
        child: ContainerTailwind(
          extClass: widget.section?['class'] ?? "",
          child: imageWidget,
        ),
      );
    },
  );

  }
}
