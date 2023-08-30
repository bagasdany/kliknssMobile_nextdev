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
     result = convertToDoubles(widget.aspectRatio ?? "[8/5.6]");
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
    return renderImage("${Constants.baseURLImages}${ widget.items?[0].toString()}","");
  }

  Widget renderImage(String url, String target) {
    print("url image carousel $url");
    final image =url;
    AspectRatio imageWidget = AspectRatio(
      aspectRatio: (result?[0] ?? 17) / (result[1] ?? 5.6),
      child: CachedNetworkImage(
          imageUrl: image,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              AspectRatio(
                  aspectRatio: (result?[0] ?? 17) / (result[1] ?? 5.6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Constants.gray.shade300,
                      shape: BoxShape.rectangle,
                    ),
                  )),
          errorWidget: (context, url, error) => AspectRatio(
              aspectRatio:(result?[0] ?? 17) / (result[1] ?? 5.6),
              child: Container(
                // key: const ValueKey("image_error"),
                decoration: BoxDecoration(
                  color: Constants.gray.shade300,
                  shape: BoxShape.rectangle,
                ),
              ))),
    );

    return InkWell(
        onTap: () async {
          await Navigator.pushNamed(context, target);
        },
        child: ContainerTailwind(
          extClass: widget.section?['class'] ?? "",
          child:imageWidget));
  }
}
