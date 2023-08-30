
import 'dart:async';
import 'package:kliknss77/application/models/vouchers_models.dart';
import 'package:kliknss77/infrastructure/database/data_state.dart';

class MotorAgentData extends DataState {
  static MotorAgentData? _instance;
  Voucher? voucher;
  // Buat StreamController
  final StreamController<Map<dynamic, dynamic>> dataStreamController = StreamController<Map<dynamic, dynamic>>.broadcast();

  // Buat getter untuk stream
  Stream<Map<dynamic, dynamic>>? get dataStream => dataStreamController.stream;
  
  MotorAgentData._internal() {
    data['type'] = 'agent-motor';
    data['data'] = {};
    data['voucher'] = Voucher();
    widgets = null ;
  }

  factory MotorAgentData() {
    _instance ??= MotorAgentData._internal();
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
