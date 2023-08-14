import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kliknss77/application/app/app_log.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/services/dio_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/infrastructure/database/data_page.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/app_shimmer.dart';
import 'package:kliknss77/ui/component/dio_exceptions.dart';
import 'package:kliknss77/ui/component/icon_refresh_indicator.dart';
import 'package:kliknss77/ui/component/item/motor_hmc_item.dart';
import 'package:kliknss77/ui/shimmer/motor_shimmer.dart';

class HMCListView extends StatefulWidget {
  Map? hmc;
  dynamic e;
  List? kategory;
  String? sorts;
  HMCListView({this.hmc,this.kategory,this.sorts,this.e, super.key});

  @override
  State<HMCListView> createState() => _HMCListViewState();
}

class _HMCListViewState extends State<HMCListView> {
   final Dio _dio = DioService.getInstance();
  final _sharedPrefs = SharedPrefs();
  int isHavenotch = -1;
  List allselecteditem = [];

  String filterakhir = "";
  int? sortNo = 1;
  var keyItems = [];
  List<dynamic> tipeMotor = [];

  List<dynamic>? listSort = [];
  List valueItem = [];

  List<dynamic> listCategory = [];
  List<dynamic> listImages = [];

  List<String> sortReview = [];

  List<String>? sorts = [];
  var filterkategori = "";
  int sorting = 1;
  int state = 1;
  List<String>? sortlist = [];
  String? sort;
  TextEditingController searchController = TextEditingController();

   @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
    
      });
    
  }

  Future<dynamic> updateSortMotor(String selectedItems) async {
    try {
      setState(() {
        state = 2;
      });
      final cityId = await _sharedPrefs.get(SharedPreferencesKeys.cityId);

      // var param = {'city_id': cityId};
       sortNo = listSort?.firstWhere((element) => element['text'] == selectedItems)['id'];
      
      // map(
      //     (element) => element['text'] == selectedItems ? element['id'] : "");

      if (filterkategori == "") {
        filterakhir.isEmpty;
      } else {
        filterakhir = filterkategori;
      }
      final param = 
      filterakhir == ""  ? {
        "cityId": cityId ?? 158,
        "sort": sortNo,
      }:
      {
        "cityId": cityId ?? 158,
        "sort": sortNo,
        "filters[category]": filterakhir
      };
      final response =
          await _dio.get(Endpoint.getMotor, queryParameters: param);
      setState(() {
        widget.hmc?['items'] = response.data['items'];

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
      // AppDialog.snackBar(text: "")
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
      final response =
          await _dio.get(Endpoint.getMotor, queryParameters: param);
      setState(() {
        widget.hmc?['items'] = response.data['items'];
        widget.kategory = kategori;
        
            state = 1;
          });
          print("valueItem Key ${valueItem[0].key}");
      
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
    
    List? selectedItem = (widget.hmc ?? {}).isEmpty ? [] : (widget.hmc ?? {})['category'] ?? [];
    if (isHavenotch < 0) {
      isHavenotch = MediaQuery.of(context).viewPadding.top > 0 ? 1 : 0;
    }
    // if (widget.hmc.isEmpty) {
    keyItems = (widget.hmc ?? {}).isNotEmpty
        ? (widget.hmc ?? {})['data']['items'] != null
            ? (widget.hmc ?? {})['data']['items'].entries.map((e) => e).toList()
            : []
        : [];
    listCategory = (widget.hmc ?? {}).isEmpty ? [] : (widget.hmc ?? {})['data']['categories'] ?? [];
    listSort = (widget.hmc ?? {}).isEmpty ? [] : (widget.hmc ?? {})['data']['sorts'] ?? [];
    var listdynamic = (widget.hmc ?? {}).isEmpty
        ? []
        : (widget.hmc ?? {})['data']['sorts'] == null
            ? []
            : (widget.hmc ?? {})['data']['sorts'].map((e) => e['text']).toList();
    sortReview = (listdynamic as List).map((item) => item as String).toList();
    valueItem = (widget.hmc ?? {}).isNotEmpty
        ? (widget.hmc ?? {})['data']['items'].entries.map((e) => e).toList()
        : [];
    listImages = (widget.hmc ?? {}).isNotEmpty
        ? (widget.hmc ?? {})['images'].entries.map((e) => e).toList()
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
                // sort = sortss;
                widget.sorts = sortss;
                updateSortMotor(sortss ?? "");
              });
            }
            // validate();
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
                  Expanded(child: Text(widget.sorts ?? 'Pilih Urutan',softWrap: true,overflow: TextOverflow.ellipsis,)),
                  SvgPicture.asset('assets/svg/chevron_down.svg',width: 21, height: 21, color: Constants.gray,)],)));
    }

    Widget buildFilter(){
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
                      child: const Text("",style: TextStyle(),
                      ),
                    ),
                  ))
              : Container(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.only(
                      right: Constants.spacing4),
                  color: Constants.white,
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: Constants.spacing4),
                        width:
                            MediaQuery.of(context).size.width * 0.6,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(0),
                          scrollDirection: Axis.horizontal,
                          child: MultiSelectContainer(
                              textStyles: MultiSelectTextStyles(
                                  selectedTextStyle: TextStyle(
                                      color:
                                          Constants.gray.shade700,
                                      fontFamily: Constants
                                          .primaryFontBold),
                                  textStyle: TextStyle(
                                      color:
                                          Constants.gray.shade600)),
                              itemsDecoration:
                                  MultiSelectDecorations(
                                decoration: BoxDecoration(
                                    color: Constants.gray.shade100,
                                    border: Border.all(
                                      color:
                                          Constants.gray.shade300,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(15)),
                                selectedDecoration: BoxDecoration(
                                    // color: Colors.black,
                                    gradient:
                                        LinearGradient(colors: [
                                      Constants.pink.shade800,
                                      Constants.pink,
                                    ]),
                                    border: Border.all(
                                      color: Constants.red.shade400,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(15)),
                              ),
                              items: [
                                for (var component
                                    in listCategory.isNotEmpty
                                        ? listCategory
                                        : [])
                                  MultiSelectCard(

                                      // selected: viewModel.com,
                                      selected: widget.kategory !=
                                              null
                                          ? widget.kategory!.contains(
                                                      component[
                                                          'id']) ==
                                                  true
                                              ? true
                                              : false
                                          : false,
                                      splashColor: Constants.gray,
                                      highlightColor:
                                          Constants.black,
                                      value: component['id'],
                                      label: component['name']),
                              ],
                              onChange: (allSelectedItems,
                                  selectedItems) {
                                updateTipeMotor(
                                    allSelectedItems,
                                    selectedItem != null
                                        ? selectedItem.isNotEmpty
                                            ? selectedItem
                                                .toString()
                                            : ""
                                        : "");
                              }),
                        ),
                      ),
                      Expanded(child: buildsortReview(context)),

                      // buildTipeMotor();
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
                motorHmcItem(
                   ( widget.hmc ?? {}).isNotEmpty ? valueItem[index].value : [],
                    listCategory[index]['name'] ?? "",
                    ( widget.hmc ?? {}).isNotEmpty ? listImages[index].value : [],),
                    // listCategory.firstWhere((element) => (element['id'] == int.parse(valueItem[index].key)))),
              ],
            );
            // } else {
            //   return Container();
            // }
          },
          itemCount: valueItem.length);
    }

    return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: buildFilter()),
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