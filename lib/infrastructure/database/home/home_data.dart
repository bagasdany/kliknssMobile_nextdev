import 'package:kliknss77/infrastructure/database/data_state.dart';

class HomeDataState extends DataState {
  static HomeDataState? _instance;
  
  HomeDataState._internal() {
    data['type'] = 'home';
    data['data'] = {'key1': 'Home Data 1', 'key2': 'Home Data 2'};
  }

  factory HomeDataState() {
    _instance ??= HomeDataState._internal();
    return _instance!;
  }
}