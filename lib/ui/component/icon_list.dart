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
    return 
    // Container(height: 100,color: Constants.gray,);
    Container(
      // height: double.infinity,
      // width: double.infinity,
      child: GridTW(
        // bgImage: ,
        mainClass: widget.mainClass,
        itemCount: (widget.section?['icons'] ?? []).length,
        itemBuilder: ((context, index) {
        return 
        // Container(height: 100,color: Constants.gray,
        // margin: EdgeInsets.symmetric(vertical: Constants.spacing2),);
        
        InkWell(
          onTap: (){
            print("widget.section?['icons']?[index]['link'] ${widget.section?['icons']?[index]['link']}");
            Navigator.pushNamed(context, widget.section?['icons']?[index]['target'] ?? "");
          },
          child: Column(
            // mainClass: widget.section?['class'] ?? '',
            children: [
              // Image.network("${Constants.baseURLImages}${widget.section?['items']?[index]['imageUrl']}",width: MediaQuery.of(context).size.width * 0.2,height: MediaQuery.of(context).size.width * 0.2,),
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: "${Constants.baseURLImages}${widget.section?['icons']?[index]['imageUrl']}",
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.4,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) => Container(),
                              ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(Constants.spacing3, Constants.spacing3, Constants.spacing3, Constants.spacing3),
                  child: FlexTW(
                    children: [
                      
                      // Expanded(
                      //   flex: 1,
                      //   child: TextTailwind(
                      //     // textAlign: TextAlign.start,
                      //     // mainClass:widget.section?['itemClass'] ?? '',
                      //     textStyle: const TextStyle(fontFamily: Constants.primaryFontBold,fontSize: Constants.fontSizeLg),
                                
                      //     text:"${widget.section?['items']?[index]['title']}" ?? "",),
                      // ),
                      Expanded(
                        // flex: 3,
                        child: TextTailwind(
                            mainClass:widget.section?['class'] ?? '',
                            // textStyle: const TextStyle(color: Constants.primaryColor,fontSize: Constants.fontSizeLg,t),
                            
                            text:"${widget.section?['icons']?[index]['text']}" ?? "",),
                      ),
                    ],
                  ),
                ),
              ),
                  
                
          
          ]),
        );
      })),
    );
        
      
  }
}