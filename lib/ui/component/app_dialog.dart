import 'dart:async';

import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kliknss77/application/services/app_navigation_service.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/infrastructure/database/data_page.dart';
import 'package:kliknss77/ui/component/city_selector.dart';
import 'package:kliknss77/ui/component/city_selector_agent.dart';
import 'package:kliknss77/ui/component/kelurahan_selector.dart';
import 'package:kliknss77/ui/component/webview_page.dart';
import 'package:kliknss77/ui/views/login/login_view.dart';
import 'package:kliknss77/utils/preload_image.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:url_launcher/url_launcher.dart';
import 'button.dart';
import 'package:intl/intl.dart' as intl;


bool currentOffer = false;
bool currentAlert = false;
bool currentConfirm = false;

class AppDialog {
  static Future<Object?> custom(
      {required builder, dismissable = true, barrierDismissible}) {
    if (AppNavigatorService.navigatorKey.currentContext != null) {
      return showGeneralDialog(
          barrierColor: Colors.black.withOpacity(0.5),
          context: AppNavigatorService.navigatorKey.currentContext!,
          barrierDismissible: barrierDismissible ?? true,
          barrierLabel: "",
          pageBuilder: (ctx, a1, a2) {
            return Container();
          },
          transitionBuilder: (ctx, a1, a2, child) {
            var curve = Curves.easeOutCubic.transform(a1.value);
            return Transform.scale(
              scale: curve,
              child: builder(ctx),
            );
          },
          transitionDuration: const Duration(milliseconds: 200));
    }
    return Future.delayed(const Duration(seconds: 0));
  }

  static void openUrl(url) {
    if (url != null) {
      if (AppNavigatorService.navigatorKey.currentContext != null) {
        Navigator.pushNamed(
            AppNavigatorService.navigatorKey.currentContext!, url);
      }
    }
  }

  static void openUrlDynamic(url) {
 
   Navigator.of(AppNavigatorService.navigatorKey.currentContext!)
            .pushNamed("$url"); 
  }

  static void openUrlPage(url,response) async{
     String replacedString = "";
    if(url.toString().contains("?") && !url.toString().contains("artikel")){

     replacedString = url.replaceAll('?', ',');
    }else if(url.toString().contains("artikel")){
      replacedString = "/artikel";
    }
  await Navigator.of(AppNavigatorService.navigatorKey.currentContext!)
            .pushNamed("/custom-pages$replacedString",arguments: response.data); 
  
  }

  static void openUrlRemoveUntilLogin(dynamic onSuccess) {
    if (AppNavigatorService.navigatorKey.currentContext != null) {
      Navigator.pushAndRemoveUntil(
          AppNavigatorService.navigatorKey.currentContext!,
          MaterialPageRoute(
              builder: (context) => LoginView(
                    onSuccess: onSuccess,
                  )),
          (route) => false);

      ModalRoute.withName('/');
    }
  }

