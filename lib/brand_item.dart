import 'package:flutter/material.dart';
import 'package:kliknss77/application/style/constants.dart';
/// Class Component a Item Discount Card
class brandItem extends StatelessWidget {
  dynamic brand;
  brandItem(this.brand, {Key? key}) : super(key: key);
// KategoriSparepart
  @override
  Widget build(BuildContext context) {
    const sm = "/";
    const koma = ";";
    final cek = brand['target'] ?? "/";
    final awalIndex = cek!.indexOf(sm);
    final akhirIndex = cek.indexOf(koma, awalIndex + sm.length);

    final target =
        cek == "/" ? "" : cek.substring(awalIndex + sm.length, akhirIndex);
    return brand == null
        ? Container()
        : Container(
            margin: const EdgeInsets.only(right: Constants.spacing4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        String query = "";
                        query = "?id=$target";
                        Navigator.of(context).pushNamed('$target' + query);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Constants.gray.shade300,
                              width: 1,
                            ),
                            color: Constants.white),
                        child:
                            Text(brand['name'] ?? '', style: const TextStyle()),
                      ),
                    ),
                  ]),
            ),
          );
  }
}
