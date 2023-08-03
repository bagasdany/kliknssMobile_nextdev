import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import 'package:events_emitter/events_emitter.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/button.dart';
import 'package:kliknss77/ui/component/get_error_message.dart';


class DynamicTransparentHeader extends StatefulWidget {
  final dynamic warna;
  final dynamic iconkanan;
  final bool? isBack;
  // String chatCount = "1";

  Position? currentPosition;

  ScrollController? controller;

  final userLocation = (SharedPreferencesKeys.userLocation);
  TextEditingController searchController = TextEditingController();

  bool transparentMode;

  final location = SharedPrefs().get(SharedPreferencesKeys.userLocation);
  final double scrollOffset;
  dynamic keyMark;
  final Function(Map)? onLocationChange;
  DynamicTransparentHeader(
      {Key? key,
      this.warna,
      this.keyMark,
      this.iconkanan,
      this.isBack,
      this.onLocationChange,
      this.scrollOffset = 0.0,
      this.transparentMode = false,
      this.controller})
      : super(key: key);

  @override
  _DynamicTransparentHeaderState createState() => _DynamicTransparentHeaderState();
}

final events = EventEmitter();

class _DynamicTransparentHeaderState extends State<DynamicTransparentHeader>
    with AutomaticKeepAliveClientMixin<DynamicTransparentHeader> {
  @override
  bool get wantKeepAlive => true;
  double _opacity = 0.0;
  Color _warna = Constants.white;
  var _interceptor;

  int chatCount = 0;
  int notificationCount = 0;
  int cartCount = 0;
  Position? currentPosition;
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  String lokasi = "";
  final _sharedPrefs = SharedPrefs();

  final userLocation = (SharedPreferencesKeys.userLocation);

  final location = SharedPrefs().get(SharedPreferencesKeys.userLocation);

  final Dio _dio = DioService.getInstance();
  List<Map> provinces = [];
  String cityName =
      SharedPrefs().get(SharedPreferencesKeys.userLocation) ?? 'Belum diset';
  bool locationDenied = false;
  List<String> badges = [];
  int aState = 1; // 1: normal, 2: waiting for location

  EventListener? listener;
  EventListener? listenerbadges;

  Future<void> badgesUpdate() async {
    var listbadgesInitial = SharedPrefs().get(
      SharedPreferencesKeys.badges,
    );var badges = listbadgesInitial;

    setState(() {
      if (badges == null) {
        chatCount = 0;
        notificationCount = 0;
        cartCount = 0;
      } else {
        chatCount = badges[0] == null
            ? 0
            : badges[0] == "null"
                ? 0
                : badges[0] is String && badges[0] != null
                    ? int.parse((badges[0] ?? "0"))
                    : chatCount;
        notificationCount = badges[1] == "null"
            ? 0
            : badges[1]! is String
                ? 0
                : badges[1] != null
                    ? int.parse((badges[1] ?? "0"))
                    : notificationCount;
        cartCount = (badges ?? []).length > 2
            ? badges[2] == "null"
                ? 0
                : badges[2] != null
                    ? int.parse(badges[2] ?? "0")
                    : cartCount
            : 0;
      }

      cityName = SharedPrefs().get(SharedPreferencesKeys.userLocation) ??
          'Belum diset';
    });
  }

  void setstates() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_){
        _interceptor = DynamicTransparentHeaderInterceptor(callback: (listbadges) {
      if ((listbadges ?? []).isNotEmpty) {
        var listbadgesInitial = SharedPrefs().get(
          SharedPreferencesKeys.badges,
        );

        var badges = listbadges ?? listbadgesInitial;

        setState(() {
          if (badges == ["null"]) {
            chatCount = 0;
            notificationCount = 0;
            cartCount = 0;
          } else {
            chatCount = badges[0] == "null"
                ? 0
                : badges[0] is String && badges[0] != null
                    ? int.parse(badges[0])
                    : chatCount;
            notificationCount = badges[1] == "null"
                ? 0
                : badges[1]! is String
                    ? 0
                    : badges[1] != null
                        ? int.parse(badges[1])
                        : notificationCount;
            cartCount = (badges ?? []).length > 2
                ? badges[2] == "null"
                    ? 0
                    : badges[2] != null
                        ? int.parse(badges[2])
                        : cartCount
                : 0;
          }

          cityName = SharedPrefs().get(SharedPreferencesKeys.userLocation) ??
              'Belum diset';
        });
      } else {
        var listbadgesInitial = SharedPrefs().get(
          SharedPreferencesKeys.badges,
        );
        var badges = listbadgesInitial;

        setState(() {
          chatCount = badges[0] == "null"
              ? 0
              : badges[0] is String && badges[0] != null
                  ? int.parse(badges[0])
                  : chatCount;
          notificationCount = badges[1] == "null"
              ? 0
              : badges[1]! is String
                  ? 0
                  : badges[1] != null
                      ? int.parse(badges[1])
                      : notificationCount;
          cartCount = (badges ?? []).length > 2
              ? badges[2] == "null"
                  ? 0
                  : badges[2] != null
                      ? int.parse(badges[2])
                      : cartCount
              : 0;
          cityName = SharedPrefs().get(SharedPreferencesKeys.userLocation) ?? 'Belum diset';
        });
      }
    });

    _dio.interceptors.add(_interceptor);

    if (widget.transparentMode) {
      widget.controller?.addListener(() async {
        double scrollTop = widget.controller!.offset;
        double opacity = scrollTop > 30? 1: double.parse(((scrollTop < 0 ? 0 : scrollTop) / 30).toStringAsFixed(1));
        Color warna = scrollTop < 20? widget.warna: Constants.black.withOpacity(1.clamp(0, 1).toDouble());

        if (_opacity != opacity || _warna != warna) {
          setState(() {
            _opacity = opacity;
            _warna = warna;
          });
        }
      });
    } else {
      setState(() {
        _warna = Constants.black.withOpacity(1.clamp(0, 1).toDouble());
      });
    }
    if (listenerbadges != null) {
    } else {
      badgesUpdate();
    }

    listener = EventListener('locationChanged', (city) {
      setState(() {
        cityName = city['alias'];
      });
    });
    events.addEventListener(listener!);
        });
    
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _dio.interceptors.remove(_interceptor);
    if (listener != null) {
      events.removeEventListener(listener!);
    }
    if (listenerbadges != null) {
      events.removeEventListener(listener!);
    }
    super.dispose();
  }

  
  Future<bool> findLocation() async {
    Future<void> retrieveLocation() async {
      try {
        Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.bestForNavigation)
            .timeout(const Duration(seconds: 6));
        final param = {"lat": position.latitude, "lng": position.longitude};
        try {
          Response res =
              await _dio.get(Endpoint.requestKota, queryParameters: param);

          var city = res.data;
          setCity(city, position.latitude, position.longitude);
        } on TimeoutException catch (e) {
          setState(() {
            aState = 1;
          });
          // Navigator.pop(context);

          AppDialog.snackBar(
              text:
                  "Maaf, Koneksi internet anda kurang mendukung, Silahkan coba lagi / Pilih kota yang sudah tersedia");
        } on DioException catch (e) {
          setState(() {
            aState = 1;
          });
          // Navigator.pop(context);
          var message = e.response == null
              ? "Silahkan cek internet anda"
              : GetErrorMessage.getErrorMessage(e.response?.data['errors']);
          AppDialog.snackBar(text: message);
        }
      } on DioException catch (e) {
        setState(() {
          aState = 1;
        });
        // Navigator.pop(context);
        var message = e.response == null
            ? "Maaf, Koneksi internet anda kurang mendukung, Silahkan coba lagi / Pilih kota yang tersedia"
            : GetErrorMessage.getErrorMessage(e.response?.data['errors']);
        AppDialog.snackBar(text: message);
      } on TimeoutException catch (e) {
        setState(() {
          aState = 1;
        });
        // Navigator.pop(context);

        AppDialog.snackBar(
            text:
                "Maaf, Koneksi internet anda kurang mendukung, Silahkan coba lagi / Pilih Kota yang tersedia");
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        await retrieveLocation();
      } else if (permission == LocationPermission.deniedForever) {
        setState(() {
          aState = 1;
        });
        AppDialog.snackBar(
            text:
                "Izin Lokasi tidak diizinkan,silahkan izinkan lewat pengaturan aplikasi");
      }
    } else if (permission == LocationPermission.deniedForever) {
      setState(() {
        aState = 1;
      });
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

    setState(() {
      locationDenied = permission == LocationPermission.deniedForever;
    });
  }

  Future<List<Map>> getProvinces() async {
    const param = {"fields": "id,code,name,alias,cities"};
    Response response =
        await _dio.get(Endpoint.getProvinsi, queryParameters: param);

    setState(() {
      provinces = ((response.data['provinces'] as List)
          .map((item) => item as Map)
          .toList());
    });
    return (response.data['provinces'] as List)
        .map((item) => item as Map)
        .toList();
  }

  void setCity(city, double? lat, double? lng) {
    setState(() {
      cityName = city['alias'];
    });

    _sharedPrefs.set(SharedPreferencesKeys.cityId, city['id']);
    _sharedPrefs.set(SharedPreferencesKeys.userLocation, city['alias']);
    if (lat != null) {
      _sharedPrefs.set(SharedPreferencesKeys.latitude, lat);
      _sharedPrefs.set(SharedPreferencesKeys.longitude, lng);
    } else {
      _sharedPrefs.remove(SharedPreferencesKeys.latitude);
      _sharedPrefs.remove(SharedPreferencesKeys.longitude);
    }

    if (widget.onLocationChange != null) {
      widget.onLocationChange!(city);
    }

    events.emit('locationChanged', city);
  }

  Future<void> openDialog(BuildContext context) async {
    getLocationPermission().then((v) async {
      double maxWidth = MediaQuery.of(context).size.width * .85;
      double maxHeight = MediaQuery.of(context).size.height * .7;

      bool loaded = false;
      setState(() {
        aState = 1;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
                          getProvinces().then((provincess) {
                            setInnerState(() {
                              provinces = provincess ?? [];
                            });
                          });
                        });
                      }
                    });
                  }

                  void searchCity(String key) {
                    String lKey = key.toLowerCase();
                    int pLength = provinces.length;
                    for (var i = 0; i < pLength; i++) {
                      int cLength = (provinces[i]['cities'] ?? []).length;
                      bool searchExists = false;
                      for (var j = 0; j < cLength; j++) {
                        String cName = provinces[i]['cities']![j]['name'];
                        if (cName.toLowerCase().contains(lKey) ||
                            lKey.isEmpty) {
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
                              setCity(_city, null, null);
                              widget.searchController.text = '';
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
                                        findLocation().then((resolved) {
                                          Navigator.pop(context);
                                          setInnerState(() {
                                            aState = 1;
                                          });
                                        });
                                      },
                                      // state: aState
                                      ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.fromLTRB(
                                      0, 0, 0, Constants.spacing4),
                                  child: const Text('atau',
                                      style: Constants.textSm),
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
                                    key: const ValueKey("searchLocation"),
                                    controller: widget.searchController,
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
                                      suffixIcon: widget
                                              .searchController.text.isNotEmpty
                                          ? IconButton(
                                              onPressed: () {
                                                widget.searchController.text =
                                                    '';
                                                searchCity('');
                                              },
                                              icon: const Icon(Icons.clear),
                                            )
                                          : const SizedBox(width: 0, height: 0),
                                    ),
                                    onChanged: (String? newValue) {
                                      searchCity(newValue!);
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
                                  child: Container(
                                    key: const ValueKey("closeLocation"),
                                    padding: const EdgeInsets.only(
                                        left: Constants.spacing4,
                                        bottom: Constants.spacing4),
                                    child: SvgPicture.asset(
                                      'assets/svg/close.svg',
                                      key: const ValueKey("closeLocation"),
                                      width: 25,
                                      height: 25,
                                      alignment: Alignment.center,
                                    ),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentroute = ModalRoute.of(context)?.settings.name;
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);

    bool isHavenotch = MediaQuery.of(context).viewPadding.top > 5;
    return Container(
        color: Constants.white.withOpacity(_opacity),
        child: SafeArea(
          top: isHavenotch,
          child: Container(
            child: Column(
              children: [
                Container(
                    height: isHavenotch == true ? 40 : 60,
                    margin: EdgeInsets.only(top: isHavenotch == true ? 0 : 15),
                    padding: const EdgeInsets.symmetric(
                      vertical: 0.0,
                      horizontal: 10.0,
                    ),
                    color: Constants.white.withOpacity(
                        (widget.scrollOffset / 350).clamp(0, 1).toDouble()),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: isHavenotch == true ? 0 : 40),
                          height: 36,
                          decoration:
                              const BoxDecoration(color: Colors.transparent),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              (Navigator.canPop(context) && currentroute != '/'&& currentroute != '/agent')
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Icon(
                                        Icons.arrow_back,
                                        color: Constants.black,
                                        size: 26,
                                      ),
                                    )
                                  : Container(),

                              /// if user click shape white in appbar navigate to search layout
                              InkWell(
                                onTap: () {
                                  // Navigator.of(context).pushNamed('/search');
                                  // Navigator.push(
                                  //   context,
                                  //   PageRouteBuilder(
                                  //     pageBuilder: (_, __, ___) => SearchView(),
                                  //     transitionDuration:
                                  //         const Duration(seconds: 0),
                                  //   ),
                                  // );
                                },
                                child: Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.57,
                                  decoration: BoxDecoration(
                                      color: Constants.white,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                      border: Border.all(
                                          color: Constants.gray.shade200),
                                      shape: BoxShape.rectangle),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.only(
                                          left: Constants.spacing1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, left: Constants.spacing2),
                                        child: Text(
                                          ('Cari di KlikNSS'),
                                          style: TextStyle(
                                              // fontFamily: "Popins",
                                              color: Constants.gray.shade400,
                                              // fontWeight: FontWeight.m,
                                              // letterSpacing: 0.0,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /// Icon chat (if user click navigate to chat layout)
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/inbox');
                                },
                                child: CircleAvatar(
                                  radius: 19,
                                  backgroundColor: Constants.white,
                                  child: Stack(
                                    alignment:
                                        const AlignmentDirectional(1.4, -1.8),
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        'assets/svg/inbox.svg',
                                        width: 30,
                                        key: const ValueKey('appbar'),
                                        height: 30,
                                        alignment: Alignment.center,
                                        color: Colors.black,
                                      ),
                                      CircleAvatar(
                                        radius: 8.6,
                                        backgroundColor: chatCount > 0
                                            ? Constants.primaryColor
                                            : Colors.transparent,
                                        child: Text(
                                          chatCount > 0
                                              ? chatCount.toString()
                                              : "",
                                          style: const TextStyle(
                                              fontSize: Constants.fontSizeXs,
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/notification');
                                },
                                child: CircleAvatar(
                                  radius: 19,
                                  backgroundColor: Constants.white,
                                  child: Stack(
                                    alignment:
                                        const AlignmentDirectional(1.4, -1.8),
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        'assets/svg/notification.svg',
                                        width: 30,
                                        height: 30,
                                        alignment: Alignment.center,
                                        color: Colors.black,
                                      ),
                                      CircleAvatar(
                                        radius: 8.6,
                                        backgroundColor: notificationCount > 0
                                            ? Constants.primaryColor
                                            : Colors.transparent,
                                        child: Text(
                                          notificationCount > 0
                                              ? notificationCount.toString()
                                              : "",
                                          style: const TextStyle(
                                              fontSize: Constants.fontSizeXs,
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/initialcart');
                                },
                                child: CircleAvatar(
                                  radius: 19,
                                  backgroundColor: Constants.white,
                                  child: Stack(
                                    alignment:
                                        const AlignmentDirectional(1.4, -1.8),
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        'assets/svg/cart.svg',
                                        width: 30,
                                        height: 30,
                                        alignment: Alignment.center,
                                        color: Colors.black,
                                      ),
                                      CircleAvatar(
                                        radius: 8.6,
                                        backgroundColor: cartCount > 0
                                            ? Constants.primaryColor
                                            : Colors.transparent,
                                        child: Text(
                                          cartCount > 0
                                              ? cartCount.toString()
                                              : "",
                                          style: const TextStyle(
                                              fontSize: Constants.fontSizeXs,
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 0, left: 3),
                  child: Row(
                    key: widget.keyMark,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          openDialog(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(
                              0,
                              Constants.spacing1,
                              Constants.spacing4,
                              Constants.spacing2),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: Constants.spacing4),
                                child: Icon(Icons.location_on,
                                    size: 13, color: _warna),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                "Lokasi",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: _warna,
                                    fontFamily: Constants.primaryFontBold,
                                    letterSpacing: 0.5),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                cityName,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: Constants.primaryFontBold,
                                    color: _warna,
                                    letterSpacing: 0.5),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 13,
                                color: _warna,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class DynamicTransparentHeaderInterceptor extends InterceptorsWrapper {
  Function(List<String>)? callback;

  DynamicTransparentHeaderInterceptor({this.callback});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    var listbadgesInitial = (SharedPrefs().get(
          SharedPreferencesKeys.badges,
        ) ??
        "0,0,0");
    String? responseBadges = response.headers.value('kliknss-badge') == null
        ? (listbadgesInitial == "null" ? "0,0,0" : listbadgesInitial)
        : response.headers.value('kliknss-badge') ?? "0,0,0";

    await SharedPrefs().set(SharedPreferencesKeys.badges, responseBadges);
    List<String> listBadges = responseBadges!.split(',');
    if (callback != null) {
      callback!(listBadges);
    }
    events.emit('onBadgesChanged', listBadges);

    super.onResponse(response, handler);
  }
}
