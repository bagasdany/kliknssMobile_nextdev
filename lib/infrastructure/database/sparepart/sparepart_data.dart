import 'package:kliknss77/infrastructure/database/data_state.dart';

class SparepartDataState extends DataState {
  static SparepartDataState? _instance;

  SparepartDataState._internal() {
    data['type'] = 'sparepart';
    data['data'] = {'key1': 'Sparepart Data 1', 'key2': 'Sparepart Data 2'};
  }

  factory SparepartDataState() {
    _instance ??= SparepartDataState._internal();
    return _instance!;
  }
}