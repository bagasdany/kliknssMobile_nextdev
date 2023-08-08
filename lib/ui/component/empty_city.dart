import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/location_selector.dart';


class EmptyCityId extends StatefulWidget {
  final Function()? onLocationChange;
  const EmptyCityId({
    Key? key,
    this.onLocationChange,
  }) : super(key: key);

  @override
  State<EmptyCityId> createState() => _EmptyCityIdState();
}

class _EmptyCityIdState extends State<EmptyCityId> {
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
              children: const [
                Expanded(
                  child: Text(
                    "Kota Belum Dipilih",
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
              children: const [
                Expanded(
                    child: Text(
                  "Masukkan kota anda untuk melihat simulasi kredit",
                  style: TextStyle(
                      fontSize: Constants.fontSizeMd, color: Constants.gray),
                  textAlign: TextAlign.center,
                ))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: Constants.spacing2),
            child: Row(
              children: [
                Container(
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            LocationSelector().locationSelector(
                                context: context,
                                onLocationChange: () async {
                                  if (widget.onLocationChange != null) {
                                    await widget.onLocationChange!();
                                  }
                                });
                          },
                          child: const Text(
                            "Klik Disini,",
                            style: TextStyle(
                                fontSize: Constants.fontSizeSm,
                                fontFamily: Constants.primaryFontBold,
                                color: Constants.primaryColor),
                          ),
                        ),
                        const Text(
                          " untuk memilih kota",
                          style: TextStyle(
                              fontSize: Constants.fontSizeSm,
                              color: Constants.gray),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
