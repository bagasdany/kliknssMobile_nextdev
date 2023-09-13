import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kliknss77/application/app/app_log.dart';
import 'package:kliknss77/application/builders/data_builder.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/infrastructure/database/data_state.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/app_shimmer.dart';
import 'package:kliknss77/ui/component/dio_exceptions.dart';
import 'package:kliknss77/ui/component/item/motor_hmc_item.dart';
import 'package:kliknss77/ui/shimmer/motor_shimmer.dart';

class HMCListView extends StatefulWidget {
  Map? page = {};
  Map? hmc;
  dynamic e;
  List? kategory;
  String? sorts;
  HMCListView({this.page, this.kategory, this.sorts, this.e, this.hmc, super.key});

  @override
  State<HMCListView> createState() => _HMCListViewState();
}

class _HMCListViewState extends State<HMCListView> with SingleTickerProviderStateMixin {
  // DataState? dataState = DataBuilder(("/motor-list")).getDataState();
  final Dio _dio = DioService.getInstance();
  final _sharedPrefs = SharedPrefs();
  int isHavenotch = -1;

  dynamic _listcontroller;
  List allselecteditem = [];
  final double maxTranslation = 50;
  String filterakhir = "";
  int countsfilter = 99;
  int? sortNo = 1;
  var keyItems = [];
  List<dynamic> tipeMotor = [];
  List<dynamic>? listSort = [];
  List valueItem = [];
  List<dynamic> listCategory = [];
  List<dynamic> listImages = [];
  List<String> sortReview = [];
  List<String>? sorts = [];
  dynamic combinedList;
  var filterkategori = "";
  int sorting = 1;
  int state = 1;
  List<String>? sortlist = [];
  String? sort;
  dynamic combinedMap;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
   

