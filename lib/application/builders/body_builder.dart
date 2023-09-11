
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/banner_carousel.dart';
import 'package:kliknss77/ui/component/category_icons.dart';
import 'package:kliknss77/ui/component/flashsale_component.dart';
import 'package:kliknss77/ui/component/hmc/hmc_simulation_agent.dart';
import 'package:kliknss77/ui/component/image_component.dart';
import 'package:kliknss77/ui/component/m2w/m2w_simulation_agent.dart';
import 'package:kliknss77/ui/component/multiguna_view/m2w_simulation.dart';
import 'package:kliknss77/ui/component/text_block_component.dart';
import 'package:kliknss77/ui/component/thumbnails/hmc_thumbails.dart';
import 'package:kliknss77/ui/component/icon_grid_tipe1.dart';
import 'package:kliknss77/ui/view_builder/master_layout/master_detail.dart';
import 'package:kliknss77/ui/views/motor/hmc_list_view.dart';
import 'package:tailwind_style/tailwind_style.dart';


class BodyBuilder extends StatefulWidget {
  dynamic section, index, title, id,state,url;
  final Function? onRefresh;
  BodyBuilder(
      {Key? key,
      this.state,
      this.url,
      this.section, 
      this.id,
      this.onRefresh,
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
        return FlexTailwind(
          mainClass: section['class'] ?? '',
          bgImage: "${Constants.baseURLImages}${section['bgImage'][0]['imageUrl']}",

          children: [
          for (var item in section['items'] ?? [])
            _buildSection(context, item ?? {})
        ]);
      case 'IconList':
        return CategoryIcons(section['icons'] ?? []);
      case 'TextBlock':
        return TextBlockComponent(section: section ?? []);
      case 'Article':
        return MotorAgentView();
      case 'Box':
        return M2WAgentView();
      // case 'Image':
      //   return ImageCarousel(
      //     section: section,
      //     state: widget.state ?? 1,
      //     aspectRatio: (section['itemRatio'] ?? []).isNotEmpty ? section['itemRatio'][0] :  null,
      //     items: section['src'] ?? [],
      //   );
      // case 'Carousel':
      //   return BannerCarousel(
      //     state: widget.state,
          
      //     aspectRatio: section['ratio']?[0] ?? 8 / 5.6,
      //     items: section['items'] ?? [],
      // );
      // case 'SparepartThumbnails':
      // return SparepartThumbnails(section ?? []);
      case 'HMCThumbnails':
        return HMCThumbnails(section ?? []);
      case 'FeatureList':
        return TitlewithIconGrid1(section: section);
      case 'FlashSale':
        return FlashSaleComponent(section: section?? []);
      case 'M2WSimulation':
        
        // widget.parent?.setButtonNavbar(3);
        return M2WSimulation(
          url: widget.url ?? "",
        );
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
