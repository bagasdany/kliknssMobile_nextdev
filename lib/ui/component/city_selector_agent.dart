import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/infrastructure/apis/misc_api.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs_key.dart';
import '../../infrastructure/database/shared_prefs.dart';

class CitySelectorAgent extends StatefulWidget {
  List<Map>? cities;
  final TextEditingController controller = TextEditingController();

  CitySelectorAgent({Key? key}) : super(key: key);

  @override
  State<CitySelectorAgent> createState() => _CitySelectorAgentState();
}

class _CitySelectorAgentState extends State<CitySelectorAgent> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    var cities = MiscApi().searchCityAgent(null).then((value) {
      setState(() {
        widget.cities = value;
        isLoading = false;
      });
    });
  }

  final _sharedPrefs = SharedPrefs();
  bool isLoading = false;

  Widget buildCityItems() {
    if (isLoading == true) {
      return Container(
          padding: const EdgeInsets.all(Constants.spacing6),
          child: const Text('Sedang memuat...'));
    } else if (widget.cities == null || widget.cities!.length <= 0) {
      return const Text('Kota tidak ditemukan');
    } else {
      List<Widget> items = [];
      for (var i = 0; i < widget.cities!.length; i++) {
        var city = widget.cities![i];

        items.add(InkWell(
          onTap: () {
            Navigator.of(context).pop(city);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Constants.spacing4, vertical: Constants.spacing3),
            decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border(bottom: BorderSide(color: Constants.gray.shade200))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(city['alias'], style: const TextStyle()),
                // Text(
                //     "${kelurahan['kecamatan']['alias']} - ${kelurahan['kecamatan']['city']['alias']} ${kelurahan['postalCode']}",
                //     style: const TextStyle(fontSize: Constants.fontSizeSm)),
              ],
            ),
          ),
        ));
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: Constants.spacing2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: items,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * .6;
    final cityId = _sharedPrefs.get(SharedPreferencesKeys.cityId);

    if (widget.cities == null && cityId != null) {
      setState(() {
        isLoading = true;
      });
      final cities = MiscApi().searchCityAgent(null).then((value) {
        setState(() {
          widget.cities = value;
          isLoading = false;
        });
      });
    }

    return Container(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: height,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(Constants.spacing4),
                          child: const Text('Cari Kota',
                              style: TextStyle(
                                  fontSize: Constants.fontSizeLg,
                                  fontFamily: Constants.primaryFontBold)))),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(Constants.spacing4),
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
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(Constants.spacing4, 0,
                  Constants.spacing4, Constants.spacing4),
              child: TextField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: Constants.spacing3),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Constants.gray.shade200),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(Constants.spacing3))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Constants.gray.shade200),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(Constants.spacing3))),
                      hintText: 'Ketik disini untuk mencari...',
                      suffixIcon: widget.controller.text.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  widget.controller.text = '';
                                });
                                if (cityId != null) {
                                  setState(() {
                                    // isLoading = true;
                                  });
                                  final kelurahans = MiscApi()
                                      .searchCityAgent(null)
                                      .then((value) {
                                    setState(() {
                                      widget.cities = value;
                                      // isLoading = false;
                                    });
                                  });
                                }
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.all(Constants.spacing4),
                                child: SvgPicture.asset(
                                  'assets/svg/close.svg',
                                  width: 16,
                                  height: 16,
                                  alignment: Alignment.center,
                                  color: Constants.gray,
                                ),
                              ))
                          : null),
                  onChanged: (value) {
                    if (value.length > 2) {
                      setState(() {
                        isLoading = true;
                      });
                      final cities =
                          MiscApi().searchCityAgent(null).then((value) {
                        setState(() {
                          widget.cities = value;
                          isLoading = false;
                        });
                      });
                    }
                  }),
            ),
            const SizedBox(height: Constants.spacing1),
            Expanded(child: SingleChildScrollView(child: buildCityItems()))
          ],
        ),
      ),
    );
  }
}
