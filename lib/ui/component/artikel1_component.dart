import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:tailwind_style/tailwind_style.dart';
import 'package:url_launcher/url_launcher.dart';

class Article1Component extends StatefulWidget {
  final dynamic section,onClick;
  const Article1Component({
    Key? key,
    this.section,
    this.onClick,
  }) : super(key: key);

  @override
  State<Article1Component> createState() => _Article1ComponentState();
}

class _Article1ComponentState extends State<Article1Component> {


  Future<void> _launchUrl(_url) async {
    
    final Uri url = Uri.parse(_url);
    if (!await launchUrl(
      url,mode: LaunchMode.externalApplication,
    )) {
      
      AppDialog.snackBar(
          text: "Tidak dapat membuka aplikasi Tokopedia, Silahkan coba lagi nanti");
      throw Exception('Could not launch $_url');
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return ContainerTailwind(
      // padding: EdgeInsets.symmetric(horizontal: Constants.spacing4,vertical: Constants.spacing4),
      extClass: widget.section['class'] ?? '',
      child: Html(data: widget.section['htmlText'] ?? "",onLinkTap: (url, attributes, element)async {
       print("url $url");
       print("attributes $attributes");
       print("element $element");
       await _launchUrl(url);
      },)
      );
  }
}
