import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:kliknss77/application/app/app_log.dart';
import 'package:kliknss77/application/builders/data_builder.dart';
import 'package:kliknss77/application/exceptions/sign_in_required.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/models/vouchers_models.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/infrastructure/database/agent/m2w/m2w_agent_data.dart';
import 'package:kliknss77/infrastructure/database/data_page.dart';
import 'package:kliknss77/infrastructure/database/data_state.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/app_shimmer.dart';
import 'package:kliknss77/ui/component/button_agent.dart';
import 'package:kliknss77/ui/component/dio_exceptions.dart';
import 'package:kliknss77/ui/component/empty_city.dart';
import 'package:kliknss77/ui/component/empty_motorId.dart';
import 'package:kliknss77/ui/component/get_error_message.dart';
import 'package:kliknss77/ui/component/handle_error/network_error.dart';
import 'package:kliknss77/ui/component/icon_refresh_indicator.dart';
import 'package:kliknss77/ui/component/not_found_page.dart';
import 'package:kliknss77/ui/component/selectable_m2w_agent.dart';
import 'package:kliknss77/ui/views/agent/m2w/agent_m2w_select_motor.dart';
import 'package:kliknss77/ui/views/agent/m2w/checkout_m2w_agent1.dart';
import 'package:kliknss77/ui/views/login/login_view.dart';

class M2WAgentView extends StatefulWidget {
  Map? page = DataBuilder(("motor-agent")).getDataState().getData()['simulation'];
  Map? queryUrl;
  Voucher? voucher;
  int? cityId;

  M2WAgentView({Key? key, this.queryUrl}) : super(key: key);

  @override
  State<M2WAgentView> createState() => _M2WAgentViewState();
}

class _M2WAgentViewState extends State<M2WAgentView> {
  final Dio _dio = DioService.getInstance();
  final _sharedPrefs = SharedPrefs();
  final ScrollController _scrollController = ScrollController();
  GlobalKey m2wKey = GlobalKey();
  int state = 1; // 1:done 2:loading 3:load price -1:error 4:checkout
  final formatter = intl.NumberFormat.decimalPattern();


  M2WAgentData motorAgentData = M2WAgentData();
  DataState? dataState = DataBuilder(("m2w-agent")).getDataState();

  dynamic pilihanHarga;
  List<dynamic> valueItem = ['Harga Normal', 'Harga Extra'];

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

