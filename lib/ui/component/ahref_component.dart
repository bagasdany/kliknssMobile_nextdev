import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:tailwind_style/tailwind_style.dart';
import 'package:url_launcher/url_launcher.dart';

class Ahref extends StatefulWidget {
  Map? section;
   Ahref({this.section, super.key});

  @override
  State<Ahref> createState() => _AhrefState();
}

class _AhrefState extends State<Ahref> {

  Future<void> _launchUrl(_url) async {
    
    final Uri url = Uri.parse(_url);
    if (!await launchUrl(
      url,mode: LaunchMode.externalApplication,
    )) {
      
      AppDialog.snackBar(
          text: "Tidak dapat membuka, Silahkan coba lagi nanti");
      throw Exception('Could not launch $_url');
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        await _launchUrl(widget.section?['href'] ?? "");
      },
      child: Row(
        children: [
          Expanded(
            child: ContainerTailwind(
              // margin: EdgeInsets.symmetric(vertical: 100),
              padding:  const EdgeInsets.symmetric(horizontal: Constants.spacing4,vertical: Constants.spacing2),
              borderRadius: BorderRadius.circular(Constants.spacing2),
              extClass: widget.section?['class'] ?? '',
              child: TextTailwind(
                mainClass: widget.section?['class'] ?? '',
                text: widget.section?['text'] ?? "",
                textAlign: TextAlign.center,
                // textStyle: const TextStyle(color: Colors.red),
              )
            ),
          ),
        ],
      ),
    );
  }
}