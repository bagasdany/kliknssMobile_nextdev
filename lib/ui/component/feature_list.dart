import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/shimmer/banner_shimmer.dart';
import 'package:tailwind_style/tailwind_style.dart';

class FeatureList extends StatefulWidget {
  final dynamic section,onClick;
  const FeatureList({
    Key? key,
    this.section,
    this.onClick,
  }) : super(key: key);

  @override
  State<FeatureList> createState() => _FeatureListState();
}

class _FeatureListState extends State<FeatureList> {

   

  @override
  Widget build(BuildContext context) {
    return FlexTW(
      mainClass: widget.section['class'] ?? '',
      children: [
        widget.section['title'] == null ? Container():
        Flexible(
          // flex: 1,
          child: ContainerTailwind(
            extClass: widget.section['class'] ?? '',
            
                margin: const EdgeInsets.fromLTRB(0, Constants.spacing4, Constants.spacing4, Constants.spacing1),
            child: TextTailwind(text: widget.section['title'] ?? "",mainClass: widget.section['containerClass'],textStyle: const TextStyle(fontSize: Constants.fontSize2Xl,fontFamily: Constants.primaryFontBold),)),
        ),
        
         widget.section['description'] == null ? Container():
        Flexible(
          // flex: 4,
          child: ContainerTailwind(
            extClass: widget.section['class'] ?? '',
            
                margin: const EdgeInsets.symmetric(vertical: Constants.spacing1),
            child: TextTailwind(text: widget.section['description'] ?? "",mainClass: widget.section['containerClass'],textStyle: const TextStyle(fontSize: Constants.fontSizeMd),)),
        ),
        //
        Flexible(
          // flex: 9,
          child: ContainerTailwind(
            extClass: widget.section['containerClass'] ?? '',
            child: 
            GridTW( 
              itemCount:( widget.section['items'] ?? []).length ?? 1,
              mainClass: widget.section['containerClass'] ?? '',
            
              itemBuilder: ((context, index) {
              return 
              // Container(height: 100,color: Constants.amber,);
              FlexTW(
                mainClass: widget.section['itemClass'] ?? '',
                children: [
                  // Image.network("${Constants.baseURLImages}${widget.section?['items']?[index]['imageUrl']}",width: MediaQuery.of(context).size.width * 0.2,height: MediaQuery.of(context).size.width * 0.2,),
                  widget.section?['items']?[index]['imageUrl'] == null ? Container():
                   Flexible(
        
                    // flex: 4,
                    // fit: FlexFit.tight,
                     child: CachedNetworkImage(
                      imageUrl: "${Constants.baseURLImages}${widget.section?['items']?[index]['imageUrl']}",
                      // width: MediaQuery.of(context).size.width * 0.2,
                      // height: MediaQuery.of(context).size.width * 0.2,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => Container(),
                                  ),
                   ),
                  Flexible(
                    // flex: 8,
        
                    // fit: FlexFit.tight,
                    
                    child: RawScrollbar(
                      trackColor: Constants.gray.shade400,
                      fadeDuration: const Duration(milliseconds: 1000),
                      timeToFade: const Duration(milliseconds: 1500),
                      
                      thumbColor: Constants.gray.shade600,
                      trackBorderColor: Constants.white,
                      // mainAxisMargin : 40,
                      minOverscrollLength: 20,
                      thumbVisibility: true,
                      trackVisibility: true,
                      minThumbLength: 30,
                      // trackRadius: const Radius.circular(1),
                      // trackBorderColor: Constants.amber,
                      // mainAxisMargin: MediaQuery.of(context).size.width * 0.4,
                      padding: const EdgeInsets.symmetric(horizontal: Constants.spacing1),
                      
                      thickness: 1,
                      crossAxisMargin: 0,
                      // crossAxisMargin: 0,
                      radius: const Radius.circular(10),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.min,
                          // mainClass: widget.section['itemClass'] ?? '',
                          children: [
                            TextTailwind(
                              // textAlign: TextAlign.center,
                              // mainClass:widget.section?['itemClass'] ?? '',
                              textStyle: const TextStyle(fontFamily: Constants.primaryFontBold,fontSize: Constants.fontSizeLg),
                                    
                              text:"${widget.section?['items']?[index]['title']}" ?? "",),
                            TextTailwind(
                                mainClass:widget.section?['itemClass'] ?? '',
                                // textStyle: const TextStyle(color: Constants.primaryColor,fontSize: Constants.fontSizeLg,t),
                                
                                text:"${widget.section?['items']?[index]['description']}" ?? "",),
                          ],
                        ),
                      ),
                    ),
                  ),
                     
                    
              
              ]);
            }),
              ),
            // ListView.builder( 
            // physics: const NeverScrollableScrollPhysics(),
            // shrinkWrap: true,
            // itemCount: (widget.section['items'] ?? []).length,
            // itemBuilder: ((context, index) {
            //   return FlexTW(
            //     mainClass: widget.section['itemClass'] ?? '',
            //     // mainClass: widget.section['itemClass'] ?? '',
            //     // direction: Axis.horizontal,
            //     children: [
            //     // Image.network("${Constants.baseURLImages}${widget.section?['items']?[index]['imageUrl']}",width: MediaQuery.of(context).size.width * 0.2,height: MediaQuery.of(context).size.width * 0.2,),
            //     CachedNetworkImage(
            //       imageUrl: "${Constants.baseURLImages}${widget.section?['items']?[index]['imageUrl']}",
            //       width: MediaQuery.of(context).size.width * 0.2,
            //       height: MediaQuery.of(context).size.width * 0.2,
            //       fit: BoxFit.contain,
            //       errorWidget: (context, url, error) => Container(),
            //   ),
            //   Container(
            //     margin: const EdgeInsets.fromLTRB(Constants.spacing3, Constants.spacing3, Constants.spacing3, Constants.spacing3),
            //     child: FlexTW(
            //       children: [
                    
            //         TextTailwind(
            //           textAlign: TextAlign.start,
            //           mainClass:widget.section?['itemClass'] ?? '',
            //           textStyle: const TextStyle(fontFamily: Constants.primaryFontBold,fontSize: Constants.fontSizeLg),
                            
            //           text:"${widget.section?['items']?[index]['title']}" ?? "",),
            //         TextTailwind(
            //             mainClass:widget.section?['itemClass'] ?? '',
            //             // textStyle: const TextStyle(color: Constants.primaryColor,fontSize: Constants.fontSizeLg,t),
                        
            //             text:"${widget.section?['items']?[index]['description']}" ?? "",),
            //       ],
            //     ),
            //   ),
                     
                    
              
            //   ]);
            // }),
            //   ),
          ),
        ),
      ],
    );
  }
}
