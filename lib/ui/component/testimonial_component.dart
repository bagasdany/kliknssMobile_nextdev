import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/shimmer/banner_shimmer.dart';
import 'package:tailwind_style/tailwind_style.dart';

class Testimonial extends StatefulWidget {
  Map? section;
  Testimonial({super.key , this.section});

  @override
  State<Testimonial> createState() => _TestimonialState();
}

class _TestimonialState extends State<Testimonial> {

  Widget buildTestimonial(items){
    return Container(
      color: Constants.white,
      // margin: EdgeInsets.only(right: Constants.spacing2),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.5,
      padding: const EdgeInsets.all(Constants.spacing4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.format_quote_outlined,size: 40,color: Constants.red,),
          Flexible(
            child: RawScrollbar(
              thumbColor: Constants.red,
              radius: const Radius.circular(10),
              thickness: 5,
              

              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: Constants.spacing4),
                  child: TextTailwind(text: items['text'])),
              ),
            ),
          ),
          
          Container(

            margin: const EdgeInsets.only(top: Constants.spacing2),
            child: Column(
              children: [
                Container(
                            // margin: const EdgeInsets.symmetric(
                            //     vertical: Constants.spacing2),
                            child: Divider(
                              thickness: 2,
                              color: Constants.gray.shade200,
                            ),
                          ),
                Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircleAvatar(
                          child: ClipOval(
                            
                            child: items['imageUrl'] == null || items['imageUrl'] == "" ? Container(): CachedNetworkImage(imageUrl: "${Constants.baseURLImages}${items['imageUrl']}",fit: BoxFit.cover,width: 40,height: 40,errorWidget: (context, url, error) {
                              return const Icon(Icons.broken_image);
                            
                            },progressIndicatorBuilder: (context, url, progress) {
                              return BannerShimmer(aspectRatio: 1/1);
                            }, )
                            // Image.network(
                            //   "${Constants.baseURLImages}${items['imageUrl']}",
                            //   fit: BoxFit.cover,
                            //   width: 40,
                            //   height: 40,),
                          ),
                        ),
                      ),
                      const SizedBox(width: Constants.spacing2,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextTailwind(text: items['name'],textStyle: const TextStyle(fontWeight: FontWeight.bold),),
                          const SizedBox(height: Constants.spacing1,),
                          TextTailwind(text: items['createdAt'],textStyle: const TextStyle(fontSize: Constants.fontSizeSm),),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Constants.spacing4),
            // padding: const EdgeInsets.symmetric(
            //     horizontal: Constants.spacing4),
            height: MediaQuery.of(context).size.width * 0.66,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: (widget.section?['items'] ?? []).length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    // color: Constants.white,
                    child: buildTestimonial(widget.section?['items'][index]));
                }),
          );
  }
}