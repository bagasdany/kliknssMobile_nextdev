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
    return ContainerTailwind(
      // padding: EdgeInsets.only(top: Constants.spacing11),
      extClass: widget.section?['class'] ?? '',
      child: GridTW(
        mainClass: widget.mainClass,
        itemCount: (widget.section?['icons'] ?? []).length,
        itemBuilder: ((context, index) {
        return InkWell(
          onTap: (){
            Navigator.pushNamed(context, widget.section?['icons']?[index]['target'] ?? "");
          },
          child: FlexTW(
            // mainClass: widget.section?['containerClass'] ?? '',
            children: [
              widget.section == null || widget.section?['icons']?[index]['imageUrl'] == null || widget.section?['icons']?[index]['imageUrl'] == "null" ? Container():
              Flexible(
                // flex: 5,
                child: CachedNetworkImage(
                  imageUrl: "${Constants.baseURLImages}${widget.section?['icons']?[index]['imageUrl']}",
                  fit: BoxFit.cover,
                  // width: 40,
                  // height: 40,
                  errorWidget: (context, url, error) => Container(),
                ),
              ),
              Flexible(
                // flex: 3,
                child: TextTailwind(
                    mainClass:widget.section?['class'] ?? '',
                    textAlign: TextAlign.center,
                    textStyle: const TextStyle(color: Constants.black,fontSize: Constants.fontSizeSm),
                    text:"${widget.section?['icons']?[index]['text']}" ?? "",),
              ),
          ]),
        );
      })),
    );
  }
}