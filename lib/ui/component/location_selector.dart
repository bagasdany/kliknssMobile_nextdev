import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/button.dart';
import 'package:events_emitter/events_emitter.dart';

import '../../infrastructure/database/shared_prefs.dart';
import '../header/floating_header.dart';

class LocationSelector {
  Position? currentPosition;

  ScrollController? controller;

  final userLocation = (SharedPreferencesKeys.userLocation);
  TextEditingController searchController = TextEditingController();

  final location = SharedPrefs().get(SharedPreferencesKeys.userLocation);
  dynamic keyMark;

  int chatCount = 0;
  int notificationCount = 0;
  int cartCount = 0;
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  String lokasi = "";
  final _sharedPrefs = SharedPrefs();

  final Dio _dio = DioService.getInstance();
  List<Map> provinces = [];
  String cityName =
      SharedPrefs().get(SharedPreferencesKeys.userLocation) ?? 'Belum diset';
  bool locationDenied = false;
  List<String> badges = [];
  int aState = 1; // 1: normal, 2: waiting for location

  EventListener? listener;
  EventListener? listenerbadges;

  Future<bool> findLocation(onLocationChange) async {
    Future<void> retrieveLocation() async {
      Position position = await Geolocator.getCurrentPosition();
      final param = {"lat": position.latitude, "lng": position.longitude};
      Response res =
          await _dio.get(Endpoint.requestKota, queryParameters: param);
      var city = res.data;
      setCity(city, position.latitude, position.longitude, onLocationChange);
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        await retrieveLocation();
      } else if (permission == LocationPermission.deniedForever) {
        // setState(() {
        aState = 1;
        // });
        AppDialog.snackBar(
            text:
                "Izin Lokasi tidak diizinkan,silahkan izinkan lewat pengaturan aplikasi");
      }
    } else if (permission == LocationPermission.deniedForever) {
      // setState(() {
      aState = 1;
      // });
      AppDialog.snackBar(
          text:
              "Izin Lokasi tidak diizinkan,silahkan izinkan lewat pengaturan aplikasi");
    } else {
      await retrieveLocation();
    }

