
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';

class TitlewithIconGrid1 extends StatefulWidget {
  final dynamic section;
  final dynamic items;

  const TitlewithIconGrid1({Key? key, this.section, this.items})
      : super(key: key);

  @override
  _TitlewithIconGrid1State createState() => _TitlewithIconGrid1State();
}

class _TitlewithIconGrid1State extends State<TitlewithIconGrid1> {
  List<dynamic> grid = [];
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    grid = widget.section?['props']['items'] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    Widget buildItem(item) {
      return Container(
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item['imageUrl'] != null
                ? SizedBox(
                    width: 55,
                    height: 60,
                    child: SizedBox(
                      child: 
                      item == null || item['imageUrl'] == null ? Container():
                       CachedNetworkImage(
                      imageUrl: item['imageUrl'] ?? "" ,
                      // width: MediaQuery.of(context).size.width * 0.2,
                      // height: MediaQuery.of(context).size.width * 0.2,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => Container(),
                                  ),
                      // Image.network(
                      //   item['imageUrl'] ?? "",
                      //   fit: BoxFit.contain,
                      //   loadingBuilder: (BuildContext context, Widget child,
                      //       ImageChunkEvent? loadingProgress) {
                      //     if (loadingProgress == null) {
                      //       return SizedBox(child: child);
                      //     }
                      //     return Container(
                      //       decoration: BoxDecoration(
                      //           color: Constants.gray.shade200,
                      //           borderRadius: const BorderRadius.all(
                      //               Radius.circular(Constants.spacing3))),
                      //       width: 55,
                      //       height: 60,
                      //     );
                      //   },
                      //   errorBuilder: (BuildContext context, Object exception,
                      //       StackTrace? stackTrace) {
                      //     return Container(
                      //       decoration: BoxDecoration(
                      //           color: Constants.gray.shade200,
                      //           borderRadius: const BorderRadius.all(
                      //               Radius.circular(Constants.spacing3))),
                      //       width: 55,
                      //       height: 60,
                      //     );
                      //   },
                      // ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: Constants.gray.shade200,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(Constants.spacing3))),
                    width: 55,
                    height: 60,
                  ),
            const SizedBox(
              width: Constants.spacing2,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] ?? "-",
                        style: const TextStyle(
                          fontSize: Constants.fontSizeLg,
                          fontFamily: Constants.primaryFontBold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: Constants.spacing2),
                      Text(
                        item['description'] ?? '',
                        style: const TextStyle(),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget buildTitle() {
      return Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(Constants.spacing4,
                Constants.spacing4, Constants.spacing4, Constants.spacing2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "",
                    // widget.section?['description'],
                    style: Constants.heading4,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Constants.white,
            padding: const EdgeInsets.all(Constants.spacing4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "",
                    // widget.section?['description'],
                      style: const TextStyle()),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget buildGridItem() {
      return Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: grid.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(Constants.spacing4),
                  decoration: const BoxDecoration(
                      color: Constants.white,
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromARGB(255, 230, 230, 230)))),
                  child: buildItem(grid[index]),
                );
              })
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: Constants.spacing4),
      child: Column(
        children: [buildTitle(), buildGridItem()],
      ),
    );
  }
}
