import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/brand_item.dart';
import 'package:kliknss77/infrastructure/database/data_page.dart';
import 'package:kliknss77/ui/component/sparepart_component_item.dart';

/// Class item a Item Discount Card
class SparepartThumbnails extends StatelessWidget {
  final dynamic section;

  const SparepartThumbnails(this.section, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * .4;

    List<Widget> items = [];
    if (section['items'] != null) {
      for (var i = 0; i < section['items'].length; i++) {
        items.add(Container(
          margin: const EdgeInsets.fromLTRB(1, 1, Constants.spacing2, 1),
          width: width,
          child: SparepartItemComponent(section['items'][i]),
        ));
      }
    }

    return Container(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: Constants.spacing6),
      // color: Constants.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          section['title'] == null && section['linkText'] == null
              ? Container()
              : Container(
                  padding: EdgeInsets.zero,
                  margin: const EdgeInsets.fromLTRB(Constants.spacing4, 0,
                      Constants.spacing4, Constants.spacing2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          section['title'] ?? "",
                          style: const TextStyle(
                              fontSize: Constants.fontSizeLg,
                              fontFamily: Constants.primaryFontBold),
                          textAlign: TextAlign.left,
                          maxLines: 3,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, anotherAnimation) {
                                return AppPage.withName('sparepart-view')
                                    as Widget;
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 100),
                              transitionsBuilder:
                                  (context, animation, otherAnimation, child) {
                                animation = CurvedAnimation(
                                    parent: animation, curve: Curves.easeInOut);
                                return SlideTransition(
                                  position: Tween(
                                          begin: const Offset(1.0, 0.0),
                                          end: const Offset(0.0, 0.0))
                                      .animate(animation),
                                  child: child,
                                );
                              }));
                        },
                        child: Text(
                          section['linkText'] ?? "",
                          style: const TextStyle(
                              fontSize: Constants.fontSizeSm,
                              color: Constants.primaryColor,
                              fontFamily: Constants.primaryFontBold),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  )),
          (section?['brands'] ?? []).isEmpty
              ? Container()
              : Container(
                  width: double.infinity,
                  color: Constants.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.spacing4),
                  height: 65.0,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: section['brands'] == null
                          ? 0
                          : section['brands'].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            brandItem(section['brands'] != null
                                ? section['brands'][index]
                                : null)
                          ],
                        );
                      }),
                ),
          (section?['categories'] ?? []).isEmpty
              ? Container()
              : Container(
                  width: double.infinity,
                  color: Constants.white,
                  height: 65.0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: Constants.spacing4),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: section['categories'] == null
                            ? 0
                            : section['categories'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              brandItem(section['categories'] != null
                                  ? section['categories'][index]
                                  : null)
                            ],
                          );
                        }),
                  ),
                ),
          (section?['items'] ?? []).isEmpty
              ? Container()
              : Container(
                  color: Constants.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.spacing4,
                      vertical: Constants.spacing2),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: items,
                      )),
                ),
        ],
      ),
    );
  }
}
