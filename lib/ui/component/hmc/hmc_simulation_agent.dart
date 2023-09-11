// ignore_for_file: must_be_immutable, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dio/dio.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:events_emitter/emitters/event_emitter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart' as intl;
import 'package:kliknss77/application/builders/data_builder.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/models/vouchers_models.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/infrastructure/database/agent/motor/hmc_agent_data.dart';
import 'package:kliknss77/infrastructure/database/data_page.dart';
import 'package:kliknss77/infrastructure/database/data_state.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/app_shimmer.dart';
import 'package:kliknss77/ui/component/button_agent.dart';
import 'package:kliknss77/ui/component/dio_exceptions.dart';
import 'package:kliknss77/ui/component/empty_motorId.dart';
import 'package:kliknss77/ui/component/get_error_message.dart';
import 'package:kliknss77/ui/component/handle_error/network_error.dart';
import 'package:kliknss77/ui/component/hmc/selectable_item_agent.dart';
import 'package:kliknss77/ui/component/icon_refresh_indicator.dart';
import 'package:kliknss77/ui/component/page404.dart';
import 'package:kliknss77/ui/component/price_table.dart';
import 'package:kliknss77/ui/component/zoom_interactive_component.dart';
import 'package:kliknss77/ui/views/agent/hmc/checkout_hmc_agent1.dart';
import 'package:kliknss77/ui/views/login/login_view.dart';
import '../../../../application/app/app_log.dart';
import '../../../../application/exceptions/sign_in_required.dart';
import '../../../../infrastructure/apis/misc_api.dart';
import '../../../../infrastructure/database/shared_prefs.dart';

class MotorAgentView extends StatefulWidget {
  // int id;
  int? cityId;
  Map? hmc = DataBuilder(("motor-agent")).getDataState().getData()['simulation'];
  Map? queryUrl;
  Voucher? voucher;
  MotorAgentView({
    Key? key,
    this.hmc,
    this.queryUrl,
    // required this.id,
  }) : super(key: key);

  @override
  _MotorAgentView createState() => _MotorAgentView();
}

class _MotorAgentView extends State<MotorAgentView> {
  late TransformationController controller;
  TextEditingController dpController = TextEditingController();
  TextEditingController tenorController = TextEditingController();
  TextEditingController cicilanController = TextEditingController();
  late AnimationController animationController;
  StreamSubscription? _streamSubscription;
  Animation<Matrix4>? animation;
  final Dio _dio = DioService.getInstance();
  final formatter = intl.NumberFormat.decimalPattern();
  final events = EventEmitter();

  //DATA

  MotorAgentData motorAgentData = MotorAgentData();

  DataState? dataState = DataBuilder(("motor-agent")).getDataState();
  

  int state = 1; // 1:done 2:loading 3:load price -1:error

  final _sharedPrefs = SharedPrefs();
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      widget.hmc?['data']?['kotaId'] = SharedPrefs().get(SharedPreferencesKeys.cityId);
      widget.hmc?['data']?['pilihanKota'] = SharedPrefs().get(SharedPreferencesKeys.cityName);
      

      setState(() {
        widget.hmc =  dataState?.getData() ?? {};
      });
      if (widget.hmc?['data']?['kotaId'] != null && widget.hmc?['data']?['pilihanKota'] != null) {
      MiscApi().patchMotorAgent(widget.hmc?['data']?['kotaId']).then((value) async {
        if (value != null) {
          setState(() {
            widget.hmc?['data']?['listMotor'] = value;
            widget.hmc?['data']?['listStringMotor'] = groupListMotor(value);
          });
        }
      });
    }
    });
    
  }

  
  @override
  void dispose() {
    _streamSubscription?.cancel();
    motorAgentData.dispose();
    super.dispose();
  }


  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void resetAnimation() {
    animation = Matrix4Tween(
      begin: controller.value,
      end: Matrix4.identity(),
    ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn));
    animationController.forward(from: 0);
  }

