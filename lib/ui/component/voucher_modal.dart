import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kliknss77/application/helpers/endpoint.dart';
import 'package:kliknss77/application/models/vouchers_models.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/infrastructure/apis/voucher_api.dart';
import 'package:kliknss77/ui/shimmer/banner_shimmer.dart';
import 'package:kliknss77/ui/shimmer/voucher_shimmer.dart';
import 'dart:developer' as developer;
import 'button.dart';

class VoucherModal extends StatefulWidget {
  Voucher? voucher;
  final int businessId;
  Function? onVoucherChanged;

  Function? onVoucherRemoved;
  dynamic seriesId,
      typeId,
      voucherId,
      colorId,
      paymentMethod,
      paymentType,
      price,
      term,
      code,
      cityId;
  bool disabled;
  dynamic state;
  Voucher? selectedVoucher;

  VoucherModal(
      {Key? key,
      required this.businessId,
      this.voucher,
      this.voucherId,
      this.seriesId,
      this.code,
      this.paymentMethod,
      this.paymentType,
      this.price,
      this.term,
      this.cityId,
      this.selectedVoucher,
      this.typeId,
      this.state,
      this.colorId,
      this.disabled = false,
      this.onVoucherRemoved,
      required this.onVoucherChanged})
      : super(key: key);

  @override
  _VoucherModalState createState() => _VoucherModalState();
}

class _VoucherModalState extends State<VoucherModal> {
  // Voucher? selectedVoucher;
  bool isLoadingVoucher = false;
  dynamic listAvailableVoucher;
  List<Voucher>? listUnavailableVoucher;

  List<Voucher> vouchers = [];
  final _dio = Dio();

  final _voucherApi = VoucherApi();
  int state = 1;

