// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers

import 'dart:async';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:slide_countdown/slide_countdown.dart';

class CountDownTimerComponent extends StatefulWidget {
  String? startDate;
  String? endDate;
  dynamic color;
  dynamic dotColor;
  dynamic transparant;
  dynamic fontColor;
  dynamic fontDayColor;
  dynamic borderColor;
  dynamic iconSize;
  dynamic fontSize;
  dynamic types;
  dynamic icon, shouldShowDays;
  CountDownTimerComponent(
      {Key? key,
      this.startDate,
      this.endDate,
      this.fontColor,
      this.transparant,
      this.fontDayColor,
      this.iconSize,
      this.types,
      this.fontSize,
      this.borderColor,
      this.dotColor,
      this.shouldShowDays,
      this.color,
      this.icon})
      : super(key: key);

  @override
  State<CountDownTimerComponent> createState() =>
      _CountDownTimerComponentState();
}

class _CountDownTimerComponentState extends State<CountDownTimerComponent> {
  Timer? _timer;
  Duration? _duration;

  DateTime? targetDate;
  int? differenceInSeconds;

  int? differenceInDays;
  dynamic differenceInHours,
      streamDuration,
      streamDuration2,
      days,
      hours,
      minutes,
      seconds;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      DateTime now = DateTime.now();
      DateTime startdate =
          DateTime.parse(widget.startDate ?? "2023-03-03 10:27:00");

      DateTime endDate =
          DateTime.parse(widget.endDate ?? "2023-03-03 10:27:00");

      int? differenceStartDate = startdate.difference(now).inSeconds;

      int? differenceendDate = endDate.difference(now).inSeconds;

      int? differenceStartDays = startdate.difference(now).inDays;

      int? differenceendDays = endDate.difference(now).inDays;
      // differenceInSeconds = differenceStartDate.inSeconds;
      // differenceInHours = differenceStartDate.inHours;

      startdate.isBefore(now)
          ? (differenceInSeconds = differenceendDate)
          : (differenceInSeconds = differenceStartDate);
      startdate.isBefore(now)
          ? (differenceInDays = differenceendDays)
          : (differenceInDays = differenceStartDays);

