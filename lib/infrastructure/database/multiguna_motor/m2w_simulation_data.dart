import 'package:kliknss77/infrastructure/database/data_state.dart';

class M2WSimulationData extends DataState {
  static M2WSimulationData? _instance;

  M2WSimulationData._internal() {
    data = {};
  }

  factory M2WSimulationData() {
    _instance ??= M2WSimulationData._internal();
    return _instance!;
  }
}