// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kliknss77/ui/component/banner_carousel.dart';
import 'package:kliknss77/ui/component/category_icons.dart';
import 'package:kliknss77/ui/component/multiguna_view/m2w_simulation.dart';
import 'package:kliknss77/ui/component/thumbnails/hmc_thumbails.dart';
import 'package:kliknss77/ui/component/icon_grid_tipe1.dart';


class BodyBuilder extends StatefulWidget {
  dynamic section, defaultImageUrl, title, flashSalescrollController, id,state;

  final Function? onRefresh;
  BodyBuilder(
      {Key? key,
      this.onRefresh,
      this.state,
      this.flashSalescrollController,
      this.section,
      this.id,
      this.defaultImageUrl,
      this.title})
      : super(key: key);

  @override
  _BodyBuilderState createState() => _BodyBuilderState();
}

class _BodyBuilderState extends State<BodyBuilder> {


  Widget _buildSection(BuildContext context, Map section) {
    switch (section['type']) {
      case 'Flex':
        return  ListView.builder(
          padding: const EdgeInsets.all(0),
          addAutomaticKeepAlives: true,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: (section['items'] ?? []).length,
          itemBuilder: ((context, index) {
            return _buildSection(context,section['items'][index]??[]);
          }),
        );
      case 'BannerWidget':
        return BannerCarousel(
          state: widget.state,
          
          aspectRatio: section['props']?['ratio']?[0] ?? 8 / 5.6,
          banners: section['props']?['images'][0] ?? [],
        );
      case 'IconList':
        return CategoryIcons(section['props']['icons'] ?? []);
      case 'HMCThumbnails':
        return HMCThumbnails(section['props'] ?? []);
      case 'FeatureList':
        return TitlewithIconGrid1(section: section);
      case 'M2WSimulation':
        return M2WSimulation();
      default:
        return Container();
    }
  }


  @override
  Widget build(BuildContext context) {

  return _buildSection(context, widget.section);
  }

}