    return true;
  }

  Future<void> getLocationPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    // setState(() {
    locationDenied = permission == LocationPermission.deniedForever;
    // });
  }

  Future<List<Map>> getProvinces() async {
    const param = {"fields": "id,code,name,alias,cities"};
    Response response =
        await _dio.get(Endpoint.getProvinsi, queryParameters: param);
    return (response.data['provinces'] as List)
        .map((item) => item as Map)
        .toList();
  }

  void setCity(city, double? lat, double? lng, onLocationChange) {
    // setState(() {
    cityName = city['alias'];
    // });

    _sharedPrefs.set(SharedPreferencesKeys.cityId, city['id']);
    _sharedPrefs.set(SharedPreferencesKeys.userLocation, city['alias']);
    if (lat != null) {
      _sharedPrefs.set(SharedPreferencesKeys.latitude, lat);
      _sharedPrefs.set(SharedPreferencesKeys.longitude, lng);
    } else {
      _sharedPrefs.remove(SharedPreferencesKeys.latitude);
      _sharedPrefs.remove(SharedPreferencesKeys.longitude);
    }

    if (onLocationChange != null) {
      onLocationChange();
    }
    events.emit('locationChanged', city);
  }

  void locationSelector({required context, onLocationChange}) {
    getLocationPermission().then((v) {
      double maxWidth = MediaQuery.of(context).size.width * .85;
      double maxHeight = MediaQuery.of(context).size.height * .7;
      bool loaded = false;
      // setState(() {
      aState = 1;
      // });

      AppDialog.custom(
          builder: (context) {
            return StatefulBuilder(
              builder: (ctx, StateSetter setInnerState) {
                if (!loaded) {
                  loaded = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (provinces.isEmpty) {
                      setInnerState(() {
                        provinces = [
                          {'id': '...', 'name': 'Sedang memuat'}
                        ];
                      });
                      Future.delayed(const Duration(milliseconds: 350), () {
                        // AppDialog.openUrl(message?.data['target']);
                        getProvinces().then((provincess) {
                          // if(mounted)

                          setInnerState(() {
                            provinces = provincess;
                          });
                        });
                      });
                    }
                  });
                }

                void searchCity(String? key) {
                  String lKey = (key ?? "").toLowerCase();
                  int pLength = provinces.length;
                  for (var i = 0; i < pLength; i++) {
                    int cLength = provinces[i]['cities']!.length;
                    bool searchExists = false;
                    for (var j = 0; j < cLength; j++) {
                      String cName = provinces[i]['cities']![j]['name'];
                      if (cName.toLowerCase().contains(lKey) || lKey.isEmpty) {
                        searchExists = true;
                        provinces[i]['cities']![j]['_filtered'] = 0;
                      } else {
                        provinces[i]['cities']![j]['_filtered'] = 1;
                      }
                    }
                    provinces[i]['_filtered'] = searchExists ? 0 : 1;
                  }

                  setInnerState(() {
                    provinces = provinces;
                  });
                }

                List<Widget> cityItems = [];
                provinces.forEach((_province) {
                  bool pFiltered = _province.containsKey('_filtered') &&
                      _province['_filtered'] == 1;

                  if (!pFiltered) {
                    cityItems.add(Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: Constants.spacing2),
                      child: Text(_province['alias'] ?? "",
                          style: const TextStyle(
                              fontFamily: Constants.primaryFontBold)),
                    ));

                    _province['cities']?.forEach((_city) {
                      bool cFiltered = _city.containsKey('_filtered') &&
                          _city['_filtered'] == 1;

                      if (!cFiltered) {
                        cityItems.add(InkWell(
                          onTap: () {
                            setCity(_city, null, null, onLocationChange);
                            searchController.text = '';

                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: Constants.gray.shade200))),
                            padding: const EdgeInsets.symmetric(
                                vertical: Constants.spacing3),
                            child: Text(_city['alias']!),
                          ),
                        ));
                      }
                    });
                  }
                });

                return Center(
                  child: Material(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(Constants.spacing3)),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: maxWidth, maxHeight: maxHeight),
                      width: 400,
                      height: 800,
                      padding: const EdgeInsets.all(Constants.spacing4),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: const Text('Pilih Lokasi',
                                          style: Constants.heading4),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                    vertical: Constants.spacing4),
                                child: Button(
                                    text: 'Gunakan lokasi saat ini',
                                   
                                    icon: Icons.pin_drop,
                                    onPressed: () {
                                      setInnerState(() {
                                        aState = 2;
                                      });
                                      findLocation(onLocationChange)
                                          .then((resolved) {
                                        Navigator.pop(context);
                                        setInnerState(() {
                                          aState = 1;
                                        });
                                      });
                                    },
                                    state: aState == 2 ? ButtonState.loading : ButtonState.normal),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.fromLTRB(
                                    0, 0, 0, Constants.spacing4),
                                child:
                                    const Text('atau', style: Constants.textSm),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const Text('Pilih Kota',
                                    style: Constants.textSm),
                              ),
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                    vertical: Constants.spacing2),
                                child: TextFormField(
                                  key: const Key('searchLocation'),
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: Constants.gray.shade200),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.red),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    hintText: 'Cari...',
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        Constants.spacing2,
                                        0,
                                        Constants.spacing2,
                                        0),
                                    suffixIcon: searchController.text.isNotEmpty
                                        ? IconButton(
                                            onPressed: () {
                                              searchController.text = '';
                                              searchCity('');
                                            },
                                            icon: const Icon(Icons.clear),
                                          )
                                        : const SizedBox(width: 0, height: 0),
                                  ),
                                  onChanged: (String? newValue) {
                                    searchCity(newValue ?? "");
                                  },
                                ),
                              ),
                              Expanded(
                                child: provinces.length == 1 &&
                                        provinces[0]['id'] == '...'
                                    ? const Center(
                                        child: Text('Sedang memuat kota...'),
                                      )
                                    : SingleChildScrollView(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: cityItems,
                                        ),
                                      ),
                              )
                            ],
                          ),
                          Positioned(
                              top: -5,
                              right: -5,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: SvgPicture.asset(
                                  'assets/svg/close.svg',
                                  width: 21,
                                  height: 21,
                                  alignment: Alignment.center,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          dismissable: true);
    });
  }
}
