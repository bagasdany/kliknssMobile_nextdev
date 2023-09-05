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

   Widget buildDescriptionVariant1(items,index){
    return InkWell(child: ContainerTailwind(
      margin: const EdgeInsets.symmetric(vertical: Constants.spacing1),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Image.network("${Constants.baseURLImages}${items['imageUrl']}",)),
          // CachedNetworkImage(
    
          //   imageUrl: "${Constants.baseURLImages}${items['imageUrl']}",
          //   width: 20,
          //   height: 20,
          //   fit: BoxFit.cover,
          //   // placeholder: (context, url) =>  BannerShimmer(aspectRatio: 4/1,),
          //   errorWidget: (context, url, error) => Container(),
            
          // ),
          const SizedBox(width: Constants.spacing2,),
          Expanded(
            flex: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextTailwind(
                  mainClass:items['class'] ?? '',
                  textStyle: const TextStyle(color: Constants.primaryColor,fontSize: Constants.fontSizeLg),
                  
                  text:"${index+1}. ${items['title']}" ?? "",),
                  const SizedBox(height: Constants.spacing2,),
                TextTailwind(
                  mainClass:items['class'] ?? '',
                  // textStyle: const TextStyle(color: Constants.primaryColor,fontSize: Constants.fontSizeLg),
                  
                  text:"${items['description']}" ?? "",),
              ],
            ),
          ),
        ],
      ),
    ));
   }

   Widget buildDescriptionVariant2(items,index){
    return InkWell(child: ContainerTailwind(
      margin: const EdgeInsets.symmetric(vertical: Constants.spacing1),
      child: Column(
        children: [
          TextTailwind(
            mainClass:items['class'] ?? '',
            textStyle: const TextStyle(color: Constants.primaryColor,fontSize: Constants.fontSizeLg),
            
            text:"${index+1}. ${items['title']}" ?? "",),
        ],
      ),
    ));
   }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContainerTailwind(
            extClass: widget.section['class'] ?? '',
            margin: const EdgeInsets.only(bottom: Constants.spacing2),
            child: TextTailwind(text: widget.section['title'] ?? "Table of Content.",mainClass: widget.section['containerClass'],textStyle: const TextStyle(fontSize: Constants.fontSize2Xl,fontFamily: Constants.primaryFontBold),)),
          ContainerTailwind(
            extClass: widget.section['containerClass'] ?? '',
            
            child: ListView.builder( 
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: (widget.section['items'] ?? []).length,
            itemBuilder: ((context, index) {
              return FlexTailwind(
                mainClass: widget.section['itemClass'] ?? '',
                children: [
                Image.network("${Constants.baseURLImages}${widget.section?['items']?[index]['imageUrl']}",width: MediaQuery.of(context).size.width * 0.1,height: MediaQuery.of(context).size.width * 0.1,),
                // CachedNetworkImage(
    
                //   imageUrl: "${Constants.baseURLImages}${widget.section?['items']?[index]['imageUrl']}",
                //   width: 20,
                //   height: 20,
                //   fit: BoxFit.cover,
                //   // placeholder: (context, url) =>  BannerShimmer(aspectRatio: 4/1,),
                //   errorWidget: (context, url, error) => Container(),
                  
                // ),
                
              TextTailwind(
                      mainClass:widget.section?['items']?[index]['class'] ?? '',
                      textStyle: const TextStyle(color: Constants.primaryColor,fontSize: Constants.fontSizeLg),
                      
                      text:"${index+1}. ${widget.section?['items']?[index]['title']}" ?? "",),
                     
                    TextTailwind(
                      mainClass:widget.section?['items']?[index]['class'] ?? '',
                      // textStyle: const TextStyle(color: Constants.primaryColor,fontSize: Constants.fontSizeLg),
                      
                      text:"${widget.section?['items']?[index]['description']}" ?? "",),

              ]);
            }),
              ),
          ),
        ],
      ),
    );
  }
}
