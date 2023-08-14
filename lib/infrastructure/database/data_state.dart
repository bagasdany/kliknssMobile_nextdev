import 'package:flutter/material.dart';

class DataState {
  Map<dynamic, dynamic> data = {};
  List list = [''];
  Widget? widgets = Container();

  Map<dynamic, dynamic> getData() {
    return data;
  }
  Map<dynamic, dynamic> getDataWidgets() {
    return {
      'data': data,
      'widgets': widgets,
    };
  }
  dynamic getList() {
    return list;
  }

  void updateData(Map<dynamic, dynamic> newData) {
    data = newData;
  }
  void update(Map<dynamic, dynamic> newData,Widget? newWidget) {
    data = newData;
    widgets = newWidget;
  }
    void addData(Map<dynamic, dynamic> addData) {
    data.addEntries(addData.entries);
  }
}