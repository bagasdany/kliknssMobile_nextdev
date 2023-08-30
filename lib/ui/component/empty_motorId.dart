import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';

class EmptyMotorId extends StatefulWidget {
  final Function()? onLocationChange;
  dynamic title, description;
  EmptyMotorId(
      {Key? key, this.title, this.description, this.onLocationChange, text})
      : super(key: key);

  @override
  State<EmptyMotorId> createState() => _EmptyMotorIdState();
}

class _EmptyMotorIdState extends State<EmptyMotorId> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.white,
      padding: const EdgeInsets.all(Constants.spacing4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title ?? "",

                    // "Series Motor Belum dipilih",
                    style: TextStyle(
                        fontSize: Constants.fontSizeLg,
                        fontFamily: Constants.primaryFontBold,
                        color: Constants.gray),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: Constants.spacing1),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  widget.description ?? "",
                  // "Silahkan Pilih Kota dan Motor dulu untuk Simulasi",
                  style: TextStyle(
                      fontSize: Constants.fontSizeMd, color: Constants.gray),
                  textAlign: TextAlign.center,
                ))
              ],
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(top: Constants.spacing2),
          //   child: Row(
          //     children: [
          //       Container(
          //         child: Expanded(
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               InkWell(
          //                 onTap: () {
          //                   LocationSelector().locationSelector(
          //                       context: context,
          //                       onLocationChange: () async {
          //                         await widget.onLocationChange!();
          //                       });
          //                 },
          //                 child: const Text(
          //                   "Klik Disini,",
          //                   style: TextStyle(
          //                       fontSize: Constants.fontSizeSm,
          //                       fontFamily: Constants.primaryFontBold,
          //                       color: Constants.primaryColor),
          //                 ),
          //               ),
          //               const Text(
          //                 " untuk memilih kota",
          //                 style: TextStyle(
          //                     fontSize: Constants.fontSizeSm,
          //                     color: Constants.gray),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
