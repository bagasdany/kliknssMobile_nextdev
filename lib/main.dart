// import 'package:flutter/material.dart';
// import 'package:kliknss77/application/startup/kliknss_app.dart';

// void main() {
//   runApp(const NssApp());
// }
import 'dart:async';
import 'dart:io';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:kliknss77/application/app/app_log.dart';
import 'package:kliknss77/application/helpers/my_http_overrrides.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/firebase_options.dart';
import 'package:kliknss77/flavors.dart';
import 'package:kliknss77/infrastructure/apis/notification_api.dart';
import 'package:kliknss77/infrastructure/database/shared_prefs.dart';
import 'package:kliknss77/ui/component/app_dialog.dart';
import 'package:kliknss77/ui/component/handle_error/network_error.dart';

import 'application/startup/kliknss_app.dart';
import 'ui/component/handle_error/maintenance_page.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await setupFlutterNotifications();

  showFlutterNotification(message);

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('notification_icon');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    "default_notification_channel_id",
    "default_notification_channel_id",
    icon: 'notification_icon',
    color: Constants.primaryColor,
  );
  // const iOSPlatformChannelSpecifics = IOSNotificationDetails();
  const platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    // iOS: iOSPlatformChannelSpecifics,
  );
  Future<dynamic> onSelectNotification(payload) async {
    if (payload != null) {
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['target'] ?? "");
    }
  }

  await FlutterLocalNotificationsPlugin().show(
    message.notification.hashCode,
    message.notification?.title,
    message.notification?.body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
          'default_notification_channel_id', 'default_notification_channel_id',
          priority: Priority.high,
          importance: Importance.high,
          icon: "notification_icon"),
    ),
  );
}

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'default_notification_channel_id', // id
    'default_notification_channel_id', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      // notification.i
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'notification_icon',
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main({
  bool firstInstall = false,
  Function? callback,
}){
  
  
  int state = 0;
  runZonedGuarded<Future<void>>(() async {
    F.appFlavor =Flavor.dev;

    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      print(details);
      print(details.context);
      print(details.silent);
      print(details.stack);

      print(details.informationCollector);
      
      AppLog().reportError(details.exceptionAsString(), details.stack.toString());
      
      //FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };

    await FlutterLogs.initLogs(
      logLevelsEnabled: [
        LogLevel.INFO,
        LogLevel.WARNING,
        LogLevel.ERROR,
        LogLevel.SEVERE,
      ],
      timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
      directoryStructure: DirectoryStructure.FOR_DATE,
      logTypesEnabled: ['device', 'network', 'errors', 'notification'],
      logFileExtension: LogFileExtension.TXT,
      logsWriteDirectoryName: 'MyLogs',
      logsExportDirectoryName: 'MyLogs/Exported',
      debugFileOperations: true,
      isDebuggable: true,
    );

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent, // Android
        statusBarIconBrightness: Brightness.dark, // Android
        statusBarBrightness: Brightness.light, // iOS
      ),
    );

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    await SharedPrefs().init();
    
    if (firstInstall) {
      await SharedPrefs().remove("opened");
      await SharedPrefs().remove("discovery");
    }


    // setupLocator();

    HttpOverrides.global = MyHttpOverrides();

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();

    const notificationChannel = 'default_notification_channel_id';
    const notificationChannelId = '1234';

    var initializationSettingsAndroid =const AndroidInitializationSettings('notification_icon');

    void createNotificationChannel() async {const androidNotificationChannel = AndroidNotificationChannel(notificationChannelId,notificationChannel);

      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation< AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidNotificationChannel);
    }

    createNotificationChannel();var initializationSettings =InitializationSettings(android: initializationSettingsAndroid);

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      await setupFlutterNotifications();
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        AppDialog.showNotification(notification.title,
            description: notification.body,
            target: message.data['target'] ?? "",
            imageUrl: android.imageUrl);
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      Future.delayed(const Duration(seconds: 4), () {
        AppDialog.openUrl(message?.data['target']);
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['target'] != null) {
        AppDialog.openUrl(message.data['target']);
      }
    });
    await (NotificationApi()).subscribe();
 

    runApp(const NssApp());

    callback != null ? callback() : null;
    

    
    
  }, (dynamic error, StackTrace stack) {
    print("error global diatas $error");
    void opendialog() {
      AppDialog.alert(
          onPress: () {
            state = 0;
          },
          title: "Koneksi internetmu terganggu!",
          description:
              "Pastikan internetmu lancar dengan cek ulang paket data, Wifi, atau jaringan di tempatmu.");
    }

    try {
      print("error global $error");
      if (error.toString().contains("type")) {
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.message.contains("SocketException: Failed")) {
          if (state == 0) {
            state = -1;
            opendialog();
          }
          throw "No Internet";
        } else {}
      }
    } on NoSuchMethodError catch (e) {
    } on FormatException catch (e) {
    } on DioException catch (e) {
      e.message == "Connection reset by peer" ? MaintenancePage() : Container();
      e.message == "No Internet"
          ? NetworkErrorPage(
              onSuccess: () {
                AppDialog.openUrlRemoveUntilLogin(null);
              },
            )
          : Container();
    }

    AppLog().reportError(error.toString(), stack.toString());
  });
}
