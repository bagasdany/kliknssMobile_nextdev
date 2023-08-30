// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kliknss77/ui/component/category_icons.dart';
import 'package:kliknss77/ui/component/flashsale_component.dart';
import 'package:kliknss77/ui/component/hmc/hmc_simulation.dart';
import 'package:kliknss77/ui/component/image_component.dart';
import 'package:kliknss77/ui/component/multiguna_view/m2w_simulation.dart';
import 'package:kliknss77/ui/component/thumbnails/hmc_thumbails.dart';
import 'package:kliknss77/ui/component/icon_grid_tipe1.dart';
import 'package:kliknss77/ui/views/motor/hmc_list_view.dart';


class BodyBuilder extends StatefulWidget {
  dynamic section, index, title, flashSalescrollController, id,state;

  final Function? onRefresh;
  BodyBuilder(
      {Key? key,
      this.onRefresh,
      this.state,
      this.flashSalescrollController,
      this.section,
      this.id,
      this.index,
      this.title})
      : super(key: key);

  @override
  _BodyBuilderState createState() => _BodyBuilderState();
}

class _BodyBuilderState extends State<BodyBuilder> {

  void onChanged()async{
    setState(() {});
  }

  Widget _buildSection(BuildContext context, Map section) {

    // MotorAgentView
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
      case 'IconList':
        return CategoryIcons(section['icons'] ?? []);
      case 'Article':
        return MotorAgentView();
      case 'Image':
        return ImageCarousel(
          section: section,
          state: widget.state ?? 1,
          aspectRatio: (section['itemRatio'] ?? []).isNotEmpty ? section['itemRatio'][0] :  null,
          items: section['src'] ?? [],
        );
      // case 'SparepartThumbnails':
      // return SparepartThumbnails(section ?? []);
      case 'HMCThumbnails':
        return HMCThumbnails(section ?? []);
      case 'FeatureList':
        return TitlewithIconGrid1(section: section);
      case 'FlashSale':
        return FlashSaleComponent(section: section?? []);
      case 'M2WSimulation':
        return M2WSimulation();
      case 'HMCList':
        return HMCListView(hmc: section['items']?? [],);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {

  return _buildSection(context, widget.section);
  }

}
