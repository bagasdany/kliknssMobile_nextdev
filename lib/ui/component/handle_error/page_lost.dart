import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kliknss77/application/app/app_log.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/component/button.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
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
      // bottomNavigationBar: SafeArea(
      //   child:
      // ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/not_found.jpg"),
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
                            text: 'Back to Home',
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