  final _textController = TextEditingController();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoadingVoucher = true;
      });
      _textController.text = widget.code ?? "";
      if (widget.voucher != null) {
        setState(() {
          widget.selectedVoucher = widget.voucher;
        });
      }
      await loadVoucher().then((value) async {
        if (widget.voucherId != null) {
          setState(() {
            widget.selectedVoucher = vouchers
                .firstWhere((element) => element.id == widget.voucherId);
          });
        }

        if(widget.code == null || widget.code == ""){
            await _getVoucherByCode(widget.businessId, ( ""))
            .then((value) async {
              if((value ??[]).isNotEmpty){
              setState(() {
                listAvailableVoucher = value;
              });
              }
          
        });
        }else if( widget.code != null && widget.code != ""){
          await _getVoucherByCode(widget.businessId, (widget.code))
            .then((value) async {
              if((value ??[]).isNotEmpty){
              setState(() {
                // listAvailableVoucher = value;
              widget.selectedVoucher = value[0] ?? null;
              });
              }
          
        });
        }

        
        

        setState(() {
          listUnavailableVoucher = getUnavailableVouchers();
        });

        setState(() {
          isLoadingVoucher = false;
        });
        print("widget.selectedvoucher ${widget.selectedVoucher}");
      });
    });
  }

  List<Voucher> getUnavailableVouchers() {
    dynamic listTempAll = vouchers;
    for (var allVoucher in vouchers) {
      for (var availableVoucher in (listAvailableVoucher ?? [])) {
        // kalau secara langsung error ConcurrentModificationError
        // (Concurrent modification during iteration: Instance(length:1) of '_GrowableList'.)
        //  terjadi ketika Anda mencoba mengubah sebuah daftar saat sedang melakukan iterasi (looping) di dalamnya

        List<Voucher> vouchersAllCopy = List.from(listTempAll);
        // vouchersAllCopy.removeWhere((voucher) => voucher.id == 13823);
        vouchersAllCopy
            .removeWhere((voucher) => voucher.id == availableVoucher.id);
        listTempAll = vouchersAllCopy;
      }
    }
    return (listTempAll ?? []);
  }

  Future<dynamic> loadVoucher() async {
    vouchers = await _getVoucher(
      widget.businessId,
      widget.seriesId,
      widget.typeId,
      widget.colorId,
    );
    setState(() {});
  }

  Future<bool> cekVoucher() async {
    try {
      final responnn = await _voucherApi.requestVoucher(
          widget.businessId, widget.seriesId, widget.typeId, widget.colorId);
      final params = {
        'businessId': widget.businessId.toString(),
        'seriesId': widget.seriesId,
        'typeId': widget.typeId,
        'colorId': widget.colorId
      };

      Response response =
          await _dio.get(Endpoint.requestVoucher, queryParameters: params);
      print("param respon $response");
      return true;
    } on DioException catch (e) {
      return false;
    }
  }

  void voucherModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (builder, setParentState) {
            double height = MediaQuery.of(context).size.height * .7;

            void _handleCleared() async {
              FocusScope.of(context).unfocus();
              setParentState(() {
                isLoadingVoucher = true;
              });
              _textController.clear();
              print("cleared ${_textController.text}");

              setParentState(() {
                vouchers = [];
              });
              await loadVoucher();
              await _getVoucherByCode(widget.businessId, "")
                  .then((value) async {
                setState(() {
                  listAvailableVoucher = value;
                });
              });
              setState(() {
                listUnavailableVoucher = getUnavailableVouchers();
              });
              setParentState(() {
                isLoadingVoucher = false;
              });
              setState(() {});
            }

            void _handleSubmitted(String? text) async {
              FocusScope.of(context).unfocus();
              setParentState(() {
                isLoadingVoucher = true;
              });
              await loadVoucher();
              // await _getVoucherByCode(1, "").then((value) async {
              //   setState(() {
              //     listAvailableVoucher = value;
              //   });
              // });
              // setState(() {
              //   listUnavailableVoucher = getUnavailableVouchers();
              // });

              var _vouchers = await _getVoucherByCode(
                  widget.businessId, (text ?? _textController.text));
              setParentState(() {
                setState(() {
                  listAvailableVoucher = _vouchers;
                  isLoadingVoucher = false;

                  FocusScope.of(context).unfocus();
                  setState(() {
                    listUnavailableVoucher = getUnavailableVouchers();
                  });

                  vouchers = _vouchers;

                  isLoadingVoucher = false;
                });
                FocusScope.of(context).unfocus();
              });
            }

            Widget buildSearch() {
              return Padding(
                padding: const EdgeInsets.fromLTRB(Constants.spacing4,
                    Constants.spacing2, Constants.spacing4, Constants.spacing4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4)),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Constants.gray.shade300,
                              width: 2.0,
                            ),
                            top: BorderSide(
                              color: Constants.gray.shade300,
                              width: 2.0,
                            ),
                            bottom: BorderSide(
                              color: Constants.gray.shade300,
                              width: 2.0,
                            ),
                          ),
                        ),
                        height: 44,
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          onFieldSubmitted: (value) {
                            _handleSubmitted(_textController.text);
                          },
                          controller: _textController,
                          decoration: InputDecoration(
                            suffixIcon: _textController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: _handleCleared,
                                    icon: const Icon(Icons.clear),
                                  )
                                : null,
                            filled: true,
                            fillColor: Constants.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: Constants.spacing3,
                                vertical: Constants.spacing3),
                            isCollapsed: true,
                            isDense: true,
                            hintText: "Masukkan Kode Voucher...",
                            hintStyle: const TextStyle(color: Constants.gray),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  style: BorderStyle.none,
                                  width: 0,
                                  // color: myFocusNode.hasFocus || controller.text.isNotEmpty
                                  //     ? MyColor.darkGreyColor
                                  //     : MyColor.greyColor,
                                  color: Constants.white),
                              borderRadius:
                                  BorderRadius.circular(Constants.spacing4),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  style: BorderStyle.none,
                                  width: 0,
                                  // color: myFocusNode.hasFocus || controller.text.isNotEmpty
                                  //     ? MyColor.darkGreyColor
                                  //     : MyColor.greyColor,
                                  color: Constants.white),
                              borderRadius:
                                  BorderRadius.circular(Constants.spacing4),
                            ),
                          ),
                        ),
                      ),
                    )),
                    ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        child: Container(
                          height: 44,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Constants.primaryColor,
                            border: Border(
                              left: BorderSide(
                                color: Constants.primaryColor,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              _handleSubmitted(_textController.text);
                            },
                            child: Center(
                              child: isLoadingVoucher == true
                                  ? Container(
                                      height: 20,
                                      width: 20,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Cari',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Constants.fontSizeLg),
                                    ),
                            ),
                          ),
                        )),
                  ],
                ),
              );
            }

            Widget buildVoucherItems() {
              return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.spacing4,
                      vertical: Constants.spacing2),
                  child: isLoadingVoucher == true
                      ? VoucherShimmer(state: isLoadingVoucher == true ? 2 : 1)
                      : vouchers.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.separated(
                                  padding: const EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 2),
                                        decoration: const BoxDecoration(
                                            color: Colors.white),
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                              dividerColor: Colors.transparent),
                                          child: ExpansionTile(
                                            initiallyExpanded: true,
                                            tilePadding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                            title: isLoadingVoucher
                                                ? BannerShimmer(
                                                    aspectRatio: 9 / 1)
                                                : Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: Constants
                                                                .spacing1),
                                                    child: Text(
                                                      "${listAvailableVoucher.length} Voucher Tersedia Untukmu",
                                                      style: const TextStyle(
                                                          // fontSize:
                                                          //     Constants.fontSizeLg,
                                                          fontFamily: Constants
                                                              .primaryFontBold),
                                                    ),
                                                  ),
                                            children: [
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    (listAvailableVoucher ?? [])
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  Voucher voucher =
                                                      (listAvailableVoucher ??
                                                          [])[index];

                                                  return SingleChildScrollView(
                                                    child: InkWell(
                                                      onTap: () {
                                                        widget.voucher?.code =
                                                            _textController
                                                                .text;
                                                        widget.code =
                                                            _textController
                                                                .text;
                                                        listAvailableVoucher[
                                                                    index]
                                                                ?.code =
                                                            _textController
                                                                .text;
                                                        widget.selectedVoucher =
                                                            listAvailableVoucher[
                                                                index];
                                                        widget.onVoucherChanged!(
                                                            listAvailableVoucher[
                                                                index]);
                                                        int selectedVoucherId =
                                                            listAvailableVoucher[
                                                                        index]
                                                                    .id ??
                                                                1;

                                                        Navigator.of(context)
                                                            .pop(); // TODO how to return values when popping, return voucher id
                                                      },
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Card(
                                                          margin: const EdgeInsets
                                                                  .only(
                                                              bottom: Constants
                                                                  .spacing2),
                                                          shadowColor: Colors
                                                              .transparent,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color: Constants
                                                                    .gray
                                                                    .shade300,
                                                                width: 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        Constants
                                                                            .spacing3),
                                                          ),
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      Constants
                                                                          .spacing4),
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    buildAvailableVoucher(
                                                                        voucher.title ??
                                                                            "",
                                                                        voucher.description ??
                                                                            "",
                                                                        voucher.endDate ??
                                                                            0,
                                                                        voucher.imageUrl ??
                                                                            "",
                                                                        voucher.tnc ??
                                                                            "",
                                                                        voucher.target ??
                                                                            "",
                                                                        "Ya"),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ));
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Divider();
                                  },
                                ),
                                (listUnavailableVoucher ?? []).isEmpty
                                    ? Container()
                                    : ListView.separated(
                                        padding: const EdgeInsets.all(0),
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 0, 0, 2),
                                              decoration: const BoxDecoration(
                                                  color: Colors.white),
                                              child: Theme(
                                                data: Theme.of(context)
                                                    .copyWith(
                                                        dividerColor:
                                                            Colors.transparent),
                                                child: ExpansionTile(
                                                  iconColor: Constants.black,
                                                  textColor: Constants.black,
                                                  collapsedIconColor:
                                                      Constants.black,
                                                  collapsedTextColor:
                                                      Constants.black,
                                                  initiallyExpanded: false,
                                                  tilePadding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 0),
                                                  title: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: Constants
                                                                .spacing1),
                                                    child: const Text(
                                                      "Voucher yang belum bisa dipakai",
                                                      style: TextStyle(
                                                          // fontSize: Constants
                                                          //     .fontSizeLg,
                                                          fontFamily: Constants
                                                              .primaryFontBold),
                                                    ),
                                                  ),
                                                  children: [
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          (listUnavailableVoucher ??
                                                                  [])
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        Voucher
                                                            listunavailable =
                                                            (listUnavailableVoucher ??
                                                                [])[index];

                                                        return SingleChildScrollView(
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Card(
                                                              color: Constants
                                                                  .gray,
                                                              margin: const EdgeInsets
                                                                      .only(
                                                                  bottom: Constants
                                                                      .spacing2),
                                                              shadowColor: Colors
                                                                  .transparent,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    color: Constants
                                                                        .gray
                                                                        .shade300,
                                                                    width: 1),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Constants
                                                                            .spacing3),
                                                              ),
                                                              child:
                                                                  SingleChildScrollView(
                                                                child:
                                                                    Container(
                                                                  color: Constants
                                                                      .gray
                                                                      .shade100,
                                                                  padding: const EdgeInsets
                                                                          .all(
                                                                      Constants
                                                                          .spacing4),
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        buildAvailableVoucher(
                                                                            listunavailable.title ??
                                                                                "",
                                                                            listunavailable.description ??
                                                                                "",
                                                                            listunavailable.endDate ??
                                                                                0,
                                                                            listunavailable.imageUrl ??
                                                                                "",
                                                                            listunavailable.tnc ??
                                                                                "",
                                                                            listunavailable.target ??
                                                                                "",
                                                                            "Tidak"),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ));
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return const Divider();
                                        },
                                      ),
                              ],
                            )
                          : Container(
                              padding: const EdgeInsets.all(Constants.spacing4),
                              child: const Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Pilihan voucher tidak tersedia',
                                      style: TextStyle(
                                        color: Constants.gray,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ));
            }

            return FractionallySizedBox(
              heightFactor: 0.7,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Constants.white,
                  shadowColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                    padding: const EdgeInsets.all(
                                        Constants.spacing4),
                                    child: const Text('Pilih Voucher',
                                        style: TextStyle(
                                            fontSize: Constants.fontSizeLg,
                                            fontFamily:
                                                Constants.primaryFontBold)))),
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.all(Constants.spacing4),
                                  child: SvgPicture.asset(
                                    'assets/svg/close.svg',
                                    width: 24,
                                    height: 24,
                                    alignment: Alignment.center,
                                    color: Constants.gray,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: buildSearch(),
                  ),
                ),
                body: Stack(
                  children: [
                    Container(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Container(
                        height: height,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: Constants.spacing1),
                              Card(
                                child: SizedBox(
                                  child: Scrollbar(
                                    child: SingleChildScrollView(
                                        child: SizedBox(
                                            child: buildVoucherItems())),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  // getVoucher function, when startup and clearsearch
  Future<List<Voucher>> _getVoucher(
      int businessId, seriesId, typeId, colorId) async {
    ResponseGetVoucherModel? getVoucherM2wModel;
    final responnn =
        await _voucherApi.requestVoucher(businessId, seriesId, typeId, colorId);
    responnn.fold((e) {
      // return Left(ResponseSearchResultModel.errorJson({
      //   'error': e.response?.data['error 1'],
      //   'data': e.response?.data['error data'],
      // }));
      // dynamic message =
      //     GetErrorMessage.getErrorMessage(e.response?.data['errors']);
      // AppDialog.snackBar(text: message);
      // widget.voucher = null;
      // setState(() {
      //   widget.voucher = null;
      // });
      // return message;
    }, (response) {
      getVoucherM2wModel = response;
    });
    return getVoucherM2wModel?.vouchers ?? [];
  }

  // getVoucherByCode function, when press search
  Future<List<Voucher>> _getVoucherByCode(int businessId, String code) async {
    ResponseGetVoucherModel? getVoucherM2wModel;
    final responnn = await _voucherApi.requestVoucherByCode(
        businessId,
        code,
        widget.seriesId,
        widget.typeId,
        widget.colorId,
        widget.paymentMethod,
        widget.paymentType,
        widget.price,
        widget.term,
        widget.cityId);
    responnn.fold((errorResponse) {
      developer.log(errorResponse.toString(), name: 'Error get token');
    }, (response) {
      getVoucherM2wModel = response;
      developer.log('${response.vouchers}', name: 'series');
    });
    return getVoucherM2wModel!.vouchers!;
  }

  @override
  Widget build(BuildContext context) {
    return _buildVoucherCardSection(context);
  }

  Widget buildAvailableVoucher(
      title, description, endDate, imageUrl, tnc, target, available) {
    return Container(
      color: available == "Ya" ? Constants.white : Constants.gray.shade100,
      child: Column(
        children: [
          Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                imageUrl == null || imageUrl == ""
                    ? Container()
                    : Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(),
                            child: AspectRatio(
                              aspectRatio: 4 / 1,
                              child: CachedNetworkImage(
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    ),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                fit: BoxFit.fill,
                                imageUrl: imageUrl ?? "",
                                errorWidget: (context, url, error) => Container(
                                  decoration: BoxDecoration(
                                      color: Constants.gray.shade200,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(Constants.spacing3))),
                                  width: 55,
                                  height: 60,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                Positioned(
                    left: -15,
                    child: SizedBox(
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          color: Constants.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )),
                Positioned(
                    right: -15,
                    child: SizedBox(
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                            color: Constants.white, shape: BoxShape.circle),
                      ),
                    )),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                    child: Container(
                  padding: EdgeInsets.only(
                      top: imageUrl == null || imageUrl == ""
                          ? 0
                          : Constants.spacing2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                title ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                    fontSize: Constants.fontSizeMd),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: Constants.spacing1,
                      ),
                      description == null || description == ""
                          ? Container()
                          : Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      description ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                          fontSize: Constants.fontSizeSm,
                                          color: Constants.gray),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      available == "Ya"
                          ? Container()
                          : tnc == null || tnc == ""
                              ? Container()
                              : Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: Constants.spacing1),
                                        child: Text(
                                          tnc ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.clip,
                                          style: const TextStyle(
                                              fontSize: Constants.fontSizeSm,
                                              color: Constants.gray),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                      endDate == "" || endDate == null
                          ? Container()
                          : const SizedBox(
                              height: Constants.spacing2,
                            ),
                      endDate == "" || endDate == null
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  color: available == "Ya"
                                      ? Constants.primaryColor.shade300
                                      : Constants.gray,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: const Text(
                                        "Berlaku Hingga",
                                        style: TextStyle(
                                            color: Constants.gray,
                                            fontSize: Constants.fontSizeSm),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: Constants.spacing1,
                                    ),
                                    Container(
                                      // padding: const EdgeInsets.only(
                                      //     bottom: Constants.spacing1),
                                      child: Text(
                                        endDate.toString() ?? "",
                                        style: TextStyle(
                                          fontSize: Constants.fontSizeSm,
                                          color: available == "Ya"
                                              ? Constants.primaryColor.shade400
                                              : Constants.gray,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVoucherCardSection(BuildContext context) {
    Widget buildSelectVoucher() {
      return isLoadingVoucher == true
          ? BannerShimmer(aspectRatio: 6.4 / 1)
          : InkWell(
              onTap: !widget.disabled
                  ? () {
                      FocusScope.of(context).unfocus();
                      voucherModalBottomSheet(context);
                    }
                  : null,
              child: Card(
                shadowColor: Colors.transparent,
                margin: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: widget.disabled
                          ? Constants.gray.shade200
                          : Constants.gray.shade300,
                      width: 1),
                  borderRadius: BorderRadius.circular(Constants.spacing3),
                ),
                child: Container(
                    padding: const EdgeInsets.all(Constants.spacing3),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/icon/vouchers_icon.png",
                                color: widget.disabled
                                    ? Constants.gray.shade300
                                    : Constants.primaryColor,
                                width: 30,
                                height: 30),
                            const SizedBox(width: Constants.spacing2),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Gunakan Voucher",
                                    style: TextStyle(
                                        fontSize: Constants.fontSizeMd,
                                        fontFamily: Constants.primaryFontBold,
                                        color: widget.disabled
                                            ? Constants.gray.shade300
                                            : Constants.primaryColor)),
                                const SizedBox(width: Constants.spacing1),
                                Text("Klik Untuk cek promosi/potongan Harga",
                                    style: TextStyle(
                                        fontSize: Constants.fontSizeSm,
                                        color: widget.disabled
                                            ? Constants.gray.shade300
                                            : Constants.gray.shade400,
                                        fontFamily: Constants.primaryFontBold))
                              ],
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            );
    }

    Widget buildAvalilableVouchers() {
      return isLoadingVoucher == true
          ? BannerShimmer(aspectRatio:  6.4 / 1)
          : InkWell(
              onTap: !widget.disabled
                  ? () {
                      FocusScope.of(context).unfocus();
                      voucherModalBottomSheet(context);
                    }
                  : null,
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                color: Constants.gray.shade300,
                padding: const EdgeInsets.all(0),
                strokeWidth: 2,
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Container(
                        decoration: const BoxDecoration(),
                        padding: const EdgeInsets.all(Constants.spacing3),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset("assets/icon/vouchers_icon.png",
                                    width: 30, height: 30),
                                const SizedBox(width: Constants.spacing2),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    isLoadingVoucher == true
                                        ? BannerShimmer(aspectRatio: 9 / 1)
                                        : Text(
                                            "${((listAvailableVoucher ?? []).length)} Voucher Tersedia",
                                            style: TextStyle(
                                                fontSize: Constants.fontSizeMd,
                                                fontFamily:
                                                    Constants.primaryFontBold,
                                                color: widget.disabled
                                                    ? Constants.gray.shade300
                                                    : Constants.primaryColor)),
                                    const SizedBox(height: Constants.spacing1),
                                    Text(
                                        "Klik disini Untuk menggunakan voucher",
                                        style: TextStyle(
                                            fontSize: Constants.fontSizeSm,
                                            color: Constants.gray.shade400,
                                            fontFamily:
                                                Constants.primaryFontBold))
                                  ],
                                )
                              ],
                            ),
                          ],
                        ))),
              ));
    }

    Widget buildSelectedVoucherCardBody(voucher) {
      return DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        color: Constants.gray.shade300,
        padding: const EdgeInsets.all(0),
        strokeWidth: 2,
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(Constants.spacing3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/icon/vouchers_icon.png",
                      width: 30, height: 30),
                  const SizedBox(width: Constants.spacing2),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${voucher.title}" ?? "",
                              style: const TextStyle(
                                  fontSize: Constants.fontSizeMd,
                                  fontFamily: Constants.primaryFontBold)),
                          const SizedBox(height: Constants.spacing1),
                          Text(
                            voucher.description ?? "",
                            style: Constants.textSm,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    // padding: const EdgeInsets.symmetric(
                    //     vertical: Constants.spacing3, horizontal: Constants.spacing2),
                    child: Button(
                        type: ButtonType.minimal,
                        iconSvg: 'assets/svg/close.svg',
                        onPressed: () {
                          if (widget.onVoucherRemoved != null) {
                            widget.businessId == 2
                                ? widget.onVoucherRemoved!()
                                : widget.onVoucherRemoved!(null);
                          }
                          // widget.onVoucherChanged!(null);
                          setState(() {
                            widget.voucher = null;
                            widget.selectedVoucher = null;
                          });
                        }),
                  )
                ],
              ),
            )),
      );
    }

    return Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(
            // side: BorderSide(
            //     color: widget.disabled
            //         ? Constants.gray.shade200
            //         : Constants.gray.shade300,
            //     width: 1),
            // borderRadius: BorderRadius.circular(Constants.spacing3),
            ),
        child: isLoadingVoucher == true
            ? BannerShimmer(aspectRatio:  6.4 / 1)
            : widget.disabled
                ? buildSelectVoucher()
                : widget.selectedVoucher != null
                    ? buildSelectedVoucherCardBody(widget.selectedVoucher!)
                    : vouchers.isNotEmpty
                        ? buildAvalilableVouchers()
                        : widget.selectedVoucher == null
                            ? buildSelectVoucher()
                            : buildSelectedVoucherCardBody(
                                widget.selectedVoucher!));

    // DottedBorder(
    //   color: Colors.black,
    //   strokeWidth: 1,
    //   child:
    // );
  }
}
