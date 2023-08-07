import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kliknss77/application/app/app_log.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/button.dart';
class MaintenancePage extends StatefulWidget {
  const MaintenancePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      AppLog().logScreenView('404 Not Found');
    });

    @override
    void setState(fn) {
      if (mounted) {
        super.setState(fn);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/maintenance_design.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    margin: const EdgeInsets.only(bottom: Constants.spacing4),
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      child: Center(
                        child: Button(
                            type: ButtonType.secondary,
                            text: 'Coba Lagi',
                            fontSize: Constants.fontSizeLg,
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/', (route) => false);
                            }),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
