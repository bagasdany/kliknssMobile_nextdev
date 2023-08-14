// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kliknss77/application/builders/data_builder.dart';
import 'package:kliknss77/application/builders/error_builder.dart';
import 'package:kliknss77/application/builders/shimmer_builder.dart';
import 'package:kliknss77/infrastructure/apis/home_api/home_api.dart';
import 'package:kliknss77/infrastructure/database/data_state.dart';
import 'package:kliknss77/ui/view_builder/master_layout/master_detail.dart';
import 'package:kliknss77/ui/view_builder/master_layout/master_eins.dart';

class MasterBuilder extends StatefulWidget {
  dynamic section, defaultImageUrl, title, flashSalescrollController, id,url,shimmer;

  final Function? onRefresh;
  MasterBuilder(
      {Key? key,
      this.onRefresh,
      this.flashSalescrollController,
      this.section,
      this.id,
      //new
      this.url,
      this.shimmer,
      })
      : super(key: key);

  @override
  _MasterBuilderState createState() => _MasterBuilderState();
}

class _MasterBuilderState extends State<MasterBuilder> {
  int? state = 1;
  dynamic datas;
  Widget? widgets;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_)async {
    
        datas  = DataBuilder((widget.url ?? "").replaceFirst(RegExp(r'^/'), ''),).getDataState().getDataWidgets();
        if((datas['data']['data']?['url'] == "${widget.url}")) {
          setState(() {
            state = 5;
            widgets = datas['widgets'];
          });
        } else {
          await HomeApi().patchPage(((widget.url ?? "")).replaceFirst(RegExp(r'^/'), '') ).then((value) {
           print("load lagi");
           if(value is int){
            setState(() {
              state = value;
            });
           }else {
            setState(() {
              datas = value;
              state =1;
            });
            final DataState dataState = DataBuilder((widget.url ?? "").replaceFirst(RegExp(r'^/'), ''),).getDataState();
            final Map<String, dynamic> newData = {
              'type': (widget.url ?? "").replaceFirst(RegExp(r'^/'), ''),
              'data': value ?? {},
            };
            dataState.updateData(newData);
            dataState.update(newData,getContentWidget(widget.url, datas));
            
           }
          
          

        // }
        });
        }  
    });
  }

  //   Widget buildContent() {
  //   if (datas != null && datas['master'] != null) {
      
  //     return getContentWidget(datas['master']);
  //   } else {
  //     return ErrorBuilder(state: state);
  //   }
  // }

  dynamic getContentWidget( url,datas) {
    var master = {'master': url == "" ? "MasterHome" : "MasterDetail"};
    (datas ?? {}).isNotEmpty ? (datas).addAll(master) : null;
    switch (datas?['master']) {      
      case "MasterHome":
        if (state == 2) {
          return ShimmerBuilder(shimmer: widget.shimmer);
        } else if ((state ?? 2) > 3) {
          return ErrorBuilder(state: state);
        } else if (state == 5) {
          return widgets ?? Container(); //TODO Ganti dengan widget handle error Anda
        } else {
          return MasterEins(
            section: datas,
            state: state,
          );
        }
      case "MasterDetail":
        if (state == 2) {
          return ShimmerBuilder(shimmer: widget.shimmer);
        } else if (state == 5) {
          return widgets ?? Container(); //TODO Ganti dengan widget handle error Anda
        } else if (state == 3) {
          return ErrorBuilder(state: state); //TODO Ganti dengan widget handle error Anda
        }
        
        else {
          return MasterDetail(
            section: datas,
            state: state,
          );
        }
      
      default:
        return ErrorBuilder(state: state);
    }
  }

  

  
  @override
  Widget build(BuildContext context) {
    return getContentWidget(widget.url,datas);
  //   var master = {'master': widget.url == "" ? "MasterHome" : "MasterDetail"};
  //   (datas ?? {}).isNotEmpty ? (datas).addAll(master) : null;

  //   switch (datas?['master']) {      
  //     case "MasterHome":
  //       if (state == 2) {
  //         return ShimmerBuilder(shimmer: widget.shimmer,); // Ganti dengan widget Shimmer Anda
  //       } else if ((state  ?? 2) > 3) {
  //         return ErrorBuilder(state: state,); // Ganti dengan widget error Anda
  //       } else if (state == 5) {
  //         return widgets ?? Container(); //TODO Ganti dengan widget handle error Anda
  //       } else {
  //         return MasterEins(
  //           section: datas,
  //           state: state,
  //         );
  //       }
  //     case "MasterDetail":
  //       if (state == 2) {
  //         return ShimmerBuilder(shimmer: widget.shimmer,); // Ganti dengan widget Shimmer Anda
  //       } else if (state == 5) {
  //         return widgets ?? Container(); //TODO Ganti dengan widget handle error Anda
  //       }  else {
  //         return MasterDetail(
  //           section: datas,
  //           state: state,
  //         );
  //       }
      
  //     default:
  //       return ErrorBuilder(state: state);
  //   }
  }
}
