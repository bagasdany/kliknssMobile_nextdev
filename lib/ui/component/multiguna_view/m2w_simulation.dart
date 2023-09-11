import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:events_emitter/emitters/event_emitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:kliknss77/application/builders/data_builder.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/models/vouchers_models.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/infrastructure/database/data_page.dart';
import 'package:kliknss77/infrastructure/database/data_state.dart';
import 'package:kliknss77/infrastructure/database/multiguna_motor/multiguna_motor_data.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import 'package:kliknss77/ui/component/app_shimmer.dart';
import 'package:kliknss77/ui/component/customtrackshape.dart';
import 'package:kliknss77/ui/component/empty_city.dart';
import 'package:kliknss77/ui/component/get_error_message.dart';
import 'package:kliknss77/ui/component/multiguna_view/checkout/m2w_checkout1.dart';
import 'package:kliknss77/ui/component/multiguna_view/m2w_select_motor.dart';
import 'package:kliknss77/ui/component/referral_code_component.dart';
import 'package:kliknss77/ui/component/selectable_item.dart';
import 'package:kliknss77/ui/component/voucher_modal.dart';
import 'package:kliknss77/ui/shimmer/banner_shimmer.dart';
import 'package:kliknss77/ui/views/login/login_view.dart';
import 'package:tailwind_style/tailwind_style.dart';
import '../../../application/app/app_log.dart';
import '../../../application/exceptions/sign_in_required.dart';
import '../../../infrastructure/database/shared_prefs.dart';
import '../../component/app_dialog.dart';
import '../../component/button.dart';
import '../../component/dio_exceptions.dart';
import 'm2w_footer_view.dart';

class M2WSimulation extends StatefulWidget {
  Map? page = DataBuilder(("multiguna-motor")).getDataState().getData()['simulation'];
  Map? queryUrl,section;
  String? url,mainClass;

  int? cityId;
  Function? onSelectMotor;

  M2WSimulation({Key? key, this.queryUrl,this.section, this.mainClass, this.url,this.page,this.onSelectMotor}) : super(key: key);

  @override
  State<M2WSimulation> createState() => _SimulationViewState();
}

class _SimulationViewState extends State<M2WSimulation>  {
  final Dio _dio = DioService.getInstance();

  MultigunaMotorData _multigunaMotorData = MultigunaMotorData();
  
  final _sharedPrefs = SharedPrefs();
  final TextEditingController referralController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  GlobalKey m2wKey = GlobalKey();
  bool isChangedReferral = false;
  int state = 1; 
  final formatter = intl.NumberFormat.decimalPattern();

  final events = EventEmitter();

