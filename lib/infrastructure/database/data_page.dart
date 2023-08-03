import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kliknss77/application/builders/master_builder.dart';
class AppPage {

    // Buat StreamController dan Stream untuk mengelola data yang berubah.
  static final StreamController<Map<String, dynamic>> _pageDataController = StreamController<Map<String, dynamic>>();
  static Stream<Map<String, dynamic>> get onPageDataChanged => _pageDataController.stream;

  static Map<String, Widget> pages = {};

  static void dispose() {
    _pageDataController.close();
  }

  static Widget? withName(name) {
    if (!pages.containsKey(name)) {
      switch (name) {
      case 'home':
          pages[name] = MasterBuilder();
      case 'lego':
        pages[name] = MasterBuilder();
      case 'multiguna-motor':
        pages[name] = MasterBuilder(url: "multiguna-motor",);
      
      case 'motor':
        pages[name] = MasterBuilder(url: "motor",);
      
      }
      
    }

    return pages[name];
  }

  static void remove(name) {
    if (name == "m2w") {
      pages.remove("m2w");
      pages.remove("m2w-motor");
    } else if (name == "m4w") {
      pages.remove("m4w");
      pages.remove("m4w-mobil");
    } else if (name == "booking-servis") {
      pages.remove("booking-servis");
      pages.remove("booking-servis-motor");
      pages.remove("booking-servis-schedule");
    } else if (pages.containsKey(name)) {
      pages.remove(name);
      print("remove home");
    }
  }
    static void updatePageData(String name, Map<String, dynamic> newData) {
    // Ketika data di Page berubah, kirimkan data baru melalui StreamController.
    _pageDataController.add(newData);
  }
}
