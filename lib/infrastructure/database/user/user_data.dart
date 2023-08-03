import 'package:kliknss77/infrastructure/database/data_state.dart';

class UserDataState extends DataState {
  static UserDataState? _instance;

  UserDataState._internal() {
    data['type'] = 'user';
    data['data'] = {'key1': 'User Data 1', 'key2': 'User Data 2'};
  }

  factory UserDataState() {
    _instance ??= UserDataState._internal();
    return _instance!;
  }
}