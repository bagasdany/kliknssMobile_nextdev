
import 'dart:async';
import 'package:kliknss77/application/models/vouchers_models.dart';
import 'package:kliknss77/infrastructure/database/data_state.dart';

class M2WAgentData extends DataState {
  static M2WAgentData? _instance;
  Voucher? voucher;
  // Buat StreamController
  final StreamController<Map<dynamic, dynamic>> dataStreamController = StreamController<Map<dynamic, dynamic>>.broadcast();

  // Buat getter untuk stream
  Stream<Map<dynamic, dynamic>>? get dataStream => dataStreamController.stream;
  
  M2WAgentData._internal() {
    data['type'] = 'm2w-agent';
    data['data'] = {};
    data['voucher'] = Voucher();
    widgets = null ;
  }

  factory M2WAgentData() {
    _instance ??= M2WAgentData._internal();
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