  DataState? dataState = DataBuilder(("multiguna-motor")).getDataState();
  Future<void> cekKota() async {
    final kotaId = await _sharedPrefs.get(SharedPreferencesKeys.cityId) ?? 158;
    if (widget.cityId != kotaId) {
      reset();
    }
  }
  
  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      var simulation = dataState?.getData();
      setState(() {
        widget.page = simulation ?? {};
        widget.page?['data']['utm'] = widget.section?['utm'] ?? {};
      });
      if (widget.queryUrl?['series'] != null) {
        load("").then((value) {
          setState(() {
            widget.page?['data']['series'] = widget.queryUrl?['series'] ?? "";
            // widget.page?['data']['utm'] = widget.section?['utm'] ?? {};
            widget.page?['data']['brand'] = widget.queryUrl?['brand'] ?? "";
            widget.page?['data']['type'] = widget.queryUrl?['type'] ?? "";
            widget.page?['data']['year'] = widget.queryUrl?['year'] ?? "";
            widget.page?['data']['ownershipId'] = widget.queryUrl?['ownershipId'] == null ? null : int.parse(widget.queryUrl?['ownershipId'] ?? "1");
            widget.page?['data']['priceId'] = widget.queryUrl?['priceId'] == null ? null : int.parse(widget.queryUrl?['priceId'] ?? "");
            widget.page?['data']['price'] = widget.queryUrl?['price'] == null ? null : int.parse(widget.queryUrl?['price'] ?? "");
            widget.page?['data']['term'] = (widget.queryUrl ?? ['term']) == null ? null
                : int.parse(widget.queryUrl?['term'] ?? "");
            widget.page?['voucher'] = widget.queryUrl?['voucherId'] == null
                ? null
                : Voucher(
                    id: int.parse(widget.queryUrl?['voucherId'] ?? "1"),
                    title: widget.queryUrl?['title'] ?? "",
                    description: widget.queryUrl?['description'] ?? "",
                  );

            getPrice();
          });
        });
      }
      //  else {
      //   if (widget.page?['ownerships'] == null) {
      //     load("").whenComplete(() => AppLog().logScreenView('M2W'));
      //   } else {
      //     AppLog().logScreenView('M2W');
      //   }
      // }
      // cekKota();
    });
  }


  @override
  void dispose() {
    // _multigunaMotorData.dispose();
    super.dispose();
  }


  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<dynamic> load(String? jenis) {
    jenis == "empty"
        ? null
        : setState(() {
            state = 2;
          });
    dynamic cityIdPrefs = _sharedPrefs.get(SharedPreferencesKeys.cityId);
    widget.cityId = cityIdPrefs;
    if ((widget.queryUrl ?? {}).containsKey('cityId')) {
      setState(() {
        widget.cityId = int.parse((widget.queryUrl?['cityId'] ?? ""));
      });
    }
    var params = {
      ...widget.cityId != null
          ? {}
          : cityIdPrefs == null
              ? {}
              : {"cityId": cityIdPrefs},
      ...widget.queryUrl ?? {}
    };
    return patch(params).then((_page) {
      if (_page == "" || _page == null) {
        AppLog().logScreenView("M2W nonaktif");
      } else {
        if ((widget.page?['data'] as Map).isNotEmpty) {
          _page['data'] = widget.page?['data'] ?? {};
        } else if (_page['data'] == null) {
          _page['data'] = {};
        }

        setState(() {
          widget.page = _page ?? {};
        });
      }
    });
  }

  Future<dynamic> patch(params) async {
    try {
      final response = await _dio.patch(Endpoint.patchM2w, data: params);
      if (response.data == null || response.data == "") {
        setState(() {
          state = -1;
          AppPage.remove("m2w");
        });
      } else {
        setState(() {
          state = 1;
        });
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
            state = 1;
          });
        }
      }
    }
  }
  bool isValid() {

    if( widget.page?['data']['price'] != null &&
        widget.page?['data']['term'] != null ){
          setState(() {
            widget.page?['data']['isValid'] = true;
            print("isValid true");
          });
        }
    else{
      setState(() {
            widget.page?['data']['isValid'] = false;
            print("isValid false");
          });
    }
   
    return widget.page?['data']['price'] != null &&
        widget.page?['data']['term'] != null &&
        state == 1;
  }

  void reset() {
    setState(() {
      widget.page?['data'] = {};
      widget.queryUrl = null;
      widget.page?['voucher'] = null;
    });
  }

  void onLocationChangeappbar(city) {
    setState(() {
      widget.page?['data'] = {};
      widget.cityId = city['id'] ?? 158;
      widget.queryUrl = null;
      widget.page?['voucher'] = null;
    });
  }

  Future<void> checkout(BuildContext context) async {
    setState(() {
      state = 4;
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
        'referralCode': referralController.text,
        'voucherId': widget.page?['voucher']?.id,
        'utm' : widget.section?['utm'] ?? {},
      }).timeout(const Duration(seconds: 15));
      final order = response.data['order'];

      setState(() {
        state = 1;
      });
      //TODO
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
      state = 4;
    });
                await doCheckout().then((value) {
                  setState(() {
      state = 1;
    });
                });
              })));
      setState(() {
        state = 1;
      });
    } on DioException catch (e) {
      String errorMessage =
          GetErrorMessage.getErrorMessage(e.response?.data['errors']);
      AppDialog.snackBar(text: errorMessage);
      setState(() {
        state = 1;
      });
    }on TimeoutException catch (e){
      String errorMessage = "Terjadi Kesalahan silahkan coba lagi nanti";
      AppDialog.snackBar(text: errorMessage);
      setState(() {
        state = 1;
      });
    }
  }

  Future<void> getPrice() async {
    int cityId = _sharedPrefs.get(SharedPreferencesKeys.cityId) ?? 158;
    var params = {
      'cityId': widget.queryUrl?['cityId'] != null
          ? widget.queryUrl!['cityId']
          : cityId,
      'priceId': widget.page?['data']['priceId'],
      'ownershipId': widget.page?['data']['ownershipId'],
      'price': widget.page?['data']['price'],
      'voucherId': widget.page?['voucher']?.id
    };

    setState(() {
      state = 3;
    });

    try {
      final response = await _dio.get("/m2w/price", queryParameters: params);

      setState(() {
        (response.data as Map).forEach((key, value) {
          widget.page?['data'][key] = value;
        });
        state = 1;
      });
      if (widget.queryUrl?['series'] != null) {
        setState(() {
          widget.page?['data']['installment'] = response.data['installment'];
          isValid();
        });
      }
    } on DioException catch (e) {
      dynamic errors = DioExceptions.fromDioError(e);
      if (errors != null) {
        if (errors.message == "No Internet") {
          setState(() {
            state = -2;
          });
        } else {
          setState(() {
            state = 1;
          });
        }
      }
    }
  }

  Future<void> selectCity(
    BuildContext context,
  ) async {

    final kota = await AppDialog.openCitySelector();
    
    if (kota != null) {
      
      setState(() {

      // widget.hmc?['data'] = null;
       widget.page?['data']?['pilihanKota'] = kota['alias'] ?? "";
       widget.cityId = kota['id'] ?? 158;
        widget.page?['data']?['kotaId'] = kota['id'] ?? "";
        widget.page?['data']?['idMotor'] = null;
        

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
                    color: Constants.gray
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
                  border: Border.all(color: Constants.gray.shade300),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(Constants.spacing3)),
                  // color: Constants.gray.shade100,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: Constants.spacing2),
                      child: Text(
                        widget.page?['data']?['pilihanKota'] != null ? widget.page?['data']?['pilihanKota'] ?? "" : "Pilih Kota",
                        style:  TextStyle(color:widget.page?['data']?['pilihanKota'] == null  ? Constants.gray : Constants.blackText,fontFamily: widget.page?['data']?['pilihanKota'] != null ? Constants.primaryFontBold : Constants.primaryFont),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                    SvgPicture.asset(
                                'assets/svg/chevron_forward.svg',
                                width: 21,
                                height: 21,
                                alignment: Alignment.topCenter,
                              )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Future<void> openAddMotor(BuildContext context) async {

    final _data = await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return M2WSelectMotor();
    }));

    if (_data != null) {
      setState(() {

          widget.page?['data'].addEntries(_data.entries);
          widget.page?['data']['term'] = widget.page?['data']?['terms'][0] ?? 11;
          widget.page?['data']['isValid'] = true;
          isValid();
          // final Map<String, dynamic> newData = {
          //   'type': ("multiguna-motor"),
          //   'data':  widget.page ?? {},
          // };
          
          _multigunaMotorData.dataStreamController.sink.add(widget.page ?? {});
          // dataState?.update(widget.page ?? {},widget);
          dataState?.updateData(widget.page ?? {});
          print("terubah");
      });
    }
  }

  Widget buildCarousel() {
    Widget renderImage(Map image) {
      String imageUrl = image['imageUrl'];
      String target = image['target'];
      final appImageUrl = imageUrl.substring(0, imageUrl.indexOf(','));

      return GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.all(0),
          child: InteractiveViewer(
            child: 
            appImageUrl == null || appImageUrl == "" ? Container():
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(appImageUrl),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.bottomCenter)),
            ),
          ),
        ),
      );
    }

    return AppShimmer(
      active: state == 2,
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 2 / 1,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: widget.page?['banners'] != null
              ? (widget.page?['banners'].length > 1)
              : false,
          reverse: false,
          autoPlay: widget.page?['banners'] != null
              ? (widget.page?['banners'].length > 1)
              : false,
          autoPlayInterval: const Duration(seconds: 6),
          autoPlayAnimationDuration: const Duration(milliseconds: 500),
          autoPlayCurve: Curves.ease,
          scrollDirection: Axis.horizontal,
        ),
        items: ((widget.page?['banners'] ?? []) as List).map((banner) {
          return Builder(
            builder: (BuildContext context) {
              return renderImage(banner);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget buildTitleSection() {
    return Container(
      width: double.infinity,
        padding: const EdgeInsets.symmetric(
            vertical: Constants.spacing2, horizontal: Constants.spacing4),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            state == 2
                ? AppShimmer(
                    active: state == 2,
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Container(
                        color: Constants.gray,
                        child: const Text(
                          "",
                          style: TextStyle(fontSize: Constants.fontSizeLg),
                        ),
                      ),
                    ))
                :  Text(widget.section?['title'] ?? 'Hitung Nilai Pencairan', style: Constants.heading3),
            const SizedBox(height: Constants.spacing2),
            state == 2
                ? AppShimmer(
                    active: state == 2,
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Container(
                        color: Constants.gray,
                        child: const Text(
                          "",
                          style: TextStyle(fontSize: Constants.fontSizeLg),
                        ),
                      ),
                    ))
                :   Text(widget.section?['description'] ?? 'Caranya mudah,ikuti langkah dibawah ini.', style: TextStyle(fontSize: Constants.fontSizeMd)),
          ],
        ));
  }

  Widget buildMotorItem() {
    if ((widget.page != null && widget.page?['data']?['priceId'] != null) ||
        widget.queryUrl?['series'] != null) {
      String ownershipText = '';
      switch (widget.page?['data']['ownershipId'].toString()) {
        case '1':
          ownershipText = 'Milik pribadi';
          break;
        case '2':
          ownershipText = 'Pasangan';
          break;
        case '3':
          ownershipText = 'Orang Tua';
          break;
      }

      return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Constants.spacing4, vertical: Constants.spacing3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            state == 2
                ? AppShimmer(
                    active: state == 2,
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Container(
                        color: Constants.gray,
                        child: const Text(
                          "",
                          style: TextStyle(),
                        ),
                      ),
                    ))
                : Text(
                    "${widget.page?['data']['series'] ?? ""} ${widget.page?['data']['type'] ?? ""} ${widget.page?['data']['year'] ?? ""}",
                    style:
                        const TextStyle(fontFamily: Constants.primaryFontBold)),
            const SizedBox(height: Constants.spacing1),
            state == 2
                ? AppShimmer(
                    active: state == 2,
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Container(
                        color: Constants.gray,
                        child: const Text(
                          "",
                          style: TextStyle(fontSize: Constants.fontSizeSm),
                        ),
                      ),
                    ))
                : Text(ownershipText,
                    style: const TextStyle(fontSize: Constants.fontSizeSm)),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Constants.spacing4, vertical: Constants.spacing4),
        child: state == 2
            ? AppShimmer(
                active: state == 2,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Container(
                    color: Constants.gray,
                    child: const Text(
                      "",
                      style: TextStyle(),
                    ),
                  ),
                ))
            : const Text('Pilih Motor',
                style: TextStyle(color: Color.fromARGB(255, 150, 150, 150))),
      );
    }
  }

  Widget buildMotor() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: Constants.spacing4),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildPilihanKota(),
              Container(
                margin: EdgeInsets.only(top: Constants.spacing2),
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.spacing4, vertical: 0),
                  child: state == 2
                      ? AppShimmer(
                          active: state == 2,
                          child: Container(
                            padding: const EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Container(
                              color: Constants.gray,
                              child: const Text(
                                "",
                                style: TextStyle(),
                              ),
                            ),
                          ),
                        )
                      : const Text('Masukkan Motor Jaminan',
                          style: TextStyle(color: Constants.gray))),
              GestureDetector(
                onTap: () {
                  openAddMotor(context);
                },
                child: Container(
                  padding: const EdgeInsets.only(left: Constants.spacing1),
                  
                  child: Container(
                     margin: const EdgeInsets.fromLTRB(Constants.spacing3,
                      Constants.spacing1, Constants.spacing4, Constants.spacing2),
                  
                    decoration:  BoxDecoration(color: Colors.white,
                    border: Border.all(color: Constants.gray.shade300),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(Constants.spacing3)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: buildMotorItem(),
                        ),
                        state == 2
                            ? AppShimmer(
                                active: state == 2,
                                child: Container(
                                  padding: const EdgeInsets.all(0),
                                  width: MediaQuery.of(context).size.width * 0.1,
                                  child: Container(
                                    color: Constants.gray,
                                    child: const Text(
                                      "",
                                      style: TextStyle(
                                          fontSize: Constants.fontSizeLg),
                                    ),
                                  ),
                                ))
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Constants.spacing4, vertical: 0),
                                child: SvgPicture.asset(
                                  'assets/svg/chevron_forward.svg',
                                  width: 21,
                                  height: 21,
                                  alignment: Alignment.topCenter,
                                ))
                      ],
                    ),
                  ),
                ),
              )
            ]));
  }

  Widget buildCreditForm() {
    bool priceAvailable = widget.page?['data']?['priceRanges'] != null &&
        widget.page?['data']['priceRanges'].length == 3;
    double min =
        priceAvailable ? (widget.page?['data']['priceRanges'][0]).toDouble() : 0;
    double max =
        priceAvailable ? (widget.page?['data']['priceRanges'][1]).toDouble() : 0;
    int divisions = priceAvailable
        ? ((max - min) / widget.page?['data']['priceRanges'][2]).round()
        : 1;

    bool termsAvailable = ((widget.page?['data']['terms'] ?? []).isNotEmpty &&
        (widget.page?['data']['terms'] ?? []).length > 0);
    List<Widget> termWidgets = [];
    if (termsAvailable) {
      
      int rowCount = ((widget.page?['data']['terms'] ?? []).length / 3).ceil();
      for (var i = 0; i < rowCount; i++) {
        List<Widget> cols = [];
        for (var j = 0; j < 3; j++) {
          int idx = (i * 3) + j;

          if (idx < widget.page?['data']['terms'].length) {
            int term = widget.page?['data']['terms'][idx];
            int price = (widget.page?['data']['installments'] != null &&
                    widget.page?['data']['installments']["$term"] != null)
                ? widget.page!['data']['installments']["$term"]
                    ["actualInstallment"]
                : -1;
            cols.add(Expanded(
                child: SelectableItem(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${term}x",
                            style: const TextStyle(
                                fontFamily: Constants.primaryFontBold,
                                fontSize: Constants.fontSizeLg)),
                        Text("${formatter.format(price)}/bln",
                            style: const TextStyle(
                                fontSize: Constants.fontSizeXs)),
                      ],
                    ),
                    widget.page?['data']['term'] == term,
                    alignment: Alignment.centerLeft, onTap: () {
              setState(() {
                widget.page?['data']['term'] = term;
              });
              // getPrice();
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
    } else {}

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Constants.spacing4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  state == 2
                      ? AppShimmer(
                          active: state == 2,
                          child: Container(
                            padding: const EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Container(
                              color: Constants.gray,
                              child: const Text(
                                "",
                                style:
                                    TextStyle(fontSize: Constants.fontSizeSm),
                              ),
                            ),
                          ))
                      : const Text('Pilihan Pencairan',
                          style: TextStyle(
                              fontSize: Constants.fontSizeSm,
                              color: Constants.gray)),
                  state == 2
                      ? AppShimmer(
                          active: state == 2,
                          child: Container(
                            padding: const EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Container(
                              color: Constants.gray,
                              child: const Text(
                                "",
                                style:
                                    TextStyle(fontSize: Constants.fontSizeLg),
                              ),
                            ),
                          ))
                      : Text(
                          widget.page?['data']['price'] != null
                              ? "Rp. ${formatter.format(widget.page?['data']['price'])}"
                              : '',
                          style: const TextStyle(
                              fontSize: Constants.fontSizeLg,
                              fontFamily: Constants.primaryFontBold))
                ],
              ),
              AppShimmer(
                active: state == 2,
                child: SliderTheme(
                    data: SliderThemeData(
                      // rangeTrackShape:  GradientRectRangeSliderTrackShape(gradient: ),
                      thumbColor: Colors.white,
                      inactiveTrackColor: Constants.gray.shade300,
                      activeTrackColor: Constants.primaryColor,
                      overlayColor: Colors.transparent,
                      thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 15.0, elevation: 3),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 20.0),
                    ),
                    child: Slider(
                      value: priceAvailable
                          ? (widget.page?['data']['price']).toDouble()
                          : 0,
                      max: max,
                      min: min,
                      divisions: divisions,
                      onChanged: (double value) {
                        setState(() {
                          widget.page?['data']['price'] = value.toInt();
                        });
                      },
                      onChangeEnd: (double value) {
                        getPrice();
                        isValid();
                      },
                    )),
              )
            ],
          ),
        ),
        const SizedBox(height: Constants.spacing3),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Constants.spacing4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              state == 2
                  ? AppShimmer(
                      active: state == 2,
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Container(
                          color: Constants.gray,
                          child: const Text(
                            "",
                            style: TextStyle(fontSize: Constants.fontSizeSm),
                          ),
                        ),
                      ))
                  : const Text('Tenor',
                      style: TextStyle(
                          fontSize: Constants.fontSizeSm,
                          color: Constants.gray)),
              const SizedBox(height: Constants.spacing1),
              AppShimmer(
                active: state == 2,
                child: Container(
                    color: Colors.white, child: Column(children: termWidgets)),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildTotalForm() {
    bool priceAvailable = widget.page?['data']['price'] != null &&
        widget.page?['data']['term'] != null;
    var selectedTerm = {};
    if (priceAvailable) {
      selectedTerm = (widget.page?['data']['installments']
              ?['${widget.page?['data']?['term']}'] ??
          {});
    }

    int actualPrice = selectedTerm['actualPrice'] ?? -1;
    int price = selectedTerm['price'] ?? actualPrice;
    int actualInstallment = selectedTerm['actualInstallment'] ?? -1;
    int installment = selectedTerm['installment'] ?? actualInstallment;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Constants.spacing4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              state == 2
                  ? AppShimmer(
                      active: state == 2,
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Container(
                          color: Constants.gray,
                          child: const Text(
                            "",
                            style: TextStyle(fontSize: Constants.fontSizeSm),
                          ),
                        ),
                      ))
                  : const Text('Pencairan',
                      style: TextStyle(
                          fontSize: Constants.fontSizeSm,
                          color: Constants.gray)),
              AppShimmer(
                  active: state == 3,
                  child: Container(
                    color: Colors.white,
                    child: Text(
                        actualPrice > -1
                            ? "Rp. ${formatter.format(actualPrice)}"
                            : '',
                        style: const TextStyle(
                            fontSize: Constants.fontSizeXl,
                            fontFamily: Constants.primaryFontBold,
                            color: Constants.primaryColor)),
                  )),
              AppShimmer(
                active: state == 3,
                child: Container(
                    color: Colors.white,
                    child: Text(
                        price != null && price != actualPrice
                            ? 'Rp. ${formatter.format(price)}'
                            : '',
                        style: const TextStyle(
                            fontFamily: Constants.primaryFontBold,
                            decoration: TextDecoration.lineThrough))),
              )
            ],
          )),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              state == 2
                  ? AppShimmer(
                      active: state == 2,
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Container(
                          color: Constants.gray,
                          child: const Text(
                            "",
                            style: TextStyle(fontSize: Constants.fontSizeSm),
                          ),
                        ),
                      ))
                  : const Text('Cicilan /bln',
                      style: TextStyle(
                          fontSize: Constants.fontSizeSm,
                          color: Constants.gray)),
              AppShimmer(
                  active: state == 3,
                  child: Container(
                    color: Colors.white,
                    child: Text(
                        actualInstallment > -1
                            ? "Rp. ${formatter.format(actualInstallment)}"
                            : '',
                        style: const TextStyle(
                            fontSize: Constants.fontSizeXl,
                            fontFamily: Constants.primaryFontBold,
                            color: Constants.primaryColor)),
                  )),
              AppShimmer(
                active: state == 3,
                child: Container(
                    color: Colors.white,
                    child: Text(
                        installment != null && installment != actualInstallment
                            ? 'Rp. ${formatter.format(installment)}'
                            : '',
                        style: const TextStyle(
                            fontFamily: Constants.primaryFontBold,
                            decoration: TextDecoration.lineThrough))),
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget buildForm() {
    return Container(
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: Constants.spacing4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Constants.spacing4),
                    child: state == 2
                        ? AppShimmer(
                            active: state == 2,
                            child: Container(
                              padding: const EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Container(
                                color: Constants.gray,
                                child: const Text(
                                  "",
                                  style:
                                      TextStyle(fontSize: Constants.fontSizeLg),
                                ),
                              ),
                            ))
                        : const Text('Buat Pengajuan',
                            style: TextStyle(
                                fontSize: Constants.fontSizeLg,
                                fontFamily: Constants.primaryFontBold,
                                color: Constants.gray)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isChangedReferral = !isChangedReferral;
                      // Scrollable.ensureVisible(dataKey.currentContext!);
                      // WidgetsBinding.instance.addPostFrameCallback((_) =>
                      //     Scrollable.ensureVisible(
                      //         dataKey.currentContext!));
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Constants.spacing4),
                    child: Text(
                      "Kode Referral",
                      style: TextStyle(
                          fontSize: Constants.fontSizeSm,
                          color: Constants.primaryColor.shade400,
                          
                          ),overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Constants.spacing2),
            Container(
              padding: const EdgeInsets.symmetric(vertical: Constants.spacing2),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ReferralCodeComponent(
                    textColor: Constants.gray,
                    onChangedTextField: (text) async {
                      setState(() {
                        referralController.text = text;
                        widget.page?['data']['referralCode'] = text;
                      });
                      print("ref ${referralController.text}");

                      // await Future.delayed(
                      //         const Duration(milliseconds: 500))
                      //     .then((value) {

                      // Scrollable.ensureVisible(
                      //   dataKey.currentContext!,
                      //   duration: const Duration(milliseconds: 400),
                      //   curve: Curves.easeInOut,
                      // );
                      // });
                    },
                    isChanged: isChangedReferral,
                  ),
                  const SizedBox(height: Constants.spacing2),
                  buildCreditForm(),
                  const SizedBox(height: Constants.spacing4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Constants.spacing4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        state == 2
                            ? AppShimmer(
                                active: state == 2,
                                child: Container(
                                  padding: const EdgeInsets.all(0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Container(
                                    color: Constants.gray,
                                    child: const Text(
                                      "",
                                      style: TextStyle(
                                          fontSize: Constants.fontSizeSm),
                                    ),
                                  ),
                                ))
                            : const Text('Voucher',
                                style: TextStyle(
                                    fontSize: Constants.fontSizeSm,
                                    color: Constants.gray)),
                        const SizedBox(height: Constants.spacing1),
                        AppShimmer(
                          active: state == 2,
                          child: VoucherModal(
                            selectedVoucher: widget.page?['voucher'],
                            disabled: widget.page?['data']['priceId'] == null,
                            businessId: 3,
                            voucher: widget.page?['voucher'],
                            onVoucherChanged: (Voucher? voucher) {
                              setState(() {
                                widget.page?['voucher'] = voucher;
                              });
                              getPrice();
                            },
                            onVoucherRemoved: (Voucher? voucher) {
                              setState(() {
                                widget.page?['voucher'] = voucher;
                              });
                              getPrice();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Constants.spacing6),
                  buildTotalForm(),
                  const SizedBox(height: Constants.spacing2),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic cityId = _sharedPrefs.get(SharedPreferencesKeys.cityId);
    return SingleChildScrollView(
                      controller: _scrollController,
                      child: ContainerTailwind(
                        extClass: widget.mainClass,
                        color: Colors.white,
                        child: Column(
                          children: [
                            state == 2
                                ? BannerShimmer(aspectRatio: 2 / 1)
                                : widget.page?['banners'] == null
                                    ? Container(
                                        margin: const EdgeInsets.only(
                                            top: Constants.spacing4),
                                      )
                                    : widget.page?['banners'].isEmpty
                                        ? Container(
                                            margin: const EdgeInsets.only(
                                                top: Constants.spacing4),
                                          )
                                        : buildCarousel(),
                            buildTitleSection(),
                            cityId == null
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        top: Constants.spacing4),
                                    child: EmptyCityId(
                                      onLocationChange: (() {
                                        load("empty");
                                      }),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      buildMotor(),
                                      buildForm(),
                                    ],
                                  ),
                            // const SizedBox(
                            //   height: Constants.spacing6,
                            // ),
                            Container(
                              key: m2wKey,
                            ),
                            
                                  
                            // const SizedBox(height: Constants.spacing6)
                          ],
                        ),
                      ),
                    );
  }
}
