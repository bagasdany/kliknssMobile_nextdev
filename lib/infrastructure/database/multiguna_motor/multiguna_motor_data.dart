
import 'dart:async';
import 'package:kliknss77/application/models/vouchers_models.dart';
import 'package:kliknss77/infrastructure/database/data_state.dart';

class MultigunaMotorData extends DataState {
  static MultigunaMotorData? _instance;
  Voucher? voucher;
  // Buat StreamController
  final StreamController<Map<dynamic, dynamic>> dataStreamController = StreamController<Map<dynamic, dynamic>>.broadcast();

  // Buat getter untuk stream
  Stream<Map<dynamic, dynamic>>? get dataStream => dataStreamController.stream;
  
  MultigunaMotorData._internal() {
    data['type'] = 'multiguna-motor';
    data['data'] = {};
    data['voucher'] = Voucher();
    widgets = null ;
  }

  factory MultigunaMotorData() {
    _instance ??= MultigunaMotorData._internal();
    return _instance!;
  }

  // Perbarui data dan stream
  @override
  void updateData(Map<dynamic, dynamic> newData) {
    data = newData;

    dataStreamController.sink.add(data);
  }

  @override
  void addData(Map<dynamic, dynamic> addData) {
    data['data'].addEntries(addData.entries);

    dataStreamController.sink.add(data);
  }

  // Tutup StreamController
  void dispose() {
    dataStreamController.close();
  }
}
