import 'package:kliknss77/infrastructure/database/data_state.dart';

class M2WAgentMotorData extends DataState {
  static M2WAgentMotorData? _instance;

  M2WAgentMotorData._internal() {
    data['page'] = {};
    data['brands'] = [];
    data['serieses'] = [];
    data['types'] = [];
    data['years'] = [];
  }

  factory M2WAgentMotorData() {
    _instance ??= M2WAgentMotorData._internal();
    return _instance!;
  }
}