  static void alert(
      {required title, description = '', buttonText = 'OK', onPress}) {
    if (!currentAlert) {
      AppDialog.custom(
              builder: (BuildContext context) => AlertDialog(
                    titlePadding: const EdgeInsets.all(Constants.spacing4),
                    contentPadding: const EdgeInsets.fromLTRB(
                        Constants.spacing4,
                        0,
                        Constants.spacing4,
                        Constants.spacing4),
                    actionsPadding: const EdgeInsets.symmetric(
                        horizontal: Constants.spacing2, vertical: 0),
                    scrollable: true,
                    title: Text(title, style: Constants.heading4),
                    content: Text(description),
                    actions: <Widget>[
                      Button(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (onPress != null) onPress();
                          currentAlert = false;
                        },
                        text: buttonText,
                      ),
                    ],
                  ),
              dismissable: onPress == null)
          .then((value) {
        currentAlert = false;
      });
    }
  }

  static void editDialog(
      {required title, description = '', buttonText, onPress, child}) {
    if (!currentAlert) {
      AppDialog.custom(
              builder: (BuildContext context) => AlertDialog(
                    backgroundColor: Constants.gray.shade100,
                    titlePadding: const EdgeInsets.all(Constants.spacing4),
                    contentPadding: const EdgeInsets.fromLTRB(
                        Constants.spacing4,
                        0,
                        Constants.spacing4,
                        Constants.spacing4),
                    actionsPadding: const EdgeInsets.symmetric(
                        horizontal: Constants.spacing2, vertical: 0),
                    scrollable: true,
                    title: Container(
                      color: Constants.gray.shade300,
                      child: Row(
                        children: [
                          Text(title, style: Constants.heading4),
                        ],
                      ),
                    ),
                    content: child,
                    actions: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Constants.spacing2),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Button(
                              onPressed: () {
                                Navigator.of(context).pop();
                                if (onPress != null) onPress();
                                currentAlert = false;
                              },
                              text: buttonText,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              dismissable: onPress == null)
          .then((value) {
        currentAlert = false;
      });
    }
  }

  //list kebutuhan keluarga

  static void confirm(
      {required title,
      description = '',
      keyOnConfirm,
      keyOnCancel,
      confirmText = 'OK',
      onConfirm,
      cancelText = 'Cancel',
      onCancel}) {
    if (!currentConfirm) {
      AppDialog.custom(
              builder: (BuildContext context) => AlertDialog(
                    titlePadding: const EdgeInsets.all(Constants.spacing4),
                    contentPadding: const EdgeInsets.fromLTRB(
                        Constants.spacing4,
                        0,
                        Constants.spacing4,
                        Constants.spacing4),
                    actionsPadding: const EdgeInsets.symmetric(
                        horizontal: Constants.spacing4,
                        vertical: Constants.spacing2),
                    scrollable: true,
                    title: Text(title, style: Constants.heading4),
                    content: Text(description),
                    actions: <Widget>[
                      Button(
                          key: keyOnConfirm,
                        text: confirmText,
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (onConfirm != null) onConfirm();
                          currentConfirm = false;
                        },
                      ),
                      const SizedBox(
                        width: Constants.spacing1,
                      ),
                      Button(
                          type: ButtonType.minimal,
                          key: keyOnCancel,
                          text: cancelText,
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (onCancel != null) onCancel();
                            currentConfirm = false;
                          }),
                    ],
                  ),
              dismissable: onConfirm == null && onCancel == null)
          .then((v) {
        currentConfirm = false;
      });
    }
  }

  static void snackBar({required text, duration = 2}) {
    scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: duration),
    ));
  }

  static void showNotification(title, {description = '', imageUrl, target}) {
    // target = "/account/orders/94287";
    Image img;
    if (imageUrl == null) {
      img = Image.asset('assets/images/kliknss.png', width: 72);
    } else {
      img = Image.network(imageUrl, width: 72);
    }
    int _counter = 0;

    showOverlayNotification((context) {
      return Dismissible(
        resizeDuration: null,
        onDismissed: (DismissDirection direction) {
          OverlaySupportEntry.of(context)?.dismiss();
        },
        key: new ValueKey(_counter),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: SafeArea(
            bottom: false,
            child: GestureDetector(
              // onPanUpdate: (details) {
              //   // Swiping in right direction.
              //   print("onswipe ${details.delta.dx}");
              //   if (details.delta.dx > 0) {
              //     OverlaySupportEntry.of(context)?.dismiss();
              //   }

              //   // Swiping in left direction.
              //   if (details.delta.dx < 0) {
              //     OverlaySupportEntry.of(context)?.dismiss();
              //   }
              // },
              onVerticalDragUpdate: (details) {
                int sensitivity = 8;
                if (details.delta.dy > sensitivity) {
                  OverlaySupportEntry.of(context)?.dismiss();
                  Navigator.pushNamed(context, target);
                  // Down Swipe
                } else if (details.delta.dy < -sensitivity) {
                  OverlaySupportEntry.of(context)?.dismiss();
                  // Up Swipe
                }
              },
              onTap: target != null
                  ? () {
                      Navigator.pushNamed(context, target);
                      OverlaySupportEntry.of(context)?.dismiss();
                    }
                  : null,
              child: Container(
                padding: const EdgeInsets.all(Constants.spacing2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      // onPanUpdate: (details) {
                      //   // Swiping in right direction.
                      //   print("onswipe ${details.delta.dx}");
                      //   if (details.delta.dx > 20) {
                      //     OverlaySupportEntry.of(context)?.dismiss();
                      //   }

                      //   // Swiping in left direction.
                      //   if (details.delta.dx < 0) {
                      //     Navigator.pushNamed(context, target);
                      //     OverlaySupportEntry.of(context)?.dismiss();
                      //   }
                      // },
                      onTap: target != null
                          ? () {
                              Navigator.pushNamed(context, target);
                              OverlaySupportEntry.of(context)?.dismiss();
                            }
                          : null,
                      child: img,
                    ),
                    const SizedBox(width: Constants.spacing2),
                    Expanded(
                        child: GestureDetector(
                      onTap: target != null
                          ? () {
                              Navigator.pushNamed(context, target);
                              OverlaySupportEntry.of(context)?.dismiss();
                            }
                          : null,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: const TextStyle(
                                    fontFamily: Constants.primaryFontBold)),
                            const SizedBox(height: Constants.spacing1),
                            Text(
                              description,
                              style: const TextStyle(
                                  fontSize: Constants.fontSizeSm),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            )
                          ]),
                    )),
                    const SizedBox(width: Constants.spacing2),
                    GestureDetector(
                      onTap: () {
                        OverlaySupportEntry.of(context)?.dismiss();
                      },
                      child: SvgPicture.asset('assets/svg/close.svg',
                          width: 21, height: 21, color: Constants.gray),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }, duration: const Duration(milliseconds: 4000));
  }

  static void showBottomSheetExpandable(
      {required context,
      iconHeader,
      textHeader,
      iconClose,
      statefulbuilder,
      required maxChildSize,
      required minChildSize,
      required initialChildSize}) {
    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return DraggableScrollableSheet(
          snapSizes: [minChildSize + 0.001],
          maxChildSize: maxChildSize,
          minChildSize: minChildSize,
          snap: true,
          initialChildSize: initialChildSize,
          expand: false,
          builder: (context, scrollController) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      controller: scrollController,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(
                            0, 0, Constants.spacing1, 0),
                        color: Constants.white,
                        child: Column(
                          children: [
                            iconClose == true
                                ? Container()
                                : Row(
                                    mainAxisAlignment: iconClose == true
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.center,
                                    crossAxisAlignment: iconClose == true
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: Constants.spacing3,
                                            right: Constants.spacing4,
                                            top: Constants.spacing2,
                                            bottom: 0),
                                        color: Constants.white,
                                        child: Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              iconClose == true
                                                  ? Navigator.pop(context)
                                                  : null;
                                            },
                                            child: Icon(
                                              iconHeader ??
                                                  Icons.horizontal_rule,
                                              size:
                                                  iconClose == true ? 25 : 30,
                                              color: iconClose == true
                                                  ? Constants
                                                      .primaryColor.shade300
                                                  : Constants.gray.shade300,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            Row(
                              mainAxisAlignment: iconClose == true
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        Constants.spacing4,
                                        Constants.spacing4,
                                        0,
                                        Constants.spacing4),
                                    child: Text(
                                      textHeader ?? "Filter",
                                      style: const TextStyle(
                                          fontSize: Constants.fontSizeLg,
                                          fontFamily:
                                              Constants.primaryFontBold),
                                    )),
                                iconClose == true
                                    ? Container(
                                        padding: const EdgeInsets.only(
                                            left: Constants.spacing3,
                                            right: Constants.spacing2,
                                            top: Constants.spacing2,
                                            bottom: Constants.spacing4),
                                        color: Constants.white,
                                        child: InkWell(
                                          onTap: () {
                                            iconClose == true
                                                ? Navigator.pop(context)
                                                : null;
                                          },
                                          child: Icon(
                                            iconHeader ??
                                                Icons.horizontal_rule,
                                            size: iconClose == true ? 25 : 30,
                                            color: iconClose == true
                                                ? Constants
                                                    .primaryColor.shade300
                                                : Constants.gray.shade300,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height *
                            (maxChildSize - 0.06),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(
                                  Constants.spacing1,
                                  0,
                                  Constants.spacing1,
                                  Constants.spacing4),
                              child: statefulbuilder ?? Container()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void showBottomSheetExpandableCircular(
      {required context,

      //icon : Icons.star
      iconHeader,
      textHeader,
      statefulbuilder,
      doubleback,
      singleback,
      required maxChildSize,
      required minChildSize,
      required initialChildSize}) {
    showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      context: context,
      builder: (builder) {
        return GestureDetector(
          onVerticalDragDown: (_) {},
          child: Container(
            decoration: const BoxDecoration(
              color: Constants.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Constants.spacing8),
                  topRight: Radius.circular(Constants.spacing8)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Container(
                      decoration: const BoxDecoration(
                        // color: Constants.primaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Constants.spacing3),
                            topRight: Radius.circular(Constants.spacing3)),
                      ),

                      padding: const EdgeInsets.fromLTRB(
                          Constants.spacing1, 0, Constants.spacing1, 0),
                      //
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          doubleback == true
                              ? Container()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Icon(
                                        iconHeader ?? Icons.horizontal_rule,
                                        size: 30,
                                        color: Constants.gray.shade300,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height *
                          (maxChildSize - 0.06),
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(
                                Constants.spacing1,
                                0,
                                Constants.spacing1,
                                Constants.spacing4),
                            child: statefulbuilder ?? Container()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<String?> showTextSelector(BuildContext context, items,
      {title, height, selected, emptyText = 'Tidak ada pilihan', formatters}) {
    height ??= MediaQuery.of(context).size.height * .6;

    final formatter = intl.NumberFormat.decimalPattern();

    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (BuildContext mContext) {
          return StatefulBuilder(builder: (builder, setParentState) {
            return SafeArea(
              child: Container(
                  padding: MediaQuery.of(mContext).viewInsets,
                  height: height,
                  child: Column(children: [
                    Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                                  padding:
                                      const EdgeInsets.all(Constants.spacing4),
                                  child: Text(title ?? 'Untitled',
                                      style: const TextStyle(
                                          fontSize: Constants.fontSizeLg,
                                          fontFamily:
                                              Constants.primaryFontBold)))),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(mContext);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.all(Constants.spacing4),
                                child: SvgPicture.asset(
                                  'assets/svg/close.svg',
                                  width: 24,
                                  height: 24,
                                  color: Constants.gray,
                                  alignment: Alignment.center,
                                ),
                              ))
                        ],
                      ),
                    ),
                    Expanded(
                        child: items.length > 0
                            ? ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    vertical: Constants.spacing2),
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.pop(
                                          mContext,
                                          formatters == "number"
                                              ? "Rp. ${formatter.format(items[index] ?? 0)}"
                                              : items[index]);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(bottom: BorderSide(color: Constants.gray.shade200))),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Constants.spacing4,
                                          vertical: Constants.spacing4),
                                      child: formatters != "number"
                                          ? Text("${items[index]}",
                                              style: const TextStyle(fontSize:Constants.fontSizeMd))
                                          : Text("Rp. ${formatter.format(items[index] ?? 0)}"),
                                    ),
                                  );
                                })
                            : Center(
                                child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 200),
                                child: Text(emptyText,
                                    textAlign: TextAlign.center,
                                    style:
                                        const TextStyle(color: Constants.gray)),
                              )))
                  ])),
            );
          });
        });
  }

  static Future<String?> showTextSelectorDynamic(BuildContext context, items,
      {title, height, selected, emptyText = 'Tidak ada pilihan', formatters}) {
    height ??= MediaQuery.of(context).size.height * .6;

    final formatter = intl.NumberFormat.decimalPattern();

    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (BuildContext mContext) {
          return StatefulBuilder(builder: (builder, setParentState) {
            return SafeArea(
              child: Container(
                  padding: MediaQuery.of(mContext).viewInsets,
                  height: height,
                  child: Column(children: [
                    Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                                  padding:
                                      const EdgeInsets.all(Constants.spacing4),
                                  child: Text(title ?? 'Untitled',
                                      style: const TextStyle(
                                          fontSize: Constants.fontSizeLg,
                                          fontFamily:
                                              Constants.primaryFontBold)))),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(mContext);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.all(Constants.spacing4),
                                child: SvgPicture.asset(
                                  'assets/svg/close.svg',
                                  width: 24,
                                  height: 24,
                                  color: Constants.gray,
                                  alignment: Alignment.center,
                                ),
                              ))
                        ],
                      ),
                    ),
                    Expanded(
                        child: items.length > 0
                            ? ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    vertical: Constants.spacing2),
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.pop(
                                          mContext,
                                          formatters == "number"
                                              ? "${formatter.format(items[index]['term'] ?? 0)}x"
                                              : items[index]);
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Constants
                                                              .gray.shade200))),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal:
                                                          Constants.spacing4,
                                                      vertical:
                                                          Constants.spacing4),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  formatters != "number"
                                                      ? Text(
                                                          "${items[index]['term']}x",
                                                          style: const TextStyle(
                                                              fontSize: Constants
                                                                  .fontSizeLg))
                                                      : Text(
                                                          "Rp. ${formatter.format(items[index]['term'] ?? 0)}x",
                                                          style: const TextStyle(
                                                              fontSize: Constants
                                                                  .fontSizeLg)),
                                                  formatters != "number"
                                                      ? Text(
                                                          "Angsuran/bln : Rp. ${items[index]['installment']}",
                                                          style: const TextStyle(
                                                              fontSize: Constants
                                                                  .fontSizeMd))
                                                      : Text(
                                                          "Angsuran/bln : Rp. ${formatter.format(items[index]['installment'] ?? 0)}",
                                                          style: const TextStyle(
                                                              fontSize: Constants
                                                                  .fontSizeMd)),
                                                ],
                                              ),),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                            : Center(
                                child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 200),
                                child: Text(emptyText,
                                    textAlign: TextAlign.center,
                                    style:
                                        const TextStyle(color: Constants.gray)),
                              )))
                  ])),
            );
          });
        });
  }

  static void showMonthYearSelector(BuildContext context,
      {value, min, max, onChanged}) {
    DatePicker.showPicker(context,
        showTitleActions: true,
        pickerModel: YearMonthModel(
          currentTime: value,
          maxTime: DateTime.now(),
          minTime: DateTime(1970, 1, 1),
          locale: LocaleType.id,
        ),
        locale: LocaleType.id, onConfirm: (date) {
      if (onChanged != null) {
        onChanged(date);
      }
    });
  }

  static void showOffer(
      {required String imageUrl,
      required String target,
      int delay = 0,
      int timeout = 10}) {
    if (AppNavigatorService.navigatorKey.currentContext == null || currentOffer)
      return;

    currentOffer = true;
    imageUrl == "" || imageUrl.contains("file:///") ? null :
    preloadImage(
      NetworkImage(imageUrl)).then((value) {
      Timer t = Timer(Duration(seconds: timeout), () {
        if (currentOffer) {
          currentOffer = false;
          Navigator.of(AppNavigatorService.navigatorKey.currentContext!,
                  rootNavigator: true)
              .maybePop();
        }
      });

      Future.delayed(Duration(seconds: delay), () {
        AppDialog.custom(builder: (BuildContext context) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                  padding: const EdgeInsets.all(Constants.spacing6),
                  child: GestureDetector(
                      onTap: () {
                        if (currentOffer) {
                          t.cancel();
                          currentOffer = false;
                          Navigator.of(
                              AppNavigatorService.navigatorKey.currentContext!)
                            ..pop()
                            ..pushNamed(target);
                        }
                      },
                      child: Image.network(
                        imageUrl,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return SizedBox(
                            child: Image.asset('assets/images/kliknss.png'),
                          );
                        },
                      ))),
              Positioned(
                  top: 10,
                  right: 10,
                  child: SafeArea(
                    child: GestureDetector(
                      onTap: () {
                        if (currentOffer) {
                          t.cancel();
                          currentOffer = false;
                          Navigator.of(AppNavigatorService
                                  .navigatorKey.currentContext!)
                              .pop();
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.all(Constants.spacing2),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(36))),
                          child: const Icon(Icons.close,
                              size: 36, color: Colors.white)),
                    ),
                  ))
            ],
          );
        }).then((value) {
          t.cancel();
          currentOffer = false;
        });
      });
    });
  }

  static void openGoogleMaps(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  static Future<Map?> openKelurahanSelector() async {
    if (AppNavigatorService.navigatorKey.currentContext == null) return null;

    final kelurahan = await showModalBottomSheet<dynamic>(
        context: AppNavigatorService.navigatorKey.currentContext!,
        isDismissible: true,
        isScrollControlled: true,
        builder: (BuildContext modalContext) {
          return StatefulBuilder(builder: (builder, setParentState) {
            return KelurahanSelector();
          });
        });
    return kelurahan;
  }

  static Future<Map?> openKelurahanSelectorKTP() async {
    if (AppNavigatorService.navigatorKey.currentContext == null) return null;

    final kelurahan = await showModalBottomSheet<dynamic>(
        context: AppNavigatorService.navigatorKey.currentContext!,
        isDismissible: true,
        isScrollControlled: true,
        builder: (BuildContext modalContext) {
          return StatefulBuilder(builder: (builder, setParentState) {
            return AppPage.withName('kelurahan-selectorKTP') ?? Container();
          });
        });

    return kelurahan;
  }

  static Future<Map?> openCitySelector() async {
    if (AppNavigatorService.navigatorKey.currentContext == null) return null;

    final kelurahan = await showModalBottomSheet<dynamic>(
        context: AppNavigatorService.navigatorKey.currentContext!,
        isDismissible: true,
        isScrollControlled: true,
        builder: (BuildContext modalContext) {
          return StatefulBuilder(builder: (builder, setParentState) {
            return CitySelector() ?? Container();
          });
        });

    return kelurahan;
  }

  static Future<Map?> openCitySelectoAgent() async {
    if (AppNavigatorService.navigatorKey.currentContext == null) return null;

    final kelurahan = await showModalBottomSheet<dynamic>(
        context: AppNavigatorService.navigatorKey.currentContext!,
        isDismissible: true,
        isScrollControlled: true,
        builder: (BuildContext modalContext) {
          return StatefulBuilder(builder: (builder, setParentState) {
            return CitySelectorAgent() ?? Container();
          });
        });

    return kelurahan;
  }

  static Future<Map?> openKelurahanSelectorGlobal() async {
    if (AppNavigatorService.navigatorKey.currentContext == null) return null;

    final kelurahan = await showModalBottomSheet<dynamic>(
        context: AppNavigatorService.navigatorKey.currentContext!,
        isDismissible: true,
        isScrollControlled: true,
        builder: (BuildContext modalContext) {
          return StatefulBuilder(builder: (builder, setParentState) {
            return AppPage.withName('kelurahan-selector-global') ?? Container();
          });
        });

    return kelurahan;
  }

  static void requestAppUpdate(
      {required title,
      description,
      confirmText,
      onConfirm,
      cancelText,
      onCancel}) {
    if (!currentConfirm) {
      AppDialog.custom(
              barrierDismissible: cancelText == null ? false : true,
              builder: (BuildContext context) => WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                      titlePadding: const EdgeInsets.all(Constants.spacing4),
                      insetPadding: const EdgeInsets.all(10),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      contentPadding: const EdgeInsets.fromLTRB(
                          Constants.spacing4, 0, Constants.spacing4, 0),
                      actionsPadding: const EdgeInsets.symmetric(
                          horizontal: Constants.spacing2,
                          vertical: Constants.spacing4),
                      scrollable: true,
                      title: Text(title, style: Constants.heading4),
                      content: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(description)),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            onCancel == null
                                ? Container()
                                : Button(
                                    type: ButtonType.minimal,
                                    text: cancelText,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      if (onCancel != null) onCancel();
                                      currentConfirm = false;
                                    }),
                            onCancel == null
                                ? Container()
                                : const SizedBox(
                                    width: Constants.spacing2,
                                  ),
                            Button(
                              text: confirmText,
                              onPressed: () {
                                Navigator.of(context).pop();
                                if (onConfirm != null) onConfirm();
                                currentConfirm = false;
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              dismissable: onCancel == null)
          .then((v) {
        currentConfirm = false;
      });
    }
  }

  static void pushTarget(String? target) {
    if (target == null || target.isEmpty) return;
    if (AppNavigatorService.navigatorKey.currentContext == null) return;

    if (target.contains('://')) {
      Navigator.of(AppNavigatorService.navigatorKey.currentContext!)
          .push(MaterialPageRoute(
              builder: (context) => WebviewPage(
                    link: target,
                  )));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(AppNavigatorService.navigatorKey.currentContext!)
            .pushNamed(target);
      });
    }
  }
}

class YearMonthModel extends DatePickerModel {
  YearMonthModel(
      {required DateTime currentTime,
      required DateTime maxTime,
      required DateTime minTime,
      required LocaleType locale})
      : super(
            currentTime: currentTime,
            maxTime: maxTime,
            minTime: minTime,
            locale: locale);

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}
