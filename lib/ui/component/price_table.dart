import 'package:flutter/material.dart';

import 'package:intl/intl.dart' as intl;
import 'package:kliknss77/application/style/constants.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class PriceTable extends StatefulWidget {
  final List<dynamic>? prices;
  final Function(Map)? onTableClick;
  final Function(Map)? onTableLongPress;

  PriceTable({this.prices, this.onTableClick, this.onTableLongPress});

  @override
  State<PriceTable> createState() => _PriceTableState();
}

class _PriceTableState extends State<PriceTable> {
  int? selectedColumnIndex;
  int? selectedRowIndex;
  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat.decimalPattern();
    // Filter prices to exclude rows with term = 0
    List<dynamic>? filteredPrices =
        widget.prices?.where((price) => price['term'] != 0).toList();

    // Group prices by term
    Map<int, List<Map<String, dynamic>>> groupedPrices = {};
    filteredPrices?.forEach((price) {
      int term = price['term'];
      if (groupedPrices.containsKey(term)) {
        groupedPrices[term]!.add(price);
      } else {
        groupedPrices[term] = [price];
      }
    });
    // String input = "721,";
    RegExp regExp = RegExp(r',\$');
// print(output);

    // Extract unique price values
    List pricesList =
        filteredPrices!.map((price) => price['price']).toSet().toList();

    // Build table rows
    List<List<Widget>> rows = pricesList.map((price) {
      List<Widget> cells = [
        Container(
          height: 50.0,
          width: 50,
          color: Colors.grey[300],
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(price.toString()),
        ),
      ];

      groupedPrices.forEach((term, termPrices) {
        // Find installment for the current term and price
        Map<String, dynamic>? matchingPrice = termPrices.firstWhere(
          (termPrice) => termPrice['price'] == price,
          orElse: () => {'installment': null},
        );

        cells.add(
          InkWell(
            onDoubleTap: () {
              if (matchingPrice['installment'] != null) {
                if (widget.onTableLongPress != null) {
                  widget.onTableLongPress!(matchingPrice);
                }
              }
            },
            onLongPress: () {
              if (matchingPrice['installment'] != null) {
                if (widget.onTableLongPress != null) {
                  widget.onTableLongPress!(matchingPrice);
                }
              }
            },
            onTap: () {
              if (matchingPrice['installment'] != null) {
                setState(() {
                  selectedColumnIndex =
                      groupedPrices.keys.toList().indexOf(term);
                  selectedRowIndex = pricesList.indexOf(price);
                });
                if (widget.onTableClick != null) {
                  widget.onTableClick!(matchingPrice);
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Constants.white,
                border: Border(
                  left: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.0,
                  ),
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.0,
                  ),
                ),
              ),
              height: 50.0,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                color: Constants.white,
                child: Text(
// String output = input.replaceAll(regExp, "");
                  matchingPrice['installment'] != null
                      ? ("${formatter.format(matchingPrice['installment']).substring(0, (matchingPrice['installment'].toString()).length - 2)}")
                          .replaceAll(regExp, "")
                      // originalString.substring(0, originalString.length - 3)
                      // "${formatter.format(matchingPrice['installment']).substring(0, 5)}"

                      // matchingPrice['installment'].toString()
                      : '',
                ),
              ),
            ),
          ),
        );
      });

      return cells;
    }).toList();
    return Container(
      height: 400,
      child: StickyHeadersTable(
        columnsLength: groupedPrices.length,
        rowsLength: rows.length,
        columnsTitleBuilder: (int index) {
          int term = groupedPrices.keys.elementAt(index);
          return Container(
            height: 50.0,
            decoration: BoxDecoration(
              color: Constants.donker.shade100,
              border: Border(
                left: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1.0,
                ),
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1.0,
                ),
              ),
            ),
            // color: Colors.grey[300],
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("${term}x"),
          );
        },
        rowsTitleBuilder: (int index) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 50.0,
                // color: Colors.grey[300],
                decoration: BoxDecoration(
                  color: Constants.donker.shade50,
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1.0,
                    ),
                    bottom: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1.0,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  // pricesList[index].toString()

                  "DP ${formatter.format(pricesList[index]).substring(0, (pricesList[index].toString()).length - 2)}",
                  textAlign: TextAlign.center,
                  // "DP ${formatter.format(pricesList[index]).substring(0, 5)}"
                ),
              ),
            ),
          ],
        ),
        // contentCellBuilder: (int column, int row) => rows[row][column + 1],
        contentCellBuilder: (int column, int row) {
          Widget cell = rows[row][column + 1];

          // Check if the current cell is the selected cell
          if (selectedColumnIndex == column && selectedRowIndex == row) {
            cell = Container(
              color: Constants.lime, // Set the desired background color
              child: cell,
            );
          } else {}

          return cell;
        },
        legendCell: Text('Uang Muka'),
      ),
    );
  }
}
