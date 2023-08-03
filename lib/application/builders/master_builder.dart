// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kliknss77/application/builders/data_builder.dart';
import 'package:kliknss77/infrastructure/apis/home_api/home_api.dart';
import 'package:kliknss77/infrastructure/database/data_page.dart';
import 'package:kliknss77/infrastructure/database/data_state.dart';
import 'package:kliknss77/ui/view_builder/master_layout/master_eins.dart';

class MasterBuilder extends StatefulWidget {
  dynamic section, defaultImageUrl, title, flashSalescrollController, id,url,state;

  final Function? onRefresh;
  MasterBuilder(
      {Key? key,
      this.onRefresh,
      this.flashSalescrollController,
      this.section,
      this.id,
      //new
      this.url,
      this.state
      })
      : super(key: key);

  @override
  _MasterBuilderState createState() => _MasterBuilderState();
}

class _MasterBuilderState extends State<MasterBuilder> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
        
        // widget.section =  AppPage.pages; 
        // if( AppPage.pages[widget.url]  == null){
        // print("load lagi");
          widget.state = 2;
        // setState(() {
        
        // });
        final DataBuilder dataBuilders = DataBuilder(("multiguna-motor").replaceFirst(RegExp(r'^/'), ''),);
          final DataState dataStates = dataBuilders.getDataState();
          final Map<String, dynamic> datas = dataStates.getData();
          print("");
        if((datas['data']?['url'] ?? "-").replaceFirst(RegExp(r'^/'), '') == (widget.url ?? "").replaceFirst(RegExp(r'^/'), '')) {
          print("tidak load lagi");
          setState(() {
           widget.section = datas['data'];
            widget.state = 1;
          });
        } else {
          print("load lagi");
          await HomeApi().patchPage(((widget.url ?? "")).replaceFirst(RegExp(r'^/'), '') ).then((value) {
          
          setState(() {
            widget.section = value;
            // AppPage.updatePageData(((widget.url ?? "")).replaceFirst(RegExp(r'^/'), '')  ?? "", value ?? {});
            widget.state = 1;
          });
          final DataBuilder dataBuilder = DataBuilder((widget.url ?? "").replaceFirst(RegExp(r'^/'), ''),);
          final DataState dataState = dataBuilder.getDataState();
          final Map<String, dynamic> data = dataState.getData();

          final Map<String, dynamic> newData = {
            'type': (widget.url ?? "").replaceFirst(RegExp(r'^/'), ''),
            'data': value ?? {},
          };
          dataState.updateData(newData);
          print("dataState ${dataState.getData()}");
          final Map<String, dynamic> updatedData = dataState.getData();
          print('Updated Data: $updatedData');

        // }
        });
        }
       
        // } else{
        //   print("load lagi ${AppPage.pages[(widget.url ?? "")]}");
        //   setState(() {
        //     print("load lagi udah ada ");
        //     widget.state = 1;
        //   });
        // }
        
        
         
    });
  }
  
  @override
  Widget build(BuildContext context) {
    
    var master = {'master': "MasterNormal"};
    (widget.section ?? {}).isNotEmpty ? (widget.section).addAll(master) : null;
    
   
    switch (widget.section?['master']) {
      
      case "MasterNormal":
        return 
        // widget.state == 2 ? AppShimmer(
        //   active: widget.state == 2,
        //   child: Scaffold(
        //     backgroundColor: Constants.white,
        //     body:  Container(
        //     color: Constants.amber,
        //     height: MediaQuery.of(context).size.height, width:  MediaQuery.of(context).size.width,),)):
        MasterEins(
         section: widget.section,
         state: widget.state,
        );
      default:
        return Container();
    }
  }
}
