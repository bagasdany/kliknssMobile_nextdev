import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:tailwind_style/tailwind_style.dart';

class IconList extends StatefulWidget {
  Map? section;
  final String? mainClass;
   IconList({super.key, this.section,this.mainClass});

  @override
  State<IconList> createState() => _IconListState();
}

class _IconListState extends State<IconList> {
  @override
  Widget build(BuildContext context) {
    return GridTW(
      mainClass: widget.mainClass,
      itemCount: (widget.section?['icons'] ?? []).length,
      itemBuilder: ((context, index) {
      return InkWell(
        onTap: (){
          Navigator.pushNamed(context, widget.section?['icons']?[index]['target'] ?? "");
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainClass: widget.section?['class'] ?? '',
          children: [
            Flexible(
              flex: 6,
              child: Container(
                // color: Constants.gray,
                child: CachedNetworkImage(
                  imageUrl: "${Constants.baseURLImages}${widget.section?['icons']?[index]['imageUrl']}",
                  fit: BoxFit.cover,
                  // width: 40,
                  // height: 40,
                  errorWidget: (context, url, error) => Container(),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              
              child: Container(
                // color: Constants.lime,
                child: TextTailwind(
                    mainClass:widget.section?['class'] ?? '',
                    textAlign: TextAlign.center,
                    textStyle: const TextStyle(color: Constants.black,fontSize: Constants.fontSizeSm),
                    text:"${widget.section?['icons']?[index]['text']}" ?? "",),
              ),
            ),
        ]),
      );
    }));
  }
}