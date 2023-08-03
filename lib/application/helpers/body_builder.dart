// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class BodyBuilder extends StatefulWidget {
  dynamic section, defaultImageUrl, title, flashSalescrollController, id;

  final Function? onRefresh;
  BodyBuilder(
      {Key? key,
      this.onRefresh,
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
  @override
  Widget build(BuildContext context) {
    switch (widget.section['type']) {
      // // Flash Sale
      // case "FlashSale":
      //   return FlashSaleComponent(
      //     section: widget.section,
      //   );
      // //hmc
      // case "HMCThumbnails":
      //   return HMCThumbnails(widget.section);

      // case "HMCDetail":
      //   return Motor(id: widget.section['series']?['id'],hmc: widget.section,);

      // case "hmc":
      //   return HMCThumbnails(widget.section);

      // //Sparepart
      // case "SparepartThumbnailsWithBrand":
      //   return SparepartThumbnailWithBrand(widget.section);

      // case "sparepart":
      //   return SparepartThumbnailWithBrand(widget.section);

      // case "SparepartList":
      //   return SparepartThumbnailWithBrand(widget.section);
        
      // case "SparepartCategories":
      //   return SparepartThumbnailWithBrand(widget.section);

      // case "recommendation":
      //   return SparepartThumbnailWithBrand(widget.section);

      // //m2w
      // case "M2":
      //   return M2Section(widget.section);

      // // Deskripsi tiap bisnis
      // case 'title-description-link':
      //   return TitleDescriptionLinkSection(
      //     title: widget.section['title'],
      //     link: widget.section['link'],
      //     description: widget.section['description'],
      //     link_text: widget.section['link_text'],
      //   );

      // // Syarat Pengajuan
      // case 'TitleWithIconGrid':
      //   List<Map> gridItems = (widget.section['items'] as List)
      //       .map((item) => item as Map)
      //       .toList();
      //   return TitlewithIconGrid(
      //     grid: gridItems,
      //     items: widget.section,
      //   );
      // // Kelebihan tiap bisnis
      // case 'TitleWithIconGrid2':
      //   List<Map> gridItems = (widget.section['items'] as List)
      //       .map((item) => item as Map)
      //       .toList();
      //   return TitlewithIconGrid2(
      //     grid: gridItems,
      //     items: widget.section,
      //   );

      // case 'DiscussionSection':
      //   List<Map> items = (widget.section['data']['items'] as List)
      //       .map((item) => item as Map)
      //       .toList();
      //   String? type = widget.section['data']['type'];
      //   return DiskusiComponent(
      //     deskripisiItem: widget.section,
      //     item: items,
      //     image: widget.defaultImageUrl,
      //     title: widget.title,
      //     type: type,
      //     onrefresh: () {
      //       if (widget.onRefresh != null) {
      //         widget.onRefresh!();
      //       }
      //     },
      //   );

      // case 'ReviewSection':
      //   List<Map> items = ((widget.section['reviews'] ?? []) as List)
      //       .map((item) => item as Map)
      //       .toList();
      //   // String? type = widget.section['data']['type'];
      //   return items.isEmpty
      //       ? const EmptyReview()
      //       : UlasanComponent(
      //           deskripisiItem: widget.section,
      //           item: widget.section,
      //           id: widget.id,

      //           items: items,
      //           image: widget.defaultImageUrl,
      //           title: widget.title,
      //           // type: type,
      //           onrefresh: () {
      //             if (widget.onRefresh != null) {
      //               widget.onRefresh!();
      //             }
      //           },
      //         );

      // case 'faq':
      //   List<List<String>> faqItems = List<List<String>>.from(widget
      //       .section['faq']
      //       .map((x) => List<String>.from(x.map((x) => x))));
      //   return FAQSection(faq: faqItems);
      // // (response.data['orders'] as List).map((item) => item as Map).toList();

      default:
        return Container();
    }
  }
}
