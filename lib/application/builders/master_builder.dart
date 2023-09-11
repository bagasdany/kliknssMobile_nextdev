// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/app/app_log.dart';
import 'package:kliknss77/application/builders/data_builder.dart';
import 'package:kliknss77/application/builders/error_builder.dart';
import 'package:kliknss77/application/builders/shimmer_builder.dart';
import 'package:kliknss77/application/exceptions/sign_in_required.dart';
import 'package:kliknss77/infrastructure/apis/home_api/home_api.dart';
import 'package:kliknss77/infrastructure/database/data_state.dart';
import 'package:kliknss77/ui/view_builder/master_layout/master_detail.dart';
import 'package:kliknss77/ui/view_builder/master_layout/master_home.dart';

class MasterBuilder extends StatefulWidget {
  dynamic section,queryUrl, defaultImageUrl, title, flashSalescrollController, id,url,shimmer;

  final Function? onRefresh;
  MasterBuilder(
      {Key? key,
      this.onRefresh,
      this.flashSalescrollController,
      this.section,
      this.id,
      this.queryUrl,
      //new
      this.url,
      this.shimmer,
      })
      : super(key: key);

  @override
  _MasterBuilderState createState() => _MasterBuilderState();
}

class _MasterBuilderState extends State<MasterBuilder> {
  int? state = 2;
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
    
    WidgetsBinding.instance.addPostFrameCallback((_) async{
    try{
      final value =( datas != null ? datas['data']['data']['url'] ?? '/'  : "") != widget.url ?  await  HomeApi().patchPage(widget.url ?? "") :datas['data'] ;
      
      if(value != null){
        setState(() {
        datas = value;
        state =1;
      });
      final DataState dataState = DataBuilder((widget.url ?? ""),).getDataState();
      final Map<String, dynamic> newData = {
        'type': (widget.url ?? ""),
        'data': value ?? {},
      };
      dataState.updateData(newData);
      // dataState.update(newData,getContentWidget(widget.url, datas));
      }
      }on SignInRequiredException catch (e) {
          
      } on SocketException catch (e) {
      
        // Handle DioException
      } on TimeoutException catch (e) {
          
      }
      on DioException catch (e) {
        
        print("error global 3 $e");
        
        
        print(e);
      } on Error catch (e) {
      
        print("error global 5 $e");
        print(e);
      } finally {

        print("finally");
      }
        
        });
      }

  dynamic getContentWidget( url,datas) {
    var master = {'master': url == "/" ? "MasterHome" : "MasterDetail"};
    (datas ?? {}).isNotEmpty ? (datas).addAll(master) : null;
    switch (datas?['master']) {      
      case "MasterHome":
        if (state == 2) {
          return ShimmerBuilder(shimmer: widget.shimmer);
        }
         else if (state == 5) {
          return widgets ?? Container();
        }
         else if (state == 1) {
          return MasterHome(
            section: datas,
            state: state,
          );
        }else {
          return ErrorBuilder(state: state);
        }
      case "MasterDetail":
        if (state == 2) {
          return ShimmerBuilder(shimmer: widget.shimmer);
        } else if (state == 5) {
          return widgets ?? Container(); 
        } else if (state == 1) {
          return MasterDetail(
            section: datas,
            state: state,
          );
        }
        else {
          return ErrorBuilder(state: state); 
        }
      
      default:
        return ErrorBuilder(state: state);
    }
  }

  

  
  @override
  Widget build(BuildContext context) {
    return 
    state == 5 ? widgets ?? Container() :
    getContentWidget(widget.url,datas);
  
  }
}
