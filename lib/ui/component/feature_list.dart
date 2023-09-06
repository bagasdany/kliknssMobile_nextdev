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
    return Container(
      // constraints: constraints.max,
      // height: 300,
      margin: const EdgeInsets.symmetric(horizontal: Constants.spacing4,vertical: Constants.spacing4),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            ContainerTailwind(
              extClass: widget.section['class'] ?? '',
              
                  margin: const EdgeInsets.fromLTRB(0, Constants.spacing4, Constants.spacing4, Constants.spacing1),
              child: TextTailwind(text: widget.section['title'] ?? "",mainClass: widget.section['containerClass'],textStyle: const TextStyle(fontSize: Constants.fontSize2Xl,fontFamily: Constants.primaryFontBold),)),
            ContainerTailwind(
              extClass: widget.section['class'] ?? '',
              
                  margin: const EdgeInsets.symmetric(vertical: Constants.spacing1),
              child: TextTailwind(text: widget.section['description'] ?? "",mainClass: widget.section['containerClass'],textStyle: const TextStyle(fontSize: Constants.fontSizeMd),)),
            
            ContainerTailwind(
              margin: const EdgeInsets.symmetric(vertical: Constants.spacing4),
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
                    Expanded(
                      flex: 1,
                      child: CachedNetworkImage(
                        imageUrl: "${Constants.baseURLImages}${widget.section?['items']?[index]['imageUrl']}",
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.width * 0.2,
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) => Container(),
                                    ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(Constants.spacing3, Constants.spacing3, Constants.spacing3, Constants.spacing3),
                        child: Column(
                          children: [
                            
                            Expanded(
                              flex: 1,
                              child: TextTailwind(
                                // textAlign: TextAlign.start,
                                // mainClass:widget.section?['itemClass'] ?? '',
                                textStyle: const TextStyle(fontFamily: Constants.primaryFontBold,fontSize: Constants.fontSizeLg),
                                      
                                text:"${widget.section?['items']?[index]['title']}" ?? "",),
                            ),
                            Expanded(
                              flex: 4,
                              child: TextTailwind(
                                  mainClass:widget.section?['itemClass'] ?? '',
                                  // textStyle: const TextStyle(color: Constants.primaryColor,fontSize: Constants.fontSizeLg,t),
                                  
                                  text:"${widget.section?['items']?[index]['description']}" ?? "",),
                            ),
                          ],
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
          ],
        ),
      ),
    );
  }
}
