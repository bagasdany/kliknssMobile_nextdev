
import 'package:kliknss77/infrastructure/database/agent/m2w/m2w_agent_data.dart';
import 'package:kliknss77/infrastructure/database/agent/m2w/m2w_agent_select_motor_data.dart';
import 'package:kliknss77/infrastructure/database/agent/motor/hmc_agent_data.dart';
import 'package:kliknss77/infrastructure/database/data_state.dart';
import 'package:kliknss77/infrastructure/database/home/home_data.dart';
import 'package:kliknss77/infrastructure/database/motor/motor_data.dart';
import 'package:kliknss77/infrastructure/database/multiguna_motor/m2w_motor_data.dart';
import 'package:kliknss77/infrastructure/database/multiguna_motor/m2w_simulation_data.dart';
import 'package:kliknss77/infrastructure/database/multiguna_motor/multiguna_motor_data.dart';
import 'package:kliknss77/infrastructure/database/sparepart/sparepart_data.dart';
import 'package:kliknss77/infrastructure/database/user/user_data.dart';
import 'package:kliknss77/ui/views/agent/m2w/agent_m2w_select_motor.dart';


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
        return MultigunaMotorData();
      case 'motor':
        return MotorData();
      case 'm2w-motor':
        return M2WMotorData();
      
      //agent
      case 'motor-agent':
        return MotorAgentData();
      case 'm2w-agent':
        return M2WAgentData();
      case 'm2w-selectmotor-agent':
      return M2WAgentMotorData();
      default:
        return HomeDataState();
    }
  }
}