    WidgetsBinding.instance.addPostFrameCallback((_) {
       _listcontroller = AnimationController(
        duration: const Duration(milliseconds: 900),
        vsync: this,
      );
      print("doing hmc list view }");
       setState(() {
        widget.page = DataBuilder(("/motor-list")).getDataState().getData();
        widget.page?['data'] =  widget.hmc;
        combinedList = [];
        combinedList.add({"title": "Tipe Motor" ,"items":  widget.page?['data']['data']?['categories'],"selected" : false});
        combinedList.add({"title": "Urut Berdasarkan" ,"items": widget.page?['data']['data']?['sorts'],"selected" : false});
        combinedList.add({"title": "Harga Mulai Dari","items": widget.page?['data']['data']?['prices'],"selected" : false});
     
        print("combinedList $combinedMap");
      
      });
    });
  }

  Future<dynamic> updateSortMotor(String selectedItems) async {
    try {
      setState(() {
        state = 2;
      });
      final cityId = await _sharedPrefs.get(SharedPreferencesKeys.cityId);

      sortNo = listSort
          ?.firstWhere((element) => element['text'] == selectedItems)['id'];

      if (filterkategori == "") {
        filterakhir.isEmpty;
      } else {
        filterakhir = filterkategori;
      }
      final param = filterakhir == ""
          ? {
              "cityId": cityId ?? 158,
              "sort": sortNo,
            }
          : {
              "cityId": cityId ?? 158,
              "sort": sortNo,
              "filters[category]": filterakhir
            };
      final response = await _dio.get(Endpoint.getMotor, queryParameters: param);
      setState(() {
        widget.page?['data']?['data']?['items'] = response.data['data']?['items'];
        state = 1;
      });
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

  Future<dynamic> updateTipeMotor(List kategori, String selectedItems) async {
    try {
      setState(() {
        state = 2;
      });
      final cityId = await _sharedPrefs.get(SharedPreferencesKeys.cityId);

      filterkategori = kategori.join(",");
      if (filterkategori == "") {
        filterakhir = "";
      } else {
        filterakhir = filterkategori;
      }
      final param = {
        "cityId": cityId,
        "sort": sortNo,
        "filters[category]": filterakhir
      };
      final response = await _dio.get(Endpoint.getMotor, queryParameters: param);
      setState(() {
        widget.page?['data']?['data']?['items'] = response.data['data']?['items'];
        widget.kategory = kategori;
        state = 1;
      });
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

  @override
  Widget build(BuildContext context) {
    List? selectedItem = (widget.page?['data'] ?? {}).isEmpty
        ? []
        : (widget.page?['data'] ?? {})['category'] ?? [];
    if (isHavenotch < 0) {
      isHavenotch = MediaQuery.of(context).viewPadding.top > 0 ? 1 : 0;
    }
    keyItems = (widget.page?['data'] ?? {}).isNotEmpty
        ? (widget.page?['data'] ?? {})['data']['items'] != null
            ? (widget.page?['data'] ?? {})['data']['items'].entries.map((e) => e).toList()
            : []
        : [];
    listCategory = (widget.page?['data'] ?? {}).isEmpty
        ? []
        : (widget.page?['data'] ?? {})['data']['categories'] ?? [];
    listSort = (widget.page?['data'] ?? {}).isEmpty
        ? []
        : (widget.page?['data'] ?? {})['data']['sorts'] ?? [];
    var listdynamic = (widget.page?['data'] ?? {}).isEmpty
        ? []
        : (widget.page?['data'] ?? {})['data']['sorts'] == null
            ? []
            : (widget.page?['data'] ?? {})['data']['sorts'].map((e) => e['text']).toList();
    sortReview = (listdynamic as List).map((item) => item as String).toList();
    valueItem = (widget.page?['data'] ?? {}).isNotEmpty
        ? (widget.page?['data'] ?? {})['data']['items'].entries.map((e) => e).toList()
        : [];
    listImages = (widget.page?['data'] ?? {}).isNotEmpty
        ? (widget.page?['data'] ?? {})['images'].entries.map((e) => e).toList()
        : [];
    AppLog().logScreenView('Motor');

    Widget buildsortReview(BuildContext context) {
      return InkWell(
        onTap: () async {
          dynamic sortss = await AppDialog.showTextSelector(
              context, sortReview,
              title: 'Pilih Urutan');
          if (sortss == "" || sortss == null) {
            setState(() {
              sort = sortReview[0];
            });
          } else {
            setState(() {
              widget.sorts = sortss;
              updateSortMotor(sortss ?? "");
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(color: Constants.gray.shade300),
            borderRadius: BorderRadius.circular(15),
            color: Constants.gray.shade100,
          ),
          child: Row(
            children: [
              Expanded(child: Text(widget.sorts ?? 'Pilih Urutan', softWrap: true, overflow: TextOverflow.ellipsis)),
              SvgPicture.asset('assets/svg/chevron_down.svg', width: 21, height: 21, color: Constants.gray),
            ],
          ),
        ),
      );
    }

    Widget filterTry() {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            
              _listcontroller == null ?  _listcontroller?.value = scrollNotification.metrics.pixels / maxTranslation : null;
            
             
          }
          return false;
        },
        child: 
        _listcontroller == null ? Container():
        AnimatedBuilder(
          animation: _listcontroller == null ? null : (_listcontroller )?.view,
          builder: (context, child) {
            return SingleChildScrollView(
              child: Container(
                color: Constants.white,
                child: AppShimmer(
                  active: state == 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          AppDialog.showBottomSheetExpandable(
                              context: context,
                              maxChildSize: 0.8,
                              minChildSize: 0.3,
                              initialChildSize: 0.5,
                              statefulbuilder: StatefulBuilder(
                                builder: (context, setParentState) {
                                  return Container();
                                },
                              ));
                        },
                        child: Container(
                          height: 40,
                          width: _listcontroller == null ? 80 : _listcontroller?.value == 0.0 ? 80.0 : (80.0 - (40 * _listcontroller?.value)),
                          margin: const EdgeInsets.only(right: Constants.spacing1),
                          decoration: BoxDecoration(
                              border: Border.all(color: Constants.gray.shade200),
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                              color: Constants.gray.shade100,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: Constants.spacing2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/chevron_down.svg',
                                width: 20,
                                height: 20,
                                color: Constants.gray.shade500,
                                alignment: Alignment.center,
                              ),
                              _listcontroller == null ? Container(): _listcontroller?.value == 1 ? Container() : Expanded(
                                child: Text(
                                  countsfilter == 99 ? "Filter" : countsfilter == 0 ? "Tidak ada data" : "($countsfilter)",
                                  style: TextStyle(color: Constants.gray.shade500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: (combinedList ?? []).length,
                            itemBuilder: (context, index) {
                              
                              print("contohini $combinedList");
                              return SingleChildScrollView(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: ()async {
                                        var a =  combinedList[index]["items"].toList();
                                        // widget.hmc['sorts'].map((e) => e['text']).toList()
                                        var b = a.map((e) =>  e['text'] ?? e['name'] as String).toList();
                                        print("a"); 
                                        // (widget.page?['data'] ?? {})['data']['sorts'].map((e) => e['text']).toList()
                                        dynamic sortss = await AppDialog.showTextSelector(
                                            context, b,
                                            title: 'Pilih Urutan');
                                        if (sortss == "" || sortss == null) {
                                          setState(() {
                                            sort = sortReview[0];
                                          });
                                        } else {
                                          setState(() {
                                            widget.sorts = sortss;
                                            updateSortMotor(sortss ?? "");
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        margin: const EdgeInsets.only(right: Constants.spacing1),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Constants.gray.shade200),
                                          color: Constants.white,
                                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: Constants.spacing2,
                                            horizontal: Constants.spacing4),
                                        child: Text((combinedList ??[])[index]['title'].toString().replaceAll('(', '').replaceAll(')', ''), style: TextStyle(color: Constants.gray.shade500)),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    Widget buildFilter() {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: Constants.spacing2),
        color: Constants.white,
        padding: const EdgeInsets.symmetric(vertical: Constants.spacing2),
        child: state == 2
            ? AppShimmer(
                active: state == 2,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    color: Constants.gray,
                    child: const Text(
                      "",
                      style: TextStyle(),
                    ),
                  ),
                ))
            : Container(
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.only(right: Constants.spacing4),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: Constants.spacing4),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: MultiSelectContainer(
                        textStyles: MultiSelectTextStyles(
                            selectedTextStyle: TextStyle(color: Constants.gray.shade700, fontFamily: Constants.primaryFontBold),
                            textStyle: TextStyle(color: Constants.gray.shade600)),
                        itemsDecoration: MultiSelectDecorations(
                          decoration: BoxDecoration(
                            color: Constants.gray.shade100,
                            border: Border.all(
                              color: Constants.gray.shade300,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          selectedDecoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Constants.pink.shade800,
                              Constants.pink,
                            ]),
                            border: Border.all(
                              color: Constants.red.shade400,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        items: [
                          for (var component in (listCategory ?? []).isNotEmpty ? listCategory : [])
                            MultiSelectCard(
                              selected: widget.kategory != null
                                  ? widget.kategory?.contains(component['id']) == true
                                  ? true
                                  : false
                                  : false,
                              splashColor: Constants.gray,
                              highlightColor: Constants.black,
                              value: component['id'],
                              label: component['name'],
                            ),
                        ],
                        onChange: (allSelectedItems, selectedItems) {
                          updateTipeMotor(allSelectedItems, selectedItem != null ? selectedItem.isNotEmpty ? selectedItem.toString() : "" : "");
                        },
                      ),
                    ),
                    Expanded(child: buildsortReview(context)),
                  ],
                ),
              ),
      );
    }

    Widget motorSection() {
      return ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                motorHmcItem((widget.page?['data'] ?? {}).isNotEmpty ? valueItem[index].value : [], listCategory[index]['name'] ?? "",
                    (widget.page?['data'] ?? {}).isNotEmpty && (widget.page?['data']['images'] ?? []).isNotEmpty  ? listImages[index].value : []),
              ],
            );
          },
          itemCount: valueItem.length);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Constants.white,
            padding: EdgeInsets.symmetric(horizontal: Constants.spacing4, vertical: Constants.spacing3),
            child: filterTry(),
          ),
          state == 2
              ? MotorShimmer(state: state)
              : Container(child: motorSection()),
          const SizedBox(
            height: Constants.spacing6,
          ),
        ],
      ),
    );
  }
}
