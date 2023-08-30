import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/item/motor_item.dart';

class HMCThumbnails extends StatelessWidget {
  final dynamic section;

  const HMCThumbnails(this.section, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * .35;

    List<Widget> items = [];
    if ((section ?? [])['items'].isNotEmpty) {
      for (var i = 0; i < section['items'].length; i++) {
        items.add(Container(
          margin: const EdgeInsets.fromLTRB(1, 1, Constants.spacing2, 1),
          width: width,
          child: motorItem(section['items'][i]),
        ));
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: Constants.spacing6),
      color: Constants.white,
      child: Column(
        children: [
          section['title'] == null && section['linkText'] == null
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(
                    left: Constants.spacing4,
                    right: Constants.spacing4,
                    top: Constants.spacing4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        section['title'] ?? '',
                        style: const TextStyle(
                            fontSize: Constants.fontSizeXl,
                            fontFamily: Constants.primaryFontBold),
                        textAlign: TextAlign.left,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed("/motor");
                        },
                        child: Text(
                          section['link_text'] ?? '',
                          style: const TextStyle(
                              fontSize: 15,
                              color: Constants.primaryColor,
                              fontFamily: Constants.primaryFontBold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
          Container(
            margin: const EdgeInsets.fromLTRB(Constants.spacing4,
                Constants.spacing3, Constants.spacing4, Constants.spacing4),
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