      streamDuration = StreamDuration(Duration(seconds: differenceInSeconds ?? 0));
      print("streamDuration2 $streamDuration2");
    });
  }

  @override
  Widget build(BuildContext context) {
    int endTime =
        DateTime.now().millisecondsSinceEpoch + 1000 * differenceInSeconds!;
    print("endtime $endTime");

    //itemsdot
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          widget.types == "slideCountdown"
              ? SlideCountdownSeparated(
                  durationTitle: DurationTitle.id(),

                  separatorType: SeparatorType.symbol,
                  shouldShowDays: (p0) {
                    return widget.shouldShowDays ?? true;
                  },
                  // shouldShowDays: tru,
                  icon: widget.icon == null
                      ? Container()
                      : Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            differenceInDays != null ||
                                    (differenceInDays ?? 0) > 0
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Constants.spacing1),
                                    margin: const EdgeInsets.only(
                                        right: Constants.spacing1),
                                        
                                    decoration: BoxDecoration(
                   
                                    color: Constants.gray.shade200,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(Constants.spacing1))),
                                    child: Text(
                                      "${(differenceInDays?? 0) < 10 ? "0${differenceInDays}": differenceInDays }",
                                      style: const TextStyle(
                                        fontFamily: Constants.primaryFontBold,
                                      ),
                                    ),
                                  )
                                : Container(),
                            differenceInDays != null ||
                                    (differenceInDays ?? 0) > 0
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    margin: const EdgeInsets.only(
                                        right: Constants.spacing2),
                                    child:  Text(
                                      "hari",
                                      style: TextStyle(
                                        color: widget.fontDayColor ?? Constants.black,
                                          // fontFamily: Constants.primaryFontBold,
                                          fontSize: Constants.fontSizeSm),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                  width: 20,
                  height: 20,
                  textStyle: TextStyle(
                      color: widget.fontColor == "white"
                          ? Constants.black
                          : Constants.gray,
                      fontFamily: Constants.primaryFontBold),
                  decoration: BoxDecoration(
                    color: widget.transparant == true
                        ? Constants.white.withOpacity(0.9)
                        : Constants.gray.shade200,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(Constants.spacing1)),
                  ),

                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.spacing1),
                  // This duration no effect if you customize stream duration
                  // duration: const Duration(seconds: 10),
                  streamDuration: streamDuration,
                )
              : widget.types == "withDays"
                  ? CountdownTimer(
                      endTime: endTime,
                      widgetBuilder: (_, time) {
                        if (time == null) {
                          return Container();
                        }
                        return Container(
                          decoration: BoxDecoration(
                              color: widget.transparant == true
                                  ? Colors.transparent
                                  : Constants.primaryColor,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(Constants.spacing4))),
                          padding: const EdgeInsets.symmetric(
                              vertical: Constants.spacing1),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    Constants.spacing2,
                                    0,
                                    Constants.spacing1,
                                    0),
                                child: Icon(
                                  Icons.access_time,
                                  color: Constants.white,
                                  size: widget.iconSize ?? 20,
                                ),
                              ),
                              time.days == null
                                  ? Container()
                                  : Container(
                                      child: Container(
                                        margin: EdgeInsets.zero,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              time.days != null
                                                  ? "${time.days}"
                                                  : "",
                                              style: TextStyle(
                                                  color: widget.fontColor ??
                                                      Constants.white,
                                                  fontFamily:
                                                      Constants.primaryFontBold,
                                                  fontSize: widget.fontSize ??
                                                      Constants.fontSizeSm),
                                            ),
                                            Text(
                                              time.days != null
                                                  ? time.days! < 10
                                                      ? " hari,"
                                                      : " hari,"
                                                  : "",
                                              style: TextStyle(
                                                  color: widget.fontColor ??
                                                      Constants.white,
                                                  fontFamily:
                                                      Constants.primaryFontBold,
                                                  fontSize: widget.fontSize ??
                                                      Constants.fontSizeXs),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              Container(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                      time.days != null
                                          ? Constants.spacing1
                                          : 0,
                                      0,
                                      0,
                                      0),
                                  margin: EdgeInsets.zero,
                                  child: Text(
                                    time.hours != null
                                        ? time.hours! < 10
                                            ? "0${time.hours}"
                                            : "${time.hours}"
                                        : "",
                                    style: TextStyle(
                                        color:
                                            widget.fontColor ?? Constants.white,
                                        fontFamily: Constants.primaryFontBold,
                                        fontSize: widget.fontSize ??
                                            Constants.fontSizeSm),
                                  ),
                                ),
                              ),
                              Container(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  // padding: EdgeInsets.zero,
                                  margin: EdgeInsets.zero,
                                  child: Text(
                                    ':',
                                    style: TextStyle(
                                        color:
                                            widget.fontColor ?? Constants.white,
                                        fontFamily: Constants.primaryFontBold,
                                        fontSize: widget.fontSize ??
                                            Constants.fontSizeSm),
                                  ),
                                ),
                              ),
                              Container(
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  margin: EdgeInsets.zero,
                                  child: Text(
                                    time.min != null
                                        ? time.min! < 10
                                            ? "0${time.min}"
                                            : "${time.min}"
                                        : "",
                                    style: TextStyle(
                                        color:
                                            widget.fontColor ?? Constants.white,
                                        fontFamily: Constants.primaryFontBold,
                                        fontSize: widget.fontSize ??
                                            Constants.fontSizeSm),
                                  ),
                                ),
                              ),
                              Container(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  // padding: EdgeInsets.zero,
                                  margin: EdgeInsets.zero,
                                  child: Text(
                                    ':',
                                    style: TextStyle(
                                        color:
                                            widget.fontColor ?? Constants.white,
                                        fontFamily: Constants.primaryFontBold,
                                        fontSize: widget.fontSize ??
                                            Constants.fontSizeSm),
                                  ),
                                ),
                              ),
                              Container(
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 0, Constants.spacing2, 0),
                                  margin: EdgeInsets.zero,
                                  child: Text(
                                    time.sec != null
                                        ? time.sec! < 10
                                            ? "0${time.sec}"
                                            : "${time.sec}"
                                        : "",
                                    style: TextStyle(
                                        color:
                                            widget.fontColor ?? Constants.white,
                                        fontFamily: Constants.primaryFontBold,
                                        fontSize: widget.fontSize ??
                                            Constants.fontSizeSm),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : widget.types == "overHours"
                      ? CountdownTimer(
                          endTime: endTime,
                          widgetBuilder: (_, time) {
                            if (time == null) {
                              return Text(
                                '',
                                style: TextStyle(
                                    fontSize:
                                        widget.fontSize ?? Constants.fontSizeSm,
                                    color: Constants.primaryColor),
                              );
                            }
                            return Container(
                              decoration: BoxDecoration(
                                  color: widget.transparant == true
                                      ? Colors.transparent
                                      : Constants.primaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(Constants.spacing4))),
                              padding: const EdgeInsets.symmetric(
                                  vertical: Constants.spacing1),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        Constants.spacing2,
                                        0,
                                        Constants.spacing1,
                                        0),
                                    child: Icon(
                                      Icons.access_time,
                                      color: Constants.white,
                                      size: widget.iconSize ?? 20,
                                    ),
                                  ),
                                  time.days == null
                                      ? Container()
                                      : Container(
                                          child: Container(
                                            margin: EdgeInsets.zero,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  differenceInHours != null
                                                      ? differenceInHours < 10
                                                          ? "0$differenceInHours"
                                                          : "$differenceInHours"
                                                      : "",
                                                  style: TextStyle(
                                                      color: widget.fontColor ??
                                                          Constants.white,
                                                      fontFamily: Constants
                                                          .primaryFontBold,
                                                      fontSize: widget
                                                              .fontSize ??
                                                          Constants.fontSizeSm),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                  Container(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      // padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                            color: widget.fontColor ??
                                                Constants.white,
                                            fontFamily:
                                                Constants.primaryFontBold,
                                            fontSize: widget.fontSize ??
                                                Constants.fontSizeSm),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      margin: EdgeInsets.zero,
                                      child: Text(
                                        time.min != null
                                            ? time.min! < 10
                                                ? "0${time.min}"
                                                : "${time.min}"
                                            : "",
                                        style: TextStyle(
                                            color: widget.fontColor ??
                                                Constants.white,
                                            fontFamily:
                                                Constants.primaryFontBold,
                                            fontSize: widget.fontSize ??
                                                Constants.fontSizeSm),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      // padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                            color: widget.fontColor ??
                                                Constants.white,
                                            fontFamily:
                                                Constants.primaryFontBold,
                                            fontSize: widget.fontSize ??
                                                Constants.fontSizeSm),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, Constants.spacing2, 0),
                                      margin: EdgeInsets.zero,
                                      child: Text(
                                        time.sec != null
                                            ? time.sec! < 10
                                                ? "0${time.sec}"
                                                : "${time.sec}"
                                            : "",
                                        style: TextStyle(
                                            color: widget.fontColor ??
                                                Constants.white,
                                            fontFamily:
                                                Constants.primaryFontBold,
                                            fontSize: widget.fontSize ??
                                                Constants.fontSizeSm),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Container(),
        ],
      ),
    );
  }
}
