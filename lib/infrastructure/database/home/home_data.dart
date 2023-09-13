import 'package:kliknss77/infrastructure/database/data_state.dart';

class HomeDataState extends DataState {
  static HomeDataState? _instance;
  String? url;
  dynamic voucher;
  
  
  HomeDataState._internal() {
    data['type'] = null;
    data['data'] =null;
  }

  factory HomeDataState() {
    _instance ??= HomeDataState._internal();
    return _instance!;
  }
}