import 'package:dio/dio.dart';
import 'package:events_emitter/events_emitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kliknss77/application/builders/data_builder.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/infrastructure/database/multiguna_motor/multiguna_motor_data.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/button.dart';
import 'package:kliknss77/ui/component/selectable_item.dart';
import '../../../application/app/app_log.dart';
import '../../../infrastructure/database/data_state.dart';
import '../../../infrastructure/database/shared_prefs.dart';
import '../../component/app_shimmer.dart';

class M2WSelectMotor extends StatefulWidget {
  
  Map? page ;
  int? cityId;

  M2WSelectMotor({Key? key,this.page}) : super(key: key);

  @override
  State<M2WSelectMotor> createState() => _M2WSelectMotorState();
}

class _M2WSelectMotorState extends State<M2WSelectMotor> {
  final Dio _dio = DioService.getInstance();
  final _sharedPrefs = SharedPrefs();
  final events = EventEmitter();

  DataState? dataState = DataBuilder(("/m2w-motor")).getDataState();
  int state = 1; // 3: apply button loading

  @override
  void initState() {
    super.initState();

    widget.page  = dataState?.getData();
    if ((widget.page?['brands'] ?? []).isEmpty ||
        widget.cityId !=  (_sharedPrefs.get(SharedPreferencesKeys.cityId) ?? 158)) {
      getBrands();
    }
    print("b");
    // cekKota();

    AppLog().logScreenView('M2W Select Motor');
  }

  @override
  void dispose() {
  super.dispose();
  }


  Future<void> cekKota() async {
    final kotaId = _sharedPrefs.get(SharedPreferencesKeys.cityId) ?? 158;
    if (widget.cityId != kotaId) {
      reset();
    }
  }

