import 'dart:async';

import 'package:flutter/material.dart';

class DataState {
  Map<dynamic, dynamic> data = {};
  List list = [''];
  Widget? widgets = Container();
  // Buat StreamController
  final StreamController<Map<dynamic, dynamic>> dataStreamController = StreamController<Map<dynamic, dynamic>>.broadcast();

  // Buat getter untuk stream
  Stream<Map<dynamic, dynamic>>? get dataStream => dataStreamController.stream;
  
  Map<dynamic, dynamic> getData() {
    return data;
  }
  
  dynamic getList() {
    return list;
  }

  void updateData(Map<dynamic, dynamic> newData) {

    data = newData;

    // dataStreamController.sink.add(data);
  }
    void addData(Map<dynamic, dynamic> addData) {
    data.addEntries(addData.entries);

  }
}