import 'package:kliknss77/application/models/vouchers_models.dart';
import 'package:kliknss77/infrastructure/database/data_state.dart';

class MultigunaMotorData extends DataState {
  static MultigunaMotorData? _instance;
  Voucher? voucher;


  MultigunaMotorData._internal() {
    data['type'] = 'multiguna-motor';
    data['data'] = {};
    data['voucher'] = Voucher();
    
  }

  factory MultigunaMotorData() {
    _instance ??= MultigunaMotorData._internal();
    return _instance!;
  }
}