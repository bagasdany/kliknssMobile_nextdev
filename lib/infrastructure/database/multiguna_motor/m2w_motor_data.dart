import 'package:kliknss77/infrastructure/database/data_state.dart';

class M2WMotorData extends DataState {
  static M2WMotorData? _instance;

  M2WMotorData._internal() {
    data['page'] = {};
    data['brands'] = [];
    data['serieses'] = [];
    data['types'] = [];
    data['years'] = [];
  }

  factory M2WMotorData() {
    _instance ??= M2WMotorData._internal();
    return _instance!;
  }
}