// // Future<void> compressImage(File file) async {
// //   Image image = decodeImage(file.readAsBytesSync());
// //   image = copyResize(image, width: 1200);
// //   List<int> compressed = encodeJpg(image, quality: 80);
// //   await File(file.path).writeAsBytes(compressed);
// // }

// import 'dart:io';
// import 'dart:ui';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:image/image.dart';
// import '../../ui/component/app_dialog.dart';

// class CompressResizeImageComponent {
//   Future<dynamic> compressImage(File file) {
//     Image? image = decodeImage(file.readAsBytesSync());
//     image = copyResize(image!, width: 1200);
//     List<int> compressed = encodeJpg(image, quality: 80);
//     return File(file.path).writeAsBytes(compressed);
//   }

//   Future<void> initialize(
//       FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
//       message,
//       notification) async {
//     Future<dynamic> onSelectNotification(payload) async {
//       if (payload != null) {
//         AppDialog.openUrl(message?.data['target']);
//       }
//     }

//     var initializationSettingsAndroid =
//         const AndroidInitializationSettings('app_icon');
//     var initializationSettingsIOS = const IOSInitializationSettings();
//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: onSelectNotification);
//     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//       '01',
//       'KlikNSS Notif App',
//       channelDescription: 'Notifikasi reminder pembayaran & jatuh tempo',
//       importance: Importance.max,
//       priority: Priority.max,
//       showWhen: false,
//       // onlyAlertOnce: false,
//       enableVibration: false,
//       playSound: false,
//       // sound: RawResourceAndroidNotificationSound('sound_notif'),
//     );
//     var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
//     var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.cancelAll();

//     Future.delayed(const Duration(seconds: 4), () async {
//       Future.delayed(const Duration(seconds: 2), () async {
//         await flutterLocalNotificationsPlugin.cancelAll();
//       });
//       Future.delayed(const Duration(seconds: 2), () async {
//         await flutterLocalNotificationsPlugin.show(
//             0, notification.title, notification.body, platformChannelSpecifics,
//             payload: message.data['target'] ?? "");

//         AppDialog.snackBar(text: "${message.data['target']}");
//       });
//     });
//   }
// }
