import 'dart:async';

import 'package:dio/dio.dart';
import 'package:events_emitter/events_emitter.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/builders/data_builder.dart';
import 'package:kliknss77/application/exceptions/sign_in_required.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/infrastructure/database/data_state.dart';
import 'package:kliknss77/infrastructure/database/multiguna_motor/multiguna_motor_data.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/button.dart';
import 'package:kliknss77/ui/component/get_error_message.dart';
import 'package:kliknss77/ui/component/multiguna_view/checkout/m2w_checkout1.dart';
import 'package:kliknss77/ui/views/login/login_view.dart';

class M2WFooterView extends StatefulWidget {
  dynamic state,section;
  Map? page;
  M2WFooterView({this.section,this.state});

  @override
  State<M2WFooterView> createState() => _M2WFooterViewState();
}

class _M2WFooterViewState extends State<M2WFooterView>  {

  MultigunaMotorData _multigunaMotorData = MultigunaMotorData();
  // DataState? dataState = DataBuilder(("multiguna-motor")).getDataState();
  StreamSubscription? _streamSubscription;
  final Dio _dio = DioService.getInstance();
  final _sharedPrefs = SharedPrefs();
  
  @override
  void dispose() {
    _streamSubscription?.cancel();
    // _multigunaMotorData.dispose();
    super.dispose();
  }




  @override
  void initState() {
    super.initState();
    print("initstate footer");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
          widget.page = DataBuilder(("multiguna-motor")).getDataState().getData();
        });
      if(_multigunaMotorData.dataStream != null){
        _streamSubscription = _multigunaMotorData.dataStream?.listen((data) {
          setState(() {
            widget.page = data;
          });
        });
      }
      

      
      
    });
    
  }

  Future<void> checkout(BuildContext context) async {
    setState(() {
      widget.state = 4;
    });
    Future<void> doCheckout() async {
      int cityId = _sharedPrefs.get(SharedPreferencesKeys.cityId) ?? 158;
      
      final response = await _dio.post(Endpoint.checkout, data: {
        'type': 3,
        'cityId': cityId,
        'priceId': widget.page?['data']['priceId'],
        'ownershipId': widget.page?['data']['ownershipId'],
        'price': widget.page?['data']['price'],
        'term': widget.page?['data']['term'],
        'referralCode': widget.page?['data']['referralCode'] ?? "",
        'voucherId': widget.page?['voucher']?.id
      }).timeout(const Duration(seconds: 15));
      final order = response.data['order'];

      setState(() {
        widget.state = 1;
      });
      
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return M2WCheckout1(order);
      }));
    }

    try {
      await doCheckout();
    } on SignInRequiredException {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => LoginView(onSuccess: () async {
            setState(() {
      widget.state = 4;
    });
                await doCheckout().then((value) {
                  setState(() {
      widget.state = 1;
    });
                });
              })));
      setState(() {
        widget.state = 1;
      });
    } on DioException catch (e) {
      String errorMessage =
          GetErrorMessage.getErrorMessage(e.response?.data['errors']);
      AppDialog.snackBar(text: errorMessage);
      setState(() {
        widget.state = 1;
      });
    }on TimeoutException catch (e){
      String errorMessage = "Terjadi Kesalahan silahkan coba lagi nanti";
      AppDialog.snackBar(text: errorMessage);
      setState(() {
        widget.state = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return 
    Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.symmetric(
          vertical: Constants.spacing3,
          horizontal: Constants.spacing4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Button(
            fontSize: Constants.fontSizeLg,
            type: ButtonType.secondary,
            iconSvg: 'assets/svg/message.svg',
            onPressed: () {
              print("data footer = ${widget.page}");
              String ownershipText = '';
            },
          ),
          const SizedBox(width: 8, height: 8),
          Expanded(
              child: 
             Button(
            text: 'Buat Pengajuan',
            iconSvg: 'assets/svg/add.svg',
            fontSize: Constants.fontSizeLg,
            state: 
            widget.state == 4
                ? ButtonState.loading : widget.page?['data']?['isValid'] == true || widget.page?['data']?['isValid'] == "true"  ?ButtonState.normal : ButtonState.disabled,
            onPressed: () {
              print("isValid di footer${widget.page}");
              if (widget.page?['data']?['isValid'] == true) {
                
                checkout(context);
              }
            },
          )
          ) 
        ],
      ),
    );
    // StreamBuilder<Map<dynamic, dynamic>>(
    //   stream: _multigunaMotorData.dataStream, // Stream yang didengarkan
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       // Data diterima dari stream
    //       widget.page = snapshot.data ?? {};
          
    //       // Gunakan data untuk membangun UI
    //       return 
          
    //     } else {
    //       // Stream belum memiliki data
    //       return CircularProgressIndicator();
    //     }
    //   },
    // );
    
    
  }
}