List<String> groupListMotor(List<Map<dynamic, dynamic>> items) {
  List<String> names = [];

  items.forEach((itemMap) {
    List<dynamic>? itemList = itemMap['items'];
    itemList?.forEach((item) {
      String name = item['name'];
      names.add(name);
    });
  });

  return names;
}

  List<int> createValuesInRange(List<int> ranges) {
    int start = ranges.first;
    int end = ranges[1];
    int step = ranges.last;

    //  valuesInRange = [];

    while (start < end) {
      widget.hmc?['data']?['valuesInRange'] ?? [].add(start);
      start += step;
    }

    return widget.hmc?['data']?['valuesInRange'] ?? [];
  }

  Future<void> checkout(BuildContext context) async {
    setState(() {
      state = 5;
    });
    Future<void> doCheckout() async {
      int otrPrice = (widget.hmc?['data']?['prices'] ?? []).isNotEmpty
        ? widget.hmc?['data']['prices'][0]?['price'] ?? 99999999
        : 99999999;
      var params = {
        'type': 11,
        'cityId': widget.hmc?['data']?['kotaId'],
        "colorId":  widget.hmc?['data']?['colorId'],
        'seriesId': widget.hmc?['data']?['idMotor'],
        'typeId': widget.hmc?['data']?['typeId'],
        'paymentMethod': widget.hmc?['data']?['paymentType'],
        'price': widget.hmc?['data']?['paymentType'] == 1
            ? (otrPrice ?? 99999999)  
            : int.parse( (dpController.text).replaceAll(",","")),
        'term': int.parse(widget.hmc?['data']?['pilihanTenor'] ?? "35"),
        
      };
      print("params $params");
      final response = await _dio.post(Endpoint.checkout, data: params);
      final order = response.data['order'];

      setState(() {
        state = 1;
      });

      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return HMCAgentCheckout1(order);
      }));
    }

    try {
      await doCheckout();
    } on SignInRequiredException {
      setState(() {
        state = 1;
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => LoginView(onSuccess: () async {
                await doCheckout();
              })));
    } on DioException catch (e) {
      String errorMessage =
          GetErrorMessage.getErrorMessage(e.response?.data['errors']);
      AppDialog.snackBar(text: errorMessage);
      setState(() {
        state = 1;
      });
    } on SocketException {
      setState(() {
        state = 1;
      });
      AppDialog.snackBar(text: "Tidak ada koneksi internet");
    } catch (e) {
      setState(() {
        state = 1;
      });
      AppDialog.snackBar(text: "Terjadi kesalahan");
    }
    finally{
      setState(() {
        state = 1;
      });
    }
  }

  Future<void> expandableDialogOnBoarding(data) async {
      AppDialog.showBottomSheetExpandable(
          context: context,
          
          maxChildSize: 0.97,
          minChildSize: 0.58,
          iconClose: true,
          initialChildSize: 0.6,
          textHeader: "Buat Pengajuan ?",
          statefulbuilder: StatefulBuilder(builder: (context, setParentState) {
            return Container(
              color: Constants.white,
              child: Column(
                children: [
                  Container(
                    color: Constants.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: Constants.spacing4,
                        vertical: Constants.spacing2),
                    margin:
                        const EdgeInsets.fromLTRB(0, Constants.spacing4, 0, 0),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          imageUrl:  widget.hmc?['data']?['imageUrl'],
                          errorWidget: (context, url, error) {
                            return Container();
                          },
                        ),
                        Expanded(
                          child: Container(
                            color: Constants.white,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Text(
                                          "${widget.hmc?['data']?['typeName']}/${widget.hmc?['data']?['colorName']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: Constants.fontSizeLg),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Constants.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: Constants.spacing4,
                        vertical: Constants.spacing2),
                    margin: const EdgeInsets.fromLTRB(
                        0, Constants.spacing4, 0, Constants.spacing4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Constants.white,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: const Column(
                                            children: [
                                              Text(
                                                "Uang Muka",
                                                style: TextStyle(
                                                    fontSize:
                                                        Constants.fontSizeSm),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: Constants.spacing1,
                                ),
                                Container(
                                  color: Constants.white,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Rp. ${formatter.format(data['price'] ?? 0)}",
                                                style: const TextStyle(
                                                    fontFamily: Constants
                                                        .primaryFontBold,
                                                    fontSize:
                                                        Constants.fontSizeLg),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Constants.white,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: const Column(
                                            children: [
                                              Text(
                                                "Cicilan/bulan",
                                                style: TextStyle(
                                                    fontSize:
                                                        Constants.fontSizeSm),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: Constants.spacing1,
                                ),
                                Container(
                                  color: Constants.white,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Rp. ${formatter.format(data['installment'] ?? 0)} / ${data['term']}x",
                                                style: const TextStyle(
                                                    fontFamily: Constants
                                                        .primaryFontBold,
                                                    fontSize:
                                                        Constants.fontSizeLg),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.fromLTRB(
                        Constants.spacing4,
                        Constants.spacing3,
                        Constants.spacing4,
                        Constants.spacing6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8, height: 8),
                        Expanded(
                            child: ButtonAgent(
                          text: 'Buat Pengajuan',
                          iconSvg: 'assets/svg/add.svg',
                          fontSize: Constants.fontSizeLg,
                          //TODO : bisa dipencet kalau Price ID ada isinya dan tenornya udah dipilih,dp bayar...dan [terms] = [] ..,city ada (cash , otr price null/angka) (credit,terms.isNotEmpty ?? []) otrPrice
                          state: state == 5
                              ? ButtonState.loading
                              : !widget.hmc?['data']?['valid']
                                  ? ButtonState.disabled
                                  : ButtonState.normal,
                          onPressed: () {
                            dynamic cityIdPrefs =
                                _sharedPrefs.get(SharedPreferencesKeys.cityId);

                            if (widget.hmc?['data']?['valid'] &&
                                cityIdPrefs != null &&
                                (widget.hmc?['data']?['paymentType'] == 2 ||
                                    widget.hmc?['data']?['paymentType'] == 1)) {
                              // checkout(context);
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return HMCAgentCheckout1({});
                              }));
                            } else if (cityIdPrefs == null) {
                              AppDialog.snackBar(
                                  text:
                                      "Silahkan pilih lokasi terlebih dahulu");
                            }
                          },
                        ))
                      ],
                    ),
                  ),
                ],
              ),
            );
          }));
    }


  Future<void> selectCity(
    BuildContext context,
  ) async {

    final kota = await AppDialog.openCitySelectoAgent();
    
    if (kota != null) {
      
      setState(() {

      // widget.hmc?['data'] = null;
       widget.hmc?['data']?['prices'] = null;
        widget.hmc?['data']?['pilihanKota'] = kota['alias'] ?? "";
        widget.hmc?['data']?['kotaId'] = kota['id'] ?? "";
        widget.hmc?['data']?['idMotor'] = null;
        widget.hmc?['data']?['namaSeries'] = null;
        // 
        // print("emit remove 0");
        // AppPage.remove('kelurahan-selector');
        // print("emit remove 1");
        
        MiscApi().patchMotorAgent(kota['id']).then((value) async {
          if (value != null) {
            await _sharedPrefs.set(SharedPreferencesKeys.cityId, kota['id']);
            await _sharedPrefs.set(SharedPreferencesKeys.cityName, kota['alias']);
            setState(() {
              widget.hmc?['data']?['listMotor'] = value;
              widget.hmc?['data']?['listStringMotor'] = groupListMotor(value);
              // dataState?.update(widget.hmc ?? {},MotorAgentView());
              // dataState?.updateData(widget.hmc ?? {});
              // motorAgentData.dataStreamController.sink.add(widget.hmc ?? {});
              events.emit('locationChanged', kota['id']);
              print("emit 1");
            });
          }
        });

        events.emit('locationChanged', kota['id']);
        print("emit 2");
      });
      await SharedPrefs().set(SharedPreferencesKeys.cityId, kota['id']);

      events.emit('locationChanged', kota['id']);
      print("emit 3");
    }
    else{
      print("kota null");
    }
  }

  Widget buildPilihanKota() {
    return Container(
      color: Constants.white,
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.spacing4, vertical: Constants.spacing2),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: const Text(
                  'Pilih Kota',
                  style: TextStyle(
                    fontSize: Constants.fontSizeMd,
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              selectCity(
                context,
              );
            },
            child: Container(
                margin: const EdgeInsets.only(top: Constants.spacing1),
                // ignore: prefer_const_constructors
                padding: const EdgeInsets.fromLTRB(Constants.spacing3,
                    Constants.spacing2, Constants.spacing4, Constants.spacing2),
                decoration: BoxDecoration(
                  border: Border.all(color: Constants.gray.shade100),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(Constants.spacing3)),
                  color: Constants.gray.shade100,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: Constants.spacing2),
                      child: Text(
                        widget.hmc?['data']?['pilihanKota'] != null ? widget.hmc?['data']?['pilihanKota'] ?? "" : "pilih Kota",
                        style: const TextStyle(color: Constants.black),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                    SvgPicture.asset('assets/svg/chevron_down.svg',
                        width: 21, height: 21, color: Constants.gray)
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    if (widget.hmc?['data'] != null) {
      var images = ((widget.hmc?['data']?['images'] ?? []) as List).where((image) {
        return image['typeId'] == widget.hmc?['data']?['typeId'] &&
            image['colorId'] == widget.hmc?['data']?['colorId'];
      }).toList();

      widget.hmc?['data']?['imageUrl'] = images != null && images.length > 0 ? images[0]['url'] : '';
    }

    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height * .7;

    // TODO : Untuk adv , widget.hmc?['data']['typeId'] & colorId tidak sesuai dengan apa yg didalam image
    return Column(
      children: [
        ZoomInteractive(
          url:  widget.hmc?['data']?['imageUrl'],
          state: state,
        ),
        const SizedBox(width: 0, height: Constants.spacing2),
      ],
    );
  }

  void validate() {
    var _valid = widget.hmc?['data']?['kotaId'] != null &&
        state == 1 &&
        (((widget.hmc?['data']?['paymentType'] ?? -1) == 2) ||
            ((widget.hmc?['data']?['paymentType'] ?? -1) == 1)) &&
        ((widget.hmc?['data']?['paymentType'] ?? -1) == 2
            ? widget.hmc?['data']?['pilihanTenor'] != null
            : true) &&
        ((widget.hmc?['data']?['paymentType'] ?? -1) == 2 ? widget.hmc?['data']?['jumlahDP'] != null : true) &&
        ((widget.hmc?['data']?['paymentType'] ?? -1) == 2
            ? cicilanController.text != null
            : true);
    setState(() {
      widget.hmc?['data']?['valid'] = _valid;
    });
    print("widget.hmc?['data']?['valid'] $widget.hmc?['data']?['valid']");
  }

  bool canCheckout() {
    print("masuk checkout");
    print("payment type ${widget.hmc?['data']?['paymentType']}");
    return widget.hmc?['data']?['kotaId'] != null &&
        state == 1 &&
        (((widget.hmc?['data']?['paymentType'] ?? -1) == 2) ||
            ((widget.hmc?['data']?['paymentType'] ?? -1) == 1)) &&
        ((widget.hmc?['data']?['paymentType'] ?? -1) == 2
            ? widget.hmc?['data']?['pilihanTenor'] != null
            : true) &&
        ((widget.hmc?['data']?['paymentType'] ?? -1) == 2 ? widget.hmc?['data']?['jumlahDP'] != null : true) &&
        ((widget.hmc?['data']?['paymentType'] ?? -1) == 2
            ? cicilanController.text != null
            : true);
  }

  Future<dynamic> patch(id) async {
    var params = {"cityId": widget.hmc?['data']?['kotaId']};
    try {
      final response =
          await _dio.patch("${Endpoint.getMotordetail}/${id}", data: params);
      if (response.data != null || response.data == "") {
        setState(() {
          state = -1;
        });
        AppLog().logScreenView("HMC nonaktif");
      }
      return response.data;
    } on DioException catch (e) {
      dynamic errors = DioExceptions.fromDioError(e);
      if (errors != null) {
        if (errors.message == "No Internet") {
          setState(() {
            state = -2;
          });
        } else {
          setState(() {
            state = -1;
          });
        }
      }
    }
  }

  Widget buildSeries() {
    return Container(
      color: Constants.white,
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.spacing4, vertical: Constants.spacing2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: Constants.spacing1),
                child: const Text(
                  'Pilih Series',
                  style: TextStyle(
                    fontSize: Constants.fontSizeMd,
                  ),
                ),
              ),
            ],
          ),
          InkWell(
              onTap: () async {
                FocusScope.of(context).unfocus();
                setState(() {
                  state = 2;
                });
                String? stringMotor = await AppDialog.showTextSelector(
                    context,
                    (widget.hmc?['data']?['listMotor'] ?? [] as List)
                        .map((item) => item['name'] as String)
                        .toList(),
                    title: 'Pilih Series');
                if (stringMotor == "" || stringMotor == null) {
                  setState(() {
                    state = 1;
                  });
                } else {
                  setState(() {
                    widget.hmc?['data']?['namaSeries'] = stringMotor;
                    widget.hmc?['data']?['idMotor'] = (widget.hmc?['data']?['listMotor'] ?? [])
                        ?.where((e) => e['name'] == stringMotor)
                        .toList()[0]['id'];
                  });
                  await MiscApi()
                      .patchMotorAgentwithSeries(widget.hmc?['data']?['kotaId'], widget.hmc?['data']?['idMotor'])
                      .then((value) {
                    if (value == null || value == "") {
                      AppLog().logScreenView("Detail HMC nonaktif");
                      setState(() {
                        validate();
                        state = 1;
                      });
                    } else {
                      setState(() {
                        if (value != "" || value != null) {
                          (widget.hmc?['data'] as Map).addEntries(value.entries);

                          print(
                              "colors di pilih series ${widget.hmc?['data']?['colorId']}");
                          if (widget.hmc?['data']?['colorId'] == null) {
                            widget.hmc?['data']?['colorId'] = value['colorId'] ?? 111;
                          }
                          if (widget.hmc?['data']?['typeId'] == null) {
                            widget.hmc?['data']?['typeId'] = value['typeId'] ?? 111;
                          }
                          state = 1;
                        }
                        widget.hmc?['data']?['typeName'] =
                            value['types']?[0]?['name'] ?? "";

                        widget.hmc?['data']?['colorName'] =
                            value['colors']?[0]?['name'] ?? "";

                        if ((value['prices'] ?? []).isNotEmpty) {
                          cicilanController.value = TextEditingValue(
                            text: formatter.format(
                                value['prices']?[1]?['installment'] ?? 0),
                          );
                          dpController.value = TextEditingValue(
                            text: formatter
                                .format(value['prices']?[1]?['price'] ?? 0),
                          );
                          cicilanController.value = TextEditingValue(
                            text: formatter.format(
                                value['prices']?[1]?['installment'] ?? 0),
                          );

                          widget.hmc?['data']?['jumlahDP'] =
                              value['prices']?[1]?['price'].toString() ?? "0";
                          widget.hmc?['data']?['jumlahCicilan'] =
                              value['prices']?[1]?['installment'].toString() ??
                                  "0";
                          widget.hmc?['data']?['pilihanTenor'] =
                              value['prices']?[1]?['term'].toString() ?? "0";
                        }

                        widget.hmc?['data']?['termList'] = getTermList(widget.hmc?['data']?['prices'] ?? []);
                        widget.hmc?['data']?['paymentType'] = 2;
                      });
                      // dataState?.update(widget.hmc ?? {},MotorAgentView());
                      // dataState?.updateData(widget.hmc ?? {});
                      // motorAgentData.dataStreamController.sink.add(widget.hmc ?? {});

                      validate();
                    }
                  });
                  setState(() {
                    state = 1;
                  });
                }
              },
              child: Container(
                  padding: const EdgeInsets.fromLTRB(
                      Constants.spacing3,
                      Constants.spacing2,
                      Constants.spacing4,
                      Constants.spacing2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Constants.gray.shade100),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(Constants.spacing3)),
                    color: Constants.gray.shade100,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: Constants.spacing2),
                        child: Text(
                          widget.hmc?['data']?['namaSeries'] != null ? widget.hmc?['data']?['namaSeries'] ?? "" : "pilih Motor",
                          style: const TextStyle(color: Constants.black),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                      SvgPicture.asset('assets/svg/chevron_down.svg',
                          width: 21, height: 21, color: Constants.gray)
                    ],
                  ))),
        ],
      ),
    );
  }

  Widget buildTypeItem(child, active) {
    return Container(
      padding: const EdgeInsets.all(Constants.spacing2),
      color: active ? Colors.white : Constants.gray.shade100,
      child: child,
    );
  }

  Widget buildTypeSelector() {
    print("color di buildtype ${widget.hmc?['data']?['colorId']}");
    int? typeId = (widget.hmc ?? {})['data'] != {}
            ?(widget.hmc ?? {})['data']['typeId']
            
        : widget.hmc?['data'] != null
            ? (widget.hmc ?? {})['data']['typeId']
            : -1;

    String displayName = '';
    if (widget.hmc?['data'] != null) {
      displayName = ['Honda', widget.hmc?['data']!['name']].join(' ');
    }

    int otrPrice = ((widget.hmc ?? {})['data']?['prices'] ?? []).isNotEmpty
        ? (widget.hmc ?? {})['data']['prices'][0]['price'] ?? 99999999
        : 99999999;
    // widget.hmc?['data']?['prices']?[0]?['price'] ?? 99999999;
    // if (widget.hmc?['data'] != null) {
    //   Map prices = ((widget.hmc?['data']?['prices'] ?? {}) as Map);
    //   if (prices.containsKey('$typeId')) {
    //     otrPrice = prices['$typeId']?[0]?['price'];
    //   }
    // }

    List<Widget> typeWidgets = [];
    if (widget.hmc?['data'] != null) {
      ((widget.hmc?['data']?['types']  ?? [])as List).forEach((type) {
        typeWidgets.add(
          Container(
              margin: const EdgeInsets.fromLTRB(0, 0, Constants.spacing2, 0),
              child: InkWell(
                onTap: () {
                  int colorId = widget.hmc?['data']?['colorId'];
                  bool colorIdExists = false;
                  List<dynamic> typeImages = (widget.hmc?['data']?['images'] as List).where((image) {
                    if (image['typeId'] == type['id']) {
                      if (image['colorId'] == colorId) {
                        colorIdExists = true;
                      }
                      return true;
                    }
                    return false;
                  }).toList();

                  if (!colorIdExists) {
                    colorId = typeImages[0]['colorId'];
                  }

                  setState(() {
                    widget.hmc?['data']?['typeId'] = type['id'];
                    widget.hmc?['data']?['colorId'] = colorId;

                    widget.hmc?['data']?['typeName'] = type['name'];

                    // widget.voucher = null;
                  });
                  MiscApi()
                      .patchMotorAgentwithType(widget.hmc?['data']?['kotaId'], widget.hmc?['data']?['idMotor'], type['id'])
                      .then((value) {
                    if (value == null || value == "") {
                      AppLog().logScreenView("Detail HMC nonaktif");
                      setState(() {
                        validate();
                        state = 1;
                      });
                    } else {
                      setState(() {
                        state = 2;
                      });
                      setState(() {
                        if (value != "" || value != null) {
                          // widget.hmc?['data'] = value ?? {};
                          widget.hmc?['data']?['prices'] = value['prices'] ?? [];
                          // if (widget.hmc?['data']?['colorId'] == null) {
                          //   widget.hmc?['data']?['colorId'] = value['colorId'] ?? 111;
                          // }

                          // if (widget.hmc?['data']?['typeId'] == null) {
                          //   widget.hmc?['data']?['typeId'] = value['typeId'] ?? 111;
                          // }

                          state = 1;
                        }
                        if ((value['types'] ?? []).isNotEmpty) {
                          widget.hmc?['data']?['typeName'] =
                              value['types']?[0]?['name'] ?? "";

                          widget.hmc?['data']?['colorName'] =
                              value['types']?[0]?['name'] ?? "";
                        }

                        // "${formatter.format(price)}/bln"
                        dpController.value = TextEditingValue(
                          text: formatter
                              .format(value['prices']?[1]?['price'] ?? 0),
                          // selection:
                          //     TextSelection.collapsed(offset: formatted.length),
                        );
                        cicilanController.value = TextEditingValue(
                          text: formatter
                              .format(value['prices']?[1]?['installment'] ?? 0),
                          // selection:
                          //     TextSelection.collapsed(offset: formatted.length),
                        );

                        widget.hmc?['data']?['jumlahDP'] =
                            value['prices']?[1]?['price'].toString() ?? "0";
                        //     "${formatter.format(value['prices']?[1]?['price'])}";
                        // value['prices']?[1]?['price'];
                        // print("widget.hmc?['data']?['jumlahDP'] $widget.hmc?['data']?['jumlahDP']");

                        widget.hmc?['data']?['jumlahCicilan'] =
                            value['prices']?[1]?['installment'].toString() ??
                                "0";

                        widget.hmc?['data']?['pilihanTenor'] =
                            value['prices']?[1]?['term'].toString() ?? "0";

                        widget.hmc?['data']?['termList'] = getTermList(widget.hmc?['data']?['prices'] ?? []);
                        widget.hmc?['data']?['paymentType'] = 2;

                        state = 1;
                      });
                    }
                  });
                },
                child: SelectableItemHmcAgent(Text(type['name'],
                              style: const TextStyle(
                                  color: Constants.white,)), type['id'] == typeId,
                    padding: const EdgeInsets.symmetric(
                        vertical: Constants.spacing2,
                        horizontal: Constants.spacing4)),
              )),
        );
      });
    }

    List<Widget> colorWidgets = [];

    print("color di colorWidgets1 ${widget.hmc?['data']?['colorId']}");
    if (widget.hmc?['data'] != null) {
      List<int> colorIds = [];
      ((widget.hmc?['data']?['images'] ?? []) as List).forEach((image) {
        if (image['typeId'] == typeId) {
          colorIds.add(image['colorId']);
        }
      });

      print("color di colorWidgets2 ${widget.hmc?['data']?['colorId']}");

      ((widget.hmc?['data']['colors'] ?? []) as List).forEach((color) {
        if (colorIds.contains(color['id'])) {
          colorWidgets.add(Container(
              margin: const EdgeInsets.fromLTRB(0, 0, Constants.spacing2, 0),
              child: GestureDetector(
                  onTap: () {
                    print("color1 ${color['id']}");

                    print("colors di colorwidget1 ${widget.hmc?['data']?['colorId']}");
                    setState(() {
                      widget.hmc?['data']?['colorId'] = color['id'];
                      widget.hmc?['data']?['colorName'] = color['name'];
                    });

                    print("colors di colorwidget2 ${widget.hmc?['data']?['colorId']}");

                    print("color2 ${color['id']}");
                  },
                  child: SelectableItemHmcAgent(Text(color['name'],
                              style: const TextStyle(
                                  color: Constants.white,)),
                      color['id'] == widget.hmc?['data']?['colorId'],
                      padding: const EdgeInsets.symmetric(
                          vertical: Constants.spacing2,
                          horizontal: Constants.spacing4)))));
        }
      });
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: Constants.spacing4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Constants.spacing4),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, Constants.spacing4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pilihan Tipe:',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm, color: Constants.gray)),
                const SizedBox(height: Constants.spacing1),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: AppShimmer(
                      active: state == 2,
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          children: state == 2
                              ? [
                                  SelectableItemHmcAgent(
                                       Text('Loading...',
                              style: const TextStyle(
                                  color: Constants.white,)), false)
                                ]
                              : typeWidgets,
                        ),
                      ),
                    ))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Constants.spacing4),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, Constants.spacing4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pilihan Warna:',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm, color: Constants.gray)),
                const SizedBox(height: Constants.spacing1),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: AppShimmer(
                    active: state == 2,
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        children: state == 2
                            ? [buildTypeItem(const Text('Loading...'), false)]
                            : colorWidgets,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Constants.spacing4),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, Constants.spacing1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Harga OTR',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm, color: Constants.gray)),
                const SizedBox(height: Constants.spacing1),
                AppShimmer(
                  active: state == 2,
                  child: 
                   otrPrice < 99999999
                              ?
                  Container(
                      color: Colors.white,
                      child: Text(
                          'Rp. ${formatter.format(otrPrice)}',
                          style: const TextStyle(
                              fontSize: Constants.fontSizeXl,
                              fontFamily: Constants.primaryFontBold,),),) : Container(child: 
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child:  Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Harga Tidak Tersedia"),
                                            const SizedBox(width: Constants.spacing4,),
                                            Container(
                                              color: Constants.donker.shade100,
                                              padding: const EdgeInsets.symmetric(horizontal: Constants.spacing2),
                                              child: const Row(
                                                children: [
                                                  Text("Beritahu Saya",style: TextStyle(fontSize: Constants.fontSizeSm,fontFamily: Constants.primaryFontBold),),
                                                  SizedBox(width: Constants.spacing2,),
                                                  Icon(Icons.notifications_on_outlined),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    ),
                                    
                                  ],
                                ),
                              ),
                ),
                // const SizedBox(height: Constants.spacing1),
                // Text(displayName),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCreditForm() {
    // int divisions = (((widget.hmc?['data']?['series']['creditPriceRanges'][1] ?? 2) -
    //             (widget.hmc?['data']?['series']['creditPriceRanges'][0] ?? 1)) /
    //         (widget.hmc?['data']?['series']['creditPriceRanges'][2] ?? 1))
    //     .toInt();

    List<Widget> termWidgets = [];
    int rowCount = ((widget.hmc?['data']?['terms'] ?? []).length / 3).ceil();
    for (var i = 0; i < rowCount; i++) {
      List<Widget> cols = [];
      for (var j = 0; j < 3; j++) {
        int idx = (i * 3) + j;

        if (idx < (widget.hmc?['data']?['terms'] ?? []).length) {
          var term = widget.hmc?['data']?['terms'][idx];
          int price = term['installmentPrice'] ?? -1;
          cols.add(Expanded(
              child: SelectableItemHmcAgent(
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${term['term']}x",
                          style: const TextStyle(
                            color: Constants.white,
                              fontFamily: Constants.primaryFontBold,
                              fontSize: Constants.fontSizeLg)),
                      Text("${formatter.format(price)}/bln",
                          style:
                              const TextStyle(fontSize: Constants.fontSizeXs)),
                    ],
                  ),
                  widget.hmc?['data']?['term'] == term['term'],
                  alignment: Alignment.centerLeft, onTap: () async {
            setState(() {
              widget.hmc?['data']?['term'] = term['term'];
            });
          })));
        } else {
          cols.add(const Expanded(child: Text('')));
        }

        if (j < 2) {
          cols.add(const SizedBox(width: Constants.spacing2));
        }
      }
      Widget row = Row(children: cols);
      termWidgets.add(row);
      if (i < rowCount - 1) {
        termWidgets.add(const SizedBox(height: Constants.spacing2));
      }
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Constants.spacing4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: buildPilihanDP()),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                        constraints: const BoxConstraints(maxWidth: 70),
                        child: buildPilihanTenor()),
                  ),

                  Expanded(
                    flex: 6,
                    child: Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: buildPilihanCicilan()),
                  ),
                  // buildPilihanCicilan()
                ],
              ),
              // buildIndent(),
              // const SizedBox(width: 0, height: Constants.spacing3),
              // buildPilihanDP(),
              // const SizedBox(width: 0, height: Constants.spacing3),
            ],
          ),
        ),
        // buildPilihanTenor(),
        // const SizedBox(width: 0, height: Constants.spacing3),
        // buildPilihanCicilan(),
        // const SizedBox(height: Constants.spacing6),
      ],
    );
  }

  Widget buildEmptyTerms() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
              left: Constants.spacing4,
              right: Constants.spacing4,
              top: Constants.spacing4,
              bottom: Constants.spacing2),
          child: const Text("Simulasi Kredit",
              style: TextStyle(
                  fontSize: Constants.fontSizeLg,
                  fontFamily: Constants.primaryFontBold,
                  color: Constants.gray)),
        ),
        Container(
          padding: const EdgeInsets.all(Constants.spacing4),
          color: Constants.white,
          child: Card(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Constants.spacing4, vertical: Constants.spacing2),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: Constants.spacing2),
                    child: const Text(
                      "Simulasi tidak tersedia",
                      style: TextStyle(
                          color: Constants.gray,
                          fontSize: Constants.fontSizeLg),
                    ),
                  ),
                  const Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Maaf, Simulasi belum tersedia di kota anda.Silahkan pilih lokasi yang berbeda untuk melihat simulasi kredit",
                        style: TextStyle(
                          color: Constants.gray,
                        ),
                      )),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildCashPrice(otrPrice){
    MiscApi().getPriceAgentCash(widget.hmc?['data']?['kotaId'],widget.hmc?['data']?['typeId'],widget.hmc?['data']?['paymentType'],widget.hmc?['data']?['idMotor']).then((value) {
      setState(() {
        otrPrice = value;
        widget.hmc?['data']?['cashPrice'] = value;
      });
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Constants.spacing4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Harga Cash',
                    style: TextStyle(
                        fontSize: Constants.fontSizeSm, color: Constants.gray)),
                const SizedBox(height: Constants.spacing1),
          Container(
            child: Text(otrPrice != 99999999 ? "Rp. ${formatter.format(otrPrice ?? 0)}" : "Harga Tidak Tersedia", style: const TextStyle(
                              fontSize: Constants.fontSizeXl,
                              fontFamily: Constants.primaryFontBold,))
          ),
        ],
      ),
    );
  }

  Widget buildForm() {
    int otrPrice = (widget.hmc?['data']?['prices'] ?? []).isNotEmpty
        ? (widget.hmc ?? {})['data']['prices'][0]['price'] ?? 99999999
        : 99999999;
    int price = widget.hmc?['data']?['paymentType'] == 2
        ? (widget.hmc?['data']?['creditPrice'] ?? 0)
        : (widget.hmc?['data']?['cashPrice'] ?? 0);
    int priceNormal = widget.hmc?['data']?['paymentType'] == 2
        ? (widget.hmc?['data']?['creditPriceNormal'] ?? 0)
        : (widget.hmc?['data']?['cashPriceNormal'] ?? 0);

    return 
    otrPrice < 99999999 ?
    Container(
      margin: const EdgeInsets.symmetric(vertical: Constants.spacing4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Constants.spacing4),
            child: const Text(
              'Buat Pengajuan',
              style: TextStyle(
                  fontSize: Constants.fontSizeLg,
                  fontFamily: Constants.primaryFontBold,
                  color: Constants.gray),
            ),
          ),
          const SizedBox(height: Constants.spacing2),
          Container(
            padding: const EdgeInsets.symmetric(vertical: Constants.spacing2),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.spacing4,
                      vertical: Constants.spacing2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                           const Text('Metode Pembayaran',
                              style: TextStyle(
                                  fontSize: Constants.fontSizeSm,
                                  color: Constants.gray)),
                          SizedBox(width: Constants.spacing1,),
                          InkWell(
                            onTap: () {
                              AppDialog.showBottomSheetExpandable(
                          context: context,
                          maxChildSize: 0.7,
                          textHeader:
                              "Info Penting",
                          minChildSize: 0.4,
                          initialChildSize: 0.41,
                          statefulbuilder:
                              StatefulBuilder(
                                  builder: (context,
                                      setParentState) {
                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: Constants
                                          .spacing4),
                                  color: Constants
                                      .white,
                                  
                                 
                                  child: 
                                  Card(
                                  child:GestureDetector(
                                    onTap: ()async{ await MiscApi().launchWhatsApp();},
                                    child:
                                        const ListTile(
                                          contentPadding: EdgeInsets.symmetric(vertical: Constants.spacing2,horizontal: Constants.spacing4),
                                      title: Text(
                                        'Besaran Komisi tiap metode pembayaran',style: TextStyle(color: Constants.donker),),
                                      subtitle: Text('Metode Cash berkisar 300rb - 750rb\nMetode Kredit berkisar 500rb - 1.5jt'),
                                    ),
                                  ),
                                ),
                                  
                                ),
                                Card(
                                  child:GestureDetector(
                                    onTap: ()async{ await MiscApi().launchWhatsApp();},
                                    child:
                                        const ListTile(
                                      title: Text(
                                        'Masih bingung ? Klik untuk menghubungi Upline',style: TextStyle(color: Constants.donker),),
                                      subtitle: Text('6282135388068 - Bagas'),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }));
                            },
                            child: const Icon(Icons.info_outline,size: 18,color: Constants.gray,)),
                        ],
                      ),
                      const SizedBox(height: Constants.spacing2),
                      AppShimmer(
                        active: state == 2,
                        child: Container(
                            color: Colors.white,
                            child: Row(
                              children: [
                                Expanded(
                                    child: SelectableItemHmcAgent(
                                  const Stack(
                                    alignment: Alignment.center,
                                    children: [

                                      Text('Cash',
                              style:  TextStyle(
                                  color: Constants.white,)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          
                                        ],
                                      ),
                                    ],
                                  ),
                                  widget.hmc?['data'] != null
                                      ? (widget.hmc?['data']?['paymentType'] == 1)
                                      : false,
                                  onTap: () async {
                                    setState(() {
                                      widget.hmc?['data']?['paymentType'] = 1;
                                    });
                                     
                                  },
                                )),
                                const SizedBox(width: Constants.spacing3),
                                Expanded(
                                    child: SelectableItemHmcAgent(
                                        const Text('Kredit',
                              style:  TextStyle(
                                  color: Constants.white,)),
                                        widget.hmc?['data'] != null
                                            ? (widget.hmc?['data']!['paymentType'] == 2)
                                            : false, onTap: () async {
                                  setState(() {
                                    widget.hmc?['data']?['paymentType'] = 2;
                                  });
                                })),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Constants.spacing3),
                widget.hmc?['data']?['paymentType'] == 2 && otrPrice < 99999999
                    ? buildCreditForm()
                    : const SizedBox(),
                 widget.hmc?['data']?['paymentType'] == 1 && otrPrice != 99999999
                    ? buildCashPrice(otrPrice)
                    : const SizedBox(),
                const SizedBox(height: Constants.spacing2),
              ],
            ),
          )
        ],
      ),
    ): Container();
  }

  List<dynamic> getTermList(List<dynamic> response) {
    // List<dynamic> widget.hmc?['data']?['termList'] = response.map((e) => e).toList();

    var data = response;

    List<Map<String, dynamic>> terms = List<Map<String, dynamic>>.from(data);
    List<Map<String, dynamic>> termInstallments = [];

    for (var term in terms) {
      int termValue = term['term'];
      int installmentPrice = term['installment'] ?? 1;

      Map<String, dynamic> termInstallment = {
        'term': termValue,
        'installment': installmentPrice,
      };

      termInstallments.add(termInstallment);
    }

    // Menggunakan List termInstallments
    for (var termInstallment in termInstallments) {
      int term = termInstallment['term'];
      int installmentPrice = termInstallment['installment'];
    }

    List<String> groupItemsKeys = termInstallments
        .groupListsBy((element) => element['term'].toString())
        .keys
        .toList();
    groupItemsKeys.remove('0');
    return groupItemsKeys;
  }

  Widget buildPilihanTenor() {
    return Container(
      color: Constants.white,
      padding: const EdgeInsets.symmetric(horizontal: Constants.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    bottom: Constants.spacing1, top: Constants.spacing1),
                child: const Text(
                  'Pilih Tenor',
                  style: TextStyle(
                    fontSize: Constants.fontSizeSm,
                    color: Constants.gray,
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () async {
              print("widget.hmc?['data']?['termList'] $widget.hmc?['data']?['termList']");
              FocusScope.of(context).unfocus();
              String? stringPilihanTenor = await AppDialog.showTextSelector(
                context,
                (widget.hmc?['data']?['termList'] ?? []).map((item) => item).toList(),
                title: 'Pilih Tenor',
              );
              if (stringPilihanTenor == "" || stringPilihanTenor == null) {
                // setState(() {
                //   widget.hmc?['data']?['pilihanTenor'] = "";
                // });
              } else {
                setState(() {
                  widget.hmc?['data']?['pilihanTenor'] = stringPilihanTenor;
                  widget.hmc?['data']?['termList'] = getTermList(widget.hmc?['data']?['prices']);
                });
              }

              validate();
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(Constants.spacing3,
                    Constants.spacing2, Constants.spacing4, Constants.spacing2),
                decoration: BoxDecoration(
                  border: Border.all(color: Constants.gray.shade100),
                  borderRadius: const BorderRadius.all(Radius.circular(Constants.spacing3)),
                  color: Constants.gray.shade100,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.symmetric(vertical: Constants.spacing2),
                      child: Text(widget.hmc?['data']?['pilihanTenor'] != null? "${widget.hmc?['data']?['pilihanTenor'] ?? ""}x": "Pilih",style: const TextStyle(color: Constants.black),softWrap: true,overflow: TextOverflow.ellipsis,),
                    )),
                    SvgPicture.asset('assets/svg/chevron_down.svg',
                        width: 16, height: 16, color: Constants.gray)
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget buildIndent() {
    return Container(
      color: Constants.white,
      // padding: const EdgeInsets.symmetric(vertical: Constants.spacing2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: Constants.spacing1),
                child: const Text(
                  'Stock Unit',
                  style: TextStyle(
                    fontSize: Constants.fontSizeSm,
                    color: Constants.gray,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Constants.gray.shade100),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(Constants.spacing3)),
                      color: Constants.gray.shade100),
                  padding: const EdgeInsets.fromLTRB(
                      Constants.spacing3,
                      Constants.spacing4,
                      Constants.spacing3,
                      Constants.spacing4),
                  // margin: const EdgeInsets.only(bottom: Constants.spacing1),
                  child: const Text(
                    'Indent 1 bulan',
                    style: TextStyle(
                      // color: Constants.gray,
                      fontSize: Constants.fontSizeMd,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //buatkan widget untuk menampilkan pilihan dp

  Widget buildPilihanDP() {
    return Container(
      color: Constants.white,
      // padding: const EdgeInsets.symmetric(vertical: Constants.spacing2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: Constants.spacing1),
                child: const Text(
                  'Pilih DP',
                  style: TextStyle(
                    fontSize: Constants.fontSizeSm,
                    color: Constants.gray,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: Constants.spacing1),
            // ignore: prefer_const_constructors
            // padding: EdgeInsets.symmetric(vertical: Constants.spacing1),

            decoration: BoxDecoration(
              color: Constants.white,
              borderRadius: BorderRadius.circular(Constants.spacing4),
            ),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: dpController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        String digitsOnly = value.replaceAll(RegExp(r'\D'), '');

                        // Buat string dengan koma setiap tiga digit, dimulai dari akhir string
                        String formatted = '';
                        for (int i = digitsOnly.length - 1; i >= 0; i--) {
                          if ((digitsOnly.length - 1 - i) % 3 == 0 &&
                              i != digitsOnly.length - 1) {
                            formatted = ',' + formatted;
                          }
                          formatted = digitsOnly[i] + formatted;
                        }

                        // // Atur nilai yang sudah diformat ke dalam controller
                        dpController.value = TextEditingValue(
                          text: formatted,
                          selection: TextSelection.collapsed(offset: formatted.length),
                        );
                        value.length > 4
                            ? setState(() {
                                widget.hmc?['data']?['jumlahDP'] = value;
                                setState(() {
                                  widget.hmc?['data']?['termList'] = getTermList(widget.hmc?['data']?['prices']);
                                });
                              })
                            : null;
                        validate();
                      },
                      decoration: InputDecoration(
                          filled: true,
                          hintText: 'Masukkan DP',
                          hintStyle: const TextStyle(
                              color: Constants.gray,
                              fontSize: Constants.fontSizeMd),
                          fillColor: Constants.gray.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: Constants.spacing3,
                              vertical: Constants.spacing2),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.gray.shade100),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(Constants.spacing3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Constants.gray.shade200),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(Constants.spacing3)))),
                      style: Constants.textLg,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPilihanCicilan() {
    return Container(
      color: Constants.white,
      // padding: const EdgeInsets.symmetric(horizontal: Constants.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: Constants.spacing1),
                child: const Text(
                  'Pilih Cicilan',
                  style: TextStyle(
                    fontSize: Constants.fontSizeSm,
                    color: Constants.gray,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: Constants.spacing1),
            // ignore: prefer_const_constructors
            // padding: EdgeInsets.symmetric(vertical: Constants.spacing1),

            decoration: BoxDecoration(
              color: Constants.white,
              borderRadius: BorderRadius.circular(Constants.spacing4),
            ),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: cicilanController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        validate();
                        String digitsOnly = value.replaceAll(RegExp(r'\D'), '');

                        // Buat string dengan koma setiap tiga digit, dimulai dari akhir string
                        String formatted = '';
                        for (int i = digitsOnly.length - 1; i >= 0; i--) {
                          if ((digitsOnly.length - 1 - i) % 3 == 0 &&
                              i != digitsOnly.length - 1) {
                            formatted = ',' + formatted;
                          }
                          formatted = digitsOnly[i] + formatted;
                        }

                        // Atur nilai yang sudah diformat ke dalam controller
                        cicilanController.value = TextEditingValue(
                          text: formatted,
                          selection:
                              TextSelection.collapsed(offset: formatted.length),
                        );
                        value.length > 4
                            ? setState(() {
                                widget.hmc?['data']?['jumlahCicilan'] = value;
                                // widget.hmc?['data']?['creditDownPayment'] = int.parse(
                                //     value.replaceAll(RegExp(r'[^0-9]'), ''));
                              })
                            : null;
                        value.length < 2
                            ? setState(() {
                                var booli = canCheckout();
                                setState(() {
                                  print("booli $booli");
                                });
                              })
                            : null;

                        validate();
                      },
                      onEditingComplete: () {
                        validate();
                      },
                      decoration: InputDecoration(
                          filled: true,
                          hintText: 'Masukkan jumlah Cicilan',
                          hintStyle: const TextStyle(
                              color: Constants.gray,
                              fontSize: Constants.fontSizeMd),
                          fillColor: Constants.gray.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: Constants.spacing3,
                              vertical: Constants.spacing2),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.gray.shade100),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(Constants.spacing3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Constants.gray.shade200),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(Constants.spacing3)))),
                      style: Constants.textLg,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget buildSimulation(){
    return Container(
      child: Container(child: 
    state == -1
                    ? const Page404()
                    : CustomRefreshIndicator(
                        builder: MaterialIndicatorDelegate(
                          builder: (context, controller) {
                            return IconRefreshIndicator();
                          },
                        ),
                        onRefresh: () async {
                          setState(() {
                            widget.hmc?['data'] = null;
                            widget.hmc?['data']?['kotaId'] = null;
                            widget.hmc?['data']?['idMotor'] = null;
                            widget.hmc?['data']?['namaSeries'] = null;
                            widget.hmc?['data']?['jumlahCicilan'] = null;
                            widget.hmc?['data']?['jumlahDP'] = null;
                            widget.hmc?['data']?['pilihanKota'] = null;
                            if (widget.hmc?['data']?['kotaId'] != null && widget.hmc?['data']?['pilihanKota'] != null) {
                              MiscApi()
                                  .patchMotorAgent(widget.hmc?['data']?['kotaId'])
                                  .then((value) async {
                                if (value != null) {
                                  setState(() {
                                    widget.hmc?['data']?['listMotor'] = value;
                                    widget.hmc?['data']?['listStringMotor'] = groupListMotor(value);
                                  });
                                }
                              });
                            }
                          });
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const SizedBox(
                                  width: 0, height: Constants.spacing3),
                              buildPilihanKota(),
                              const SizedBox(
                                  width: 0, height: Constants.spacing3),
                              buildSeries(),
                              const SizedBox(
                                  width: 0, height: Constants.spacing3),
                              widget.hmc?['data']?['idMotor'] == null
                                  ? EmptyMotorId(
                                      title: "Series Motor Belum dipilih",
                                      description:
                                          "Silahkan Pilih Kota dan Motor dulu untuk Simulasi",
                                    )
                                  : buildImage(),
                              const SizedBox(
                                  width: 0, height: Constants.spacing2),
                              widget.hmc?['data']?['idMotor'] == null
                                  ? Container()
                                  : buildTypeSelector(),
                              widget.hmc?['data']?['idMotor'] == null
                                  ? Container()
                                  : 
                                  (widget.hmc?['data']?['prices'] ?? []).isEmpty  ? Container() :
                                  Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            color: Constants.white,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [

                                                Container(
                                                  color: Constants.white,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          Constants.spacing4,
                                                          0,
                                                          Constants.spacing4,
                                                          Constants.spacing2),
                                                  child: const Text(
                                                    "Tabel Angsuran",
                                                    style: TextStyle(
                                                        fontSize: Constants
                                                            .fontSizeLg,
                                                        color: Constants.gray,
                                                        fontFamily: Constants
                                                            .primaryFontBold),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      state = 3;
                                                    });
                                                    await MiscApi()
                                                        .patchMotorAgentwithPriceList(
                                                            widget.hmc?['data']?['kotaId'],widget.hmc?['data']?['typeId'],widget.hmc?['data']?['colorId'])
                                                        .then((value) async {
                                                      var request =
                                                          await HttpClient()
                                                              .getUrl(Uri.parse(
                                                                  '$value'));
                                                      var response =
                                                          await request.close();
                                                      Uint8List bytes =
                                                          await consolidateHttpClientResponseBytes(
                                                              response);
                                                      await Share.file(
                                                          'ESYS AMLOG',
                                                          'amlog.jpg',
                                                          bytes,
                                                          'image/jpg');
                                                      setState(() {
                                                      state = 1;
                                                    });
                                                      // await Share.share(
                                                      //     "Yuk cek PriceList Motor $widget.hmc?['data']?['namaSeries']\n ${value['url']}");
                                                    });
                                                  },
                                                  child: Container(
                                                    color: Constants.white,
                                                    padding: const EdgeInsets.fromLTRB(Constants.spacing4,0,Constants.spacing4,Constants.spacing2),
                                                    child: 
                                                    // TODO : ubah circularptogresindicator menjadi floating loading
                                                    state == 3 ? const Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                         SizedBox(
                                                          width: 10,height: 10,
                                                          child: CircularProgressIndicator(color: Constants.donker, strokeWidth: 4,)),
                                                      ],
                                                    ) :
                                                    const Text(
                                                      "Kirim Pricelist",
                                                      style: TextStyle(color: Constants.donker),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PriceTable(
                                            prices: widget.hmc?['data']?['prices'] ?? [],
                                            onTableClick: (data) {
                                              setState(() {
                                                state = 2;
                                              });
                                              setState(() {
                                                // dpController.text =
                                                //     data['price'].toString();
                                                dpController.value =
                                                    TextEditingValue(
                                                        text: formatter.format(
                                                            data?['price'] ??
                                                                0));
                                                cicilanController.value =
                                                    TextEditingValue(
                                                  text: formatter.format(
                                                      data?['installment'] ??
                                                          0),

                                                  // selection:
                                                  //     TextSelection.collapsed(offset: formatted.length),
                                                );
                                                widget.hmc?['data']?['pilihanTenor'] =
                                                    data['term'].toString();
                                                tenorController.text =
                                                    data['term'].toString();
                                                widget.hmc?['data']?['jumlahDP'] =
                                                    data['price'].toString();
                                                widget.hmc?['data']?['jumlahCicilan'] =
                                                    data['installment']
                                                        .toString();

                                                setState(() {
                                                  print("jumlahdp $widget.hmc?['data']?['jumlahDP']");
                                                  state = 1;
                                                });
                                              });
                                            },
                                            onTableLongPress: (data) {
                                              expandableDialogOnBoarding(data);
                                              
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                              const SizedBox(
                                  width: 0, height: Constants.spacing3),
                              widget.hmc?['data']?['prices'] == null ? Container() :  buildForm(),
                              widget.hmc?['data']?['idMotor'] == null
                                  ? Container()
                                  : Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: Constants.spacing3,
                                          horizontal: Constants.spacing4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(width: 8, height: 8),
                                          Expanded(
                                              child: ButtonAgent(
                                            text: 'Buat Pengajuan',
                                            iconSvg: 'assets/svg/add.svg',
                                            fontSize: Constants.fontSizeLg,
                                            //TODO : bisa dipencet kalau Price ID ada isinya dan tenornya udah dipilih,dp bayar...dan [terms] = [] ..,city ada (cash , otr price null/angka) (credit,terms.isNotEmpty ?? []) otrPrice
                                            state: state == 5
                                                ? ButtonState.loading
                                                : !(widget.hmc?['data']['valid'] ?? false)
                                                    ? ButtonState.disabled
                                                    : ButtonState.normal,
                                            onPressed: () {
                                              dynamic cityIdPrefs = _sharedPrefs
                                                  .get(SharedPreferencesKeys
                                                      .cityId);

                                              if ((widget.hmc?['data']['valid'] ?? false)) {
                                                checkout(context);
                                                // Navigator.of(context).push(
                                                //     MaterialPageRoute(
                                                //         builder: (_) {
                                                //   return HMCAgentCheckout1({});
                                                // }));
                                              } else if (cityIdPrefs == null) {
                                                AppDialog.snackBar(
                                                    text:
                                                        "Silahkan pilih lokasi terlebih dahulu");
                                              }
                                            },
                                          ))
                                        ],
                                      ),
                                    ),
                              // const SizedBox(
                              //     width: 0, height: Constants.spacing2),
                              // widget.hmc?['data']?['sections'] != null
                              //     ? ListView.builder(
                              //         shrinkWrap: true,
                              //         physics:
                              //             const NeverScrollableScrollPhysics(),
                              //         itemCount: widget.hmc?['data']?['sections'].length,
                              //         itemBuilder: (context, index) {
                              //           return ComponentBuilder(
                              //               onRefresh: () {
                              //                 WidgetsBinding.instance
                              //                     .addPostFrameCallback(
                              //                         (_) async {
                              //                   // load();

                              //                   dynamic cityIdPrefs =
                              //                       _sharedPrefs.get(
                              //                           SharedPreferencesKeys
                              //                               .cityId);
                              //                   // load("");
                              //                 });
                              //               },
                              //               defaultImageUrl: imageUrl,
                              //               id: widget.hmc?['data']?['idMotor'],
                              //               title:
                              //                   "${widget.hmc?['data']?['series']['typeName'] ?? widget.hmc?['data']?['series']['types'][0]['name']}\n${widget.hmc?['data']!['series']['colorName'] ?? widget.hmc?['data']?['series']['colors'][0]['name']}",
                              //               section: widget.hmc?['data']?['sections']
                              //                   [index]);
                              //         })
                              //     : Container()
                            ],
                          ),
                        ),
                      ))
    );
  }

  @override
  Widget build(BuildContext context) {
    int otrPrice = (widget.hmc?['data']?['prices'] ?? []).isNotEmpty
        ? (widget.hmc ?? {})['data']['prices'][0]['price'] ?? 99999999
        : 99999999;
    // dynamic cityId = _sharedPrefs.get(SharedPreferencesKeys.cityId);
    // harga cash 0 masih bisa checkout

    print("color widget ${widget.hmc?['data']?['colorId']}");

    
    return StreamBuilder<Map<dynamic, dynamic>>(
      stream: motorAgentData.dataStream, // Stream yang didengarkan
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Data diterima dari stream
          print("ada simulation 1");
          widget.hmc = snapshot.data ?? {};
          
          // Gunakan data untuk membangun UI
          return buildSimulation();
          
        } else {
          print("ada simulation 2");

          // widget.hmc = snapshot.data ?? {};
          // Stream belum memiliki data
          return buildSimulation();
        }
      },
    );
    
  }
}
