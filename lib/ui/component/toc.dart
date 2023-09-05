import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:tailwind_style/tailwind_style.dart';

class ToC extends StatefulWidget {
  final dynamic section,onClick;
  const ToC({
    Key? key,
    this.section,
    this.onClick,
  }) : super(key: key);

  @override
  State<ToC> createState() => _ToCState();
}

class _ToCState extends State<ToC> {

   Widget buildDescription(items,index){
    return InkWell(child: ContainerTailwind(
      margin: EdgeInsets.symmetric(vertical: Constants.spacing1),
      child: TextTailwind(
        mainClass:items['class'] ?? '',
        textStyle: const TextStyle(color: Constants.primaryColor,fontSize: Constants.fontSizeLg),
        
        text:"${index+1}. ${items['text']}" ?? "",),
    ));
   }

  @override
  Widget build(BuildContext context) {
    return ContainerTailwind(
      // padding: EdgeInsets.symmetric(horizontal: Constants.spacing4,vertical: Constants.spacing4),
      extClass: widget.section['class'] ?? '',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContainerTailwind(
            margin: const EdgeInsets.only(bottom: Constants.spacing2),
            child: TextTailwind(text: widget.section['title'] ?? "Table of Content.",mainClass: widget.section['containerClass'],textStyle: const TextStyle(fontSize: Constants.fontSize2Xl,fontFamily: Constants.primaryFontBold),)),
          ListView.builder( 
          shrinkWrap: true,
          
          itemCount: (widget.section['contents'] ?? []).length,
          itemBuilder: ((context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildDescription( widget.section?['contents']?[index]??[],index),
              ],
            );
          }),
    ),
        ],
      ));
  }
}
