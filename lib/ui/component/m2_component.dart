import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';

class M2Section extends StatelessWidget {
  final dynamic section;

  const M2Section(this.section, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildItem(item, cols, i) {
      return item['imageUrl'] != null
          ? InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(item['target']);
              },
              child: Container(
                width: cols == 2
                    ? double.infinity
                    : MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  children: [
                    Container(
                      margin: cols == 2
                          ? const EdgeInsets.fromLTRB(
                              0, Constants.spacing4, 0, Constants.spacing1)
                          : const EdgeInsets.fromLTRB(
                              0, Constants.spacing4, 0, Constants.spacing1),
                      padding: cols == 2
                          ? const EdgeInsets.all(0)
                          : EdgeInsets.fromLTRB(Constants.spacing3, 0,
                              i == 0 ? 0 : Constants.spacing3, 0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Constants.spacing2),
                            child: 
                            item['imageUrl'] == null || item['imageUrl'] == "" ? Container():
                            CachedNetworkImage(
                      imageUrl: item['imageUrl'] ?? "" ,
                      // width: MediaQuery.of(context).size.width * 0.2,
                      // height: MediaQuery.of(context).size.width * 0.2,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => Container(),
                                  ),
                            // Image.network(
                            //   item['imageUrl'] ?? "",
                            //   fit: BoxFit.cover,
                            //   errorBuilder: (BuildContext context,
                            //       Object exception, StackTrace? stackTrace) {
                            //     return SizedBox(
                            //         child: AspectRatio(
                            //             aspectRatio: 2 / 1,
                            //             child: Container(
                            //               decoration: BoxDecoration(
                            //                 color: Constants.gray.shade300,
                            //               ),
                            //             )));
                            //   },
                            // ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // margin:
                      //     const EdgeInsets.fromLTRB(0, 0, 0, Constants.spacing1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item['text'] ?? "",
                              style: const TextStyle(
                                fontSize: Constants.fontSizeLg,
                                fontFamily: Constants.primaryFontBold,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                  color: Constants.gray.shade200,
                  borderRadius: const BorderRadius.all(
                      Radius.circular(Constants.spacing3))),
            );
    }

    List<Widget> items = [];
    if (section['items'] != null) {
      for (var i = 0; i < section['items'].length; i++) {
        items.add(
          buildItem(section['items'][i], section['cols'], i),
        );
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: Constants.spacing6),
      child: Column(
        children: [
          Container(
            color: Constants.white,
            child: Container(
              color: Constants.white,
              // padding: const EdgeInsets.symmetric(vertical: Constants.spacing2),
              padding: section['cols'] == 2
                  ? const EdgeInsets.fromLTRB(
                      Constants.spacing4,
                      Constants.spacing2,
                      Constants.spacing4,
                      Constants.spacing4)
                  : const EdgeInsets.fromLTRB(
                      0, Constants.spacing1, 0, Constants.spacing3),
              child: Wrap(
                children: items,
              ),
            ),
          ),
        ],
      ),

      // ),
    );
  }
}
