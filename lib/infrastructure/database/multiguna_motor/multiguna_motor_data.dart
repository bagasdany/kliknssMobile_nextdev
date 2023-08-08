import 'package:kliknss77/infrastructure/database/data_state.dart';

class MultigunaMotorData extends DataState {
  static MultigunaMotorData? _instance;

  MultigunaMotorData._internal() {
    data['type'] = 'multiguna-motor';
    data['data'] = {};
  }

  factory MultigunaMotorData() {
    _instance ??= MultigunaMotorData._internal();
    return _instance!;
  }
}