      setState(() {
        widget.page =  dataState?.getData() ?? {};
      });
      if (widget.queryUrl?['series'] != null) {
        load("").then((value) {
          setState(() {
            widget.page?['data']['series'] = widget.queryUrl?['series'] ?? "";
            widget.page?['data']['brand'] = widget.queryUrl?['brand'] ?? "";
            widget.page?['data']['type'] = widget.queryUrl?['type'] ?? "";
            widget.page?['data']['year'] = widget.queryUrl?['year'] ?? "";
            widget.page?['data']['ownershipId'] =
                widget.queryUrl?['ownershipId'] == null
                    ? null
                    : int.parse(widget.queryUrl?['ownershipId'] ?? "1");
            widget.page?['data']['priceId'] = widget.queryUrl?['priceId'] == null
                ? null
                : int.parse(widget.queryUrl?['priceId'] ?? "");
            widget.page?['data']['price'] = widget.queryUrl?['price'] == null
                ? null
                : int.parse(widget.queryUrl?['price'] ?? "");
            widget.page?['data']['term'] = (widget.queryUrl ?? ['term']) == null
                ? null
                : int.parse(widget.queryUrl?['term'] ?? "");
            widget.voucher = widget.queryUrl?['voucherId'] == null
                ? null
                : Voucher(
                    id: int.parse(widget.queryUrl?['voucherId'] ?? "1"),
                    title: widget.queryUrl?['title'] ?? "",
                    description: widget.queryUrl?['description'] ?? "",
                  );

            getPrice();
          });
        });
      } else {
        if (widget.page?['ownerships'] == null) {
          load("").whenComplete(() => AppLog().logScreenView('M2W'));
        } else {
          AppLog().logScreenView('M2W');
        }
      }
      cekKota();
    });
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

  void reset() {
    setState(() {
      widget.page?['data'] = {};
      widget.queryUrl = null;
      widget.voucher = null;
    });
  }

  void onLocationChangeappbar(city) {
    setState(() {
      widget.page?['data'] = {};
      widget.cityId = city['id'] ?? 158;
      widget.queryUrl = null;
      widget.voucher = null;
    });
  }

  bool isValid() {
    return widget.page?['data']['price'] != null &&
        widget.page?['data']['term'] != null &&
        state == 1;
  }

  Future<void> checkout(BuildContext context) async {
    setState(() {
      state = 4;
    });
    Future<void> doCheckout() async {
      int cityId = _sharedPrefs.get(SharedPreferencesKeys.cityId) ?? 158;

      final response = await _dio.post(Endpoint.checkout, data: {
        'type': 13,
        'cityId': cityId,
        'priceId': widget.page?['data']['priceId'],
        'ownershipId': widget.page?['data']['ownershipId'],
        'price': widget.page?['data']['price'],
        'term': widget.page?['data']['term']
      });
      final order = response.data['order'];

      setState(() {
        state = 1;
      });

      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return M2WAgentCheckout1(order);
      }));
    }

    try {
      await doCheckout();
    } on SignInRequiredException {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => LoginView(onSuccess: () async {
                await doCheckout();
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
      'voucherId': widget.voucher?.id
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

  Future<void> openAddMotor(BuildContext context) async {
    final _data =
        await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return AgentM2WSelectMotor();
    }));

    if (_data != null) {
      setState(() {
        widget.page?['data'] = _data;
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
        child: 
        appImageUrl == null || appImageUrl == "" ? Container():
        Container(
          margin: const EdgeInsets.all(0),
          child: InteractiveViewer(
            child: Container(
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


  Widget buildButtonSubmit(){
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.symmetric(
          vertical: Constants.spacing3,
          horizontal: Constants.spacing4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: ButtonAgent(
            text: 'Buat Pengajuan',
            iconSvg: 'assets/svg/add.svg',
            fontSize: Constants.fontSizeLg,
            state: state == 4
                ? ButtonState.loading
                : !isValid()
                    ? ButtonState.disabled
                    : ButtonState.normal,
            onPressed: () {
              if (isValid()) {
                checkout(context);
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (_) {
                //   return M2WAgentCheckout1({});
                // }));
              }
            },
          ))
        ],
      ),
    );
  }


  Widget buildTitleSection() {
    return Container(
        padding: const EdgeInsets.symmetric(
            vertical: Constants.spacing4, horizontal: Constants.spacing4),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                : const Text('Multiguna Motor', style: Constants.heading4),
          ],
        ));
  }

  Widget buildMotorItem() {
    if ((widget.page != null && widget.page?['data']['priceId'] != null) ||
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
            : const Text('Pilih Motor dulu',
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
              Container(
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
                          ))
                      : const Text('Motor',
                          style: TextStyle(color: Constants.gray))),
              InkWell(
                onTap: () {
                  openAddMotor(context);
                },
                child: Container(
                  margin:
                      const EdgeInsets.fromLTRB(0, Constants.spacing1, 0, 0),
                  decoration: const BoxDecoration(color: Colors.white),
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
                                  child: const Text("",
                                    style: TextStyle(
                                        fontSize: Constants.fontSizeLg),
                                  ),
                                ),
                              ),
                            )
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
              )
            ]));
  }

  Widget buildCreditForm() {
    bool priceAvailable = widget.page?['data']['priceRanges'] != null &&
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
                ? (widget.page ?? {})['data']['installments']["$term"]
                    ["actualInstallment"]
                : -1;
            cols.add(Expanded(
              child: SelectableItemAgent(
                  Column(
                    children: [
                      Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${term}x",
                              style: const TextStyle(
                                  color: Constants.white,
                                  fontFamily: Constants.primaryFontBold,
                                  fontSize: Constants.fontSizeLg)),
                        ],
                      ),
                      Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${formatter.format(price)}/bln",
                              style: const TextStyle(
                                  color: Constants.whiteText,
                                  fontSize: Constants.fontSizeXs)),
                        ],
                      ),
                    ],
                  ),
                  widget.page?['data']['term'] == term,const EdgeInsets.symmetric(horizontal: Constants.spacing2,vertical: Constants.spacing4),
                  alignment: Alignment.topLeft, onTap: () {
                setState(() {
              widget.page?['data']['term'] = term;
                });
                //getPrice();
              }),
            ));
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
                      thumbColor: Colors.white,
                      inactiveTrackColor: Constants.gray.shade300,
                      activeTrackColor: Constants.donker.shade500,
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
                        style:  TextStyle(
                            fontSize: Constants.fontSizeXl,
                            fontFamily: Constants.primaryFontBold,
                            color: Constants.donker.shade500)),
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
                        style:  TextStyle(
                            fontSize: Constants.fontSizeXl,
                            fontFamily: Constants.primaryFontBold,
                            color: Constants.donker.shade500)),
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
        margin: const EdgeInsets.symmetric(vertical: Constants.spacing4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: Constants.spacing4),
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
                            style: TextStyle(fontSize: Constants.fontSizeLg),
                          ),
                        ),
                      ))
                  : const Text('Buat Pengajuan',
                      style: TextStyle(
                          fontSize: Constants.fontSizeLg,
                          fontFamily: Constants.primaryFontBold,
                          color: Constants.gray)),
            ),
            const SizedBox(height: Constants.spacing2),
            Container(
              padding: const EdgeInsets.symmetric(vertical: Constants.spacing2),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: Constants.spacing2),
                  buildCreditForm(),
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
                  child: Column(
                    children: [
                      // state == 2
                      //     ? BannerShimmer(aspectRatio: 2 / 1)
                      //     : widget.page?['banners'] == null
                      //         ? Container(
                      //             margin: const EdgeInsets.only(
                      //                 top: Constants.spacing4),
                      //           )
                      //         : widget.page?['banners'].isEmpty
                      //             ? Container(
                      //                 margin: const EdgeInsets.only(
                      //                     top: Constants.spacing4),
                      //               )
                      //             : buildCarousel(),
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
                                // buildPilihanHarga(),
                                widget.page?['data'] == {}
                                    ? EmptyMotorId(
                                        title: "Simulasi Belum Tersedia",
                                        description:
                                            "Silahkan pilih motor terlebih dahulu",
                                      )
                                    : buildForm(),
                                buildButtonSubmit(),
                              ],
                            ),
                      const SizedBox(
                        height: Constants.spacing6,
                      ),
                      Container(
                        key: m2wKey,
                      ),
                      // state == 2
                      //     ? WebViewShimmer(state: state)
                      //     : widget.page?['sections'] != null
                      //         ? ListView.builder(
                      //             padding: const EdgeInsets.all(0),
                      //             shrinkWrap: true,
                      //             physics:
                      //                 const NeverScrollableScrollPhysics(),
                      //             itemCount: widget.page?['sections'].length,
                      //             itemBuilder: (context, index) {
                      //               return ComponentBuilderAgen(
                      //                   title: "Multiguna Motor",
                      //                   onRefresh: () {
                      //                     load("");
                      //                     cekKota();
                      //                   },
                      //                   section: widget.page?['sections']
                      //                       [index]);
                      //             })
                      //         : Container(),
                      // const SizedBox(height: Constants.spacing6)
                    ],
                  ),
                );
  }
}
