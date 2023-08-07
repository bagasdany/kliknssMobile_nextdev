import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kliknss77/application/helpers/notification_model.dart';

class HelperNotification {
  Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      message,
      notification) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'default_notification_channel_id', 'default_notification_channel_id',
      channelDescription: 'KlikNSS',
      icon: 'notification_icon',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      // onlyAlertOnce: false,
      enableVibration: true,
      playSound: true,
      ticker: 'ticker',

      // sound: RawResourceAndroidNotificationSound('sound_notif'),
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    Future<dynamic> onSelectNotification(payload) async {
      if (payload != null) {
        await flutterLocalNotificationsPlugin.show(
            0, notification.title, notification.body, platformChannelSpecifics,
            payload: message.data['target'] ?? "");

        // AppDialog.openUrl(message?.data['target']);
      }
    }

    const notificationChannel = 'default_notification_channel_id';
    const notificationChannelId = 'default_notification_channel_id';
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('notification_icon');
    void _createNotificationChannel() async {
      const androidNotificationChannel = AndroidNotificationChannel(
        notificationChannelId,
        notificationChannel,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidNotificationChannel);
    }

    _createNotificationChannel();
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    final NotificationAppLaunchDetails? appLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    // final initializationSettings = _getPlatformSettings();

    // flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onSelectNotification);

    dynamic _fcmToken = await messaging.getToken();

    messaging.onTokenRefresh.listen((event) {
      _fcmToken = event;
    });

    InitializationSettings _getPlatformSettings() {
      const initializationSettingsAndroid =
          AndroidInitializationSettings('notification_icon');

      return const InitializationSettings(
        android: initializationSettingsAndroid,
        // iOS: initializationSettingsIOS,
      );
    }

    void refreshBerandaViewModelTransactionList(NotificationModel payload) {
      final mapNotification = payload.notificationData;
      final notification = mapNotification?['transactionLogData'] ?? {};
    }

    Future<bool> requestIOSPermissions() async {
      final platformImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      bool permission = false;

      if (platformImplementation != null) {
        permission = (await platformImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ))!;
      }

      return permission;
    }

    await flutterLocalNotificationsPlugin.show(
        0, notification.title, notification.body, platformChannelSpecifics,
        payload: message.data['target'] ?? "");
  }
}
