
import 'package:kliknss77/infrastructure/database/data_state.dart';
import 'package:kliknss77/infrastructure/database/home/home_data.dart';
import 'package:kliknss77/infrastructure/database/multiguna_motor/multiguna_motor_data.dart';
import 'package:kliknss77/infrastructure/database/sparepart/sparepart_data.dart';
import 'package:kliknss77/infrastructure/database/user/user_data.dart';


class DataBuilder {
  final String type;

  DataBuilder(this.type);

  DataState getDataState() {
    switch (type) {
      case '':
        return HomeDataState();
      case 'user':
        return UserDataState();
      case 'sparepart':
        return SparepartDataState();
      case 'multiguna-motor':
      print("${MultigunaMotorData().getData()}");
        return MultigunaMotorData();
      default:
        return HomeDataState();
    }
  }
}