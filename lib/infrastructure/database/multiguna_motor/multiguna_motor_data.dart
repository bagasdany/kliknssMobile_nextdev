import 'package:kliknss77/infrastructure/database/data_state.dart';

class MultigunaMotorData extends DataState {
  static MultigunaMotorData? _instance;

  MultigunaMotorData._internal() {
    data['type'] = 'multiguna-motor';
    data['data'] = {'key1': 'multiguna-motor Data 1', 'key2': 'multiguna-motor Data 2'};
  }

  factory MultigunaMotorData() {
    _instance ??= MultigunaMotorData._internal();
    return _instance!;
  }
}