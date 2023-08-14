import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/builders/master_builder.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/flavors.dart';
import 'package:kliknss77/infrastructure/apis/home_api/home_api.dart';

class CategoryIcons extends StatelessWidget {
  final dynamic categories;

  const CategoryIcons(this.categories, {Key? key}) : super(key: key);

  Widget aCategoryIcon(BuildContext context, category) {
    bool menuAvailable =  category['target'] != null ? category['target'].isNotEmpty : false;
    bool hasBadge =
        category['badge'] != null && (category['badge']['enabled'] ?? false)
            ? true
            : false;
    String bgcolor = hasBadge ? category['badge']['bgcolor'] : '#B74093';
    bgcolor = bgcolor.isNotEmpty ? bgcolor.substring(1) : bgcolor;
    Color badgeBgcolor = Color(int.parse('FF$bgcolor', radix: 16));

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          padding: const EdgeInsets.all(Constants.spacing2),
          child: InkWell(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (!menuAvailable) return;
                Navigator.pushNamed(context,"/page?url=${category['target']}&shimmer=home");
              });
            },
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Opacity(
                      opacity: menuAvailable ? 1 : .1,
                      child: Padding(
                        padding: const EdgeInsets.all(Constants.spacing1),
                        child: CachedNetworkImage(
                            imageUrl: "${Constants.baseURLImages}${category['imageUrl']}",
                            imageBuilder: (context, imageProvider) =>
                                AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Constants.white,
                                      // shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                                ),
                            errorWidget: (context, url, error) => AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Constants.gray.shade300,
                                  ),
                                ))),
                      ),
                    ),
                  ),
                  Text(
                    (category['text'] ?? '') + '\n',
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: Constants.fontSizeXs,
                        color: menuAvailable
                            ? Constants.gray
                            : Constants.gray.shade300),
                    textAlign: TextAlign.center,
                  )
                ],
              );
            }),
          ),
        ),
        hasBadge
            ? Positioned(
                top: Constants.spacing2,
                right: Constants.spacing3,
                child: Container(
                  color: badgeBgcolor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                  child: Text(category['badge']['text'] ?? 'Promo',
                      style: const TextStyle(
                          fontSize: Constants.fontSizeXs, color: Colors.white)),
                ),
              )
            : const SizedBox(width: 0, height: 0)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Constants.spacing6),
      color: Constants.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GridView.count(
            padding: EdgeInsets.zero,
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(categories.length, (index) {
              return aCategoryIcon(context, categories[index]);
            }),
          )
        ],
      ),
    );
  }
}