  void reset() {
    setState(() {
      widget.page?['brands'] = [];
      widget.page?['serieses'] = [];
      widget.page?['types'] = [];
      widget.page?['years'] = [];
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }


  Future<List<String>> getBrands() async {
    setState(() {
      widget.page?['brands'] = ['...'];
    });

    int? cityId = _sharedPrefs.get(SharedPreferencesKeys.cityId) ?? 158;
    var params = {'cityId': cityId};
    Response response =
        await _dio.get(Endpoint.requestM2wMotor, queryParameters: params);
    List<String> _brands = (response.data['brands'] as List)
        .map((item) => item as String)
        .toList();

    setState(() {
      widget.page?['brands'] = _brands;
    });

    return _brands;
  }

  Future<List<String>> getSeries() async {
    
    int cityId = _sharedPrefs.get(SharedPreferencesKeys.cityId) ?? 158;
    var params = {'cityId': cityId, 'brand': widget.page?['brand']};
    Response response =
        await _dio.get(Endpoint.requestM2wMotor, queryParameters: params);
    List<String> _serieses = (response.data['serieses'] as List)
        .map((item) => item as String)
        .toList();

    setState(() {
      widget.page?['serieses'] = _serieses;
      widget.cityId = cityId;
    });
    if (_serieses.length == 1) {
      widget.page?['series'] = _serieses[0];
      // for your here
      getTypes().then((value) {
        if (value.length == 1) {
          widget.page?['type'] = value[0];
          getYears().then((value) {
            if (value.length == 1) {
              widget.page?['year'] = value[0];
            }
          });
        }
      });
    }

    return _serieses;
  }

  Future<List<String>> getTypes() async {
    setState(() {
      widget.page?['types'] = ['...'];
    });

    int cityId = _sharedPrefs.get(SharedPreferencesKeys.cityId) ?? 158;
    var params = {
      'cityId': cityId,
      'brand': widget.page?['brand'],
      'series': widget.page?['series']
    };
    Response response =
        await _dio.get(Endpoint.requestM2wMotor, queryParameters: params);
    List<String> _types =
        (response.data['types'] as List).map((item) => item as String).toList();

    setState(() {
      widget.page?['types'] = _types;
    });

    if (_types.length == 1) {
      getYears().then((value) {
        if (value.length == 1) {
          setState(() {
            widget.page?['year'] = value[0];
          });
        } else {
          setState(() {
            widget.page?['year'] = null;
          });
        }
      });
    }

    return _types;
  }

  Future<List<String>> getYears() async {
    setState(() {
      widget.page?['years'] = ['...'];
    });

    int cityId = _sharedPrefs.get(SharedPreferencesKeys.cityId) ?? 158;
    var params = {
      'cityId': cityId,
      'brand': widget.page?['brand'],
      'series': widget.page?['series'],
      'type': widget.page?['type']
    };
    Response response =
        await _dio.get(Endpoint.requestM2wMotor, queryParameters: params);
    List<String> _years = ((response.data['years'] ?? []) as List)
        .map((item) => item.toString())
        .toList();

    setState(() {
      widget.page?['years'] = _years;
    });
    if (_years.length == 1) {
      setState(() {
        widget.page?['year'] = _years[0];
      });
    }

    return _years;
  }

  bool canApply() {
    return widget.page?['brand'] != null &&
        widget.page?['series'] != null &&
        widget.page?['type'] != null &&
        widget.page?['year'] != null &&
        widget.page?['ownershipId'] != null;
  }

  Future<bool> apply(BuildContext context) async {
    
    int cityId = _sharedPrefs.get(SharedPreferencesKeys.cityId) ?? 158;
    var params = {
      'cityId': cityId,
      'brand': widget.page?['brand'],
      'series': widget.page?['series'],
      'type': widget.page?['type'],
      'year': widget.page?['year'],
      'ownershipId': widget.page?['ownershipId']
    };
    
    
    AppLog().logScreenView(params.toString());
    print("apply");
    Response response = await _dio.get(Endpoint.requestM2wMotor, queryParameters: params);
    if (response.data['priceId'] != null) {
      setState(() {
        widget.page?['priceId'] = response.data['priceId'];
      });
      Navigator.pop(context, response.data);
    } else {
      AppDialog.alert(title: 'Maaf, motor yang dipilih tidak dapat digunakan.');
    }

    return true;
  }

  Widget buildMotor() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Constants.spacing4),
            child: const Text('Motor',
                style: TextStyle(
                    fontFamily: Constants.primaryFontBold,
                    color: Constants.gray)),
          ),
          const SizedBox(height: Constants.spacing2),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(Constants.spacing4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Merk',
                    style: TextStyle(fontSize: Constants.fontSizeSm)),
                const SizedBox(height: Constants.spacing1),
                AppShimmer(
                    active:
                        widget.page?['brands'].length == 1 && widget.page?['brands'][0] == '...',
                    child: InkWell(
                        onTap: widget.page?['brands'].length == 1 &&
                                widget.page?['brands'][0] == '...'
                            ? null
                            : () async {
                                String? brand = await AppDialog.showTextSelector(
                                    context, widget.page?['brands'],
                                    title: 'Pilih Merk',
                                    emptyText:
                                        'Tidak ada pilihan merk untuk kota ini');
                                if (brand != null) {
                                  setState(() {
                                    widget.page?['brand'] = brand;
                                    widget.page?['series'] = null;
                                    widget.page?['type'] = null;
                                    widget.page?['year'] = null;
                                  });
                                  getSeries();
                                }
                              },
                        child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(Constants.spacing3),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Constants.gray.shade300),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(Constants.spacing3)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                        widget.page?['brand'] ?? 'Pilih Merk')),
                                SvgPicture.asset('assets/svg/chevron_down.svg',
                                    width: 21,
                                    height: 21,
                                    color: Constants.gray)
                              ],
                            )))),
                const SizedBox(height: Constants.spacing3),
                const Text('Series',
                    style: TextStyle(fontSize: Constants.fontSizeSm)),
                const SizedBox(height: Constants.spacing1),
                AppShimmer(
                    active: ((widget.page?['brands'] ?? []).length == 1 &&
                            widget.page?['brands'][0] == '...') ||
                        ((widget.page?['serieses'] ?? []).length == 1 &&
                            widget.page?['serieses'][0] == '...'),
                    child: GestureDetector(
                        onTap: ((widget.page?['brands'] ?? []).length == 1 &&
                                    widget.page?['brands'][0] == '...') ||
                                ((widget.page?['serieses'] ?? []).length == 1 &&
                                    widget.page?['serieses'][0] == '...')
                            ? null
                            : () async {
                                String? series =
                                    await AppDialog.showTextSelector(
                                            context, widget.page?['serieses'],
                                            title: 'Pilih Series')
                                        .then((value) {
                                  if (value != null) {
                                    setState(() {
                                      widget.page?['series'] = value;
                                      widget.page?['type'] =
                                          widget.page?['types'].length == 1
                                              ? widget.page!['types'][0]
                                              : null;
                                      widget.page?['year'] =
                                          widget.page?['years'].length == 1
                                              ? widget.page!['years'][0]
                                              : null;
                                    });
                                    getTypes().then((valuetypes) async {
                                      if (valuetypes.length == 1) {
                                        widget.page?['type'] = valuetypes[0];
                                        await getYears().then((valueyears) {
                                          if (valueyears.length == 1) {
                                            setState(() {
                                              widget.page?['years'] = valueyears;
                                              widget.page?['year'] =
                                                  valueyears[0];
                                            });
                                          }
                                        });
                                      } else {
                                        await getTypes().then((values) {
                                          setState(() {
                                            print("value mau masuk types");
                                            widget.page?['types'] = values;
                                            widget.page?['type'] = null;
                                            widget.page?['year'] = null;
                                            print("value dah masuk types");
                                          });
                                        });
                                      }
                                    });
                                  } else {
                                    widget.page?['types'] = [];
                                  }
                                });
                              },
                        child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(Constants.spacing3),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Constants.gray.shade300),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(Constants.spacing3)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(widget.page?['series'] ??
                                        'Pilih Series')),
                                SvgPicture.asset('assets/svg/chevron_down.svg',
                                    width: 21,
                                    height: 21,
                                    color: Constants.gray)
                              ],
                            )))),
                const SizedBox(height: Constants.spacing3),
                const Text('Tipe',
                    style: TextStyle(fontSize: Constants.fontSizeSm)),
                const SizedBox(height: Constants.spacing1),
                AppShimmer(
                    active: ((widget.page?['brands'] ?? []).length == 1 &&
                            widget.page?['brands'][0] == '...') ||
                        ((widget.page?['serieses'] ?? []).length == 1 &&
                            widget.page?['serieses'][0] == '...') ||
                        ((widget.page?['types'] ?? []).length == 1 && widget.page?['types'][0] == '...'),
                    child: GestureDetector(
                        onTap: ((widget.page?['brands'] ?? []).length == 1 &&
                                    widget.page?['brands'][0] == '...') ||
                                ((widget.page?['serieses'] ?? []).length == 1 &&
                                    widget.page?['serieses'][0] == '...') ||
                                ((widget.page?['types'] ?? []).length == 1 &&
                                    widget.page?['types'][0] == '...')
                            ? null
                            : () async {
                                String? type = await AppDialog.showTextSelector(
                                    context, widget.page?['types'],
                                    title: 'Pilih Tipe');
                                if (type != null) {
                                  setState(() {
                                    widget.page?['type'] = type;
                                    widget.page?['year'] = null;
                                  });
                                  await getYears().then((value) {
                                    if (value.length == 1) {
                                      widget.page?['year'] = value[0];
                                    }
                                  });
                                }
                              },
                        child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(Constants.spacing3),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Constants.gray.shade300),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(Constants.spacing3)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                        widget.page?['type'] ?? 'Pilih Tipe')),
                                SvgPicture.asset('assets/svg/chevron_down.svg',
                                    width: 21,
                                    height: 21,
                                    color: Constants.gray)
                              ],
                            )))),
                const SizedBox(height: Constants.spacing3),
                const Text('Tahun',
                    style: TextStyle(fontSize: Constants.fontSizeSm)),
                const SizedBox(height: Constants.spacing1),
                AppShimmer(
                    active: (widget.page?['brands'].length == 1 &&
                            widget.page?['brands'][0] == '...') ||
                        (widget.page?['serieses'].length == 1 &&
                            widget.page?['serieses'][0] == '...') ||
                        (widget.page?['types'].length == 1 &&
                            widget.page?['types'][0] == '...') ||
                        (widget.page?['years'].length == 1 && widget.page?['years'][0] == '...'),
                    child: GestureDetector(
                        onTap: (widget.page?['brands'].length == 1 &&
                                    widget.page?['brands'][0] == '...') ||
                                (widget.page?['serieses'].length == 1 &&
                                    widget.page?['serieses'][0] == '...') ||
                                (widget.page?['types'].length == 1 &&
                                    widget.page?['types'][0] == '...') ||
                                (widget.page?['years'].length == 1 &&
                                    widget.page?['years'][0] == '...')
                            ? null
                            : () async {
                                String? year = await AppDialog.showTextSelector(
                                    context, widget.page?['years'],
                                    title: 'Pilih Tahun');
                                if (year != null) {
                                  setState(() {
                                    widget.page?['year'] = year;
                                  });
                                }
                              },
                        child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(Constants.spacing3),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Constants.gray.shade300),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(Constants.spacing3)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                        widget.page?['year'] ?? 'Pilih Tahun')),
                                SvgPicture.asset('assets/svg/chevron_down.svg',
                                    width: 21,
                                    height: 21,
                                    color: Constants.gray)
                              ],
                            )))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildOwnership() {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Constants.spacing4),
            child: const Text('Kepemilikan',
                style: TextStyle(
                    fontFamily: Constants.primaryFontBold,
                    color: Constants.gray)),
          ),
          const SizedBox(height: Constants.spacing2),
          Container(
              color: Colors.white,
              padding: const EdgeInsets.all(Constants.spacing4),
              child: Column(children: [
                SelectableItem(const Text('Milik Pribadi'),
                    widget.page?['ownershipId'] == 1,
                    alignment: Alignment.centerLeft, onTap: () {
                  setState(() {
                    widget.page?['ownershipId'] = 1;
                  });
                }),
                const SizedBox(height: Constants.spacing2),
                SelectableItem(
                    const Text('Pasangan'), widget.page?['ownershipId'] == 2,
                    alignment: Alignment.centerLeft, onTap: () {
                  setState(() {
                    widget.page?['ownershipId'] = 2;
                  });
                }),
                const SizedBox(height: Constants.spacing2),
                SelectableItem(
                    const Text('Orang Tua'), widget.page?['ownershipId'] == 3,
                    alignment: Alignment.centerLeft, onTap: () {
                  setState(() {
                    widget.page?['ownershipId'] = 3;
                  });
                })
              ]))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Motor'),
          titleSpacing: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Constants.spacing4),
              buildMotor(),
              const SizedBox(height: Constants.spacing4),
              buildOwnership(),
              const SizedBox(height: Constants.spacing4),
              Container(
                padding: const EdgeInsets.all(Constants.spacing4),
                child: Button(
                  fontSize: Constants.fontSizeLg,
                  text: 'Gunakan Motor Ini',
                  state: canApply()
                      ? (state == 3 ? ButtonState.loading : ButtonState.normal)
                      : ButtonState.disabled,
                  onPressed: !canApply()
                      ? null
                      : () {
                          setState(() {
                            state = 3;
                          });
                          apply(context).then((res) {
                            setState(() {
                              state = 1;
                            });
                          });
                        },
                ),
              )
            ],
          ),
        ));
  }
}
