// import 'dart:convert';
// import 'dart:developer' as developer;
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:stacked_services/stacked_services.dart';

// const notificationChannel = 'Notification channel';
// const notificationChannelId = 'Channel_id_1';
// const notificationChannelDescription = 'Notification channel description';

// class NotificationService with EKYCStatusMixin {
//   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();

//   String? _fcmToken;
//   static int _notificationId = 1;
//   bool _hasLaunched = false;
//   String? _payLoad;

//   final _sharedPrefs = SharedPrefs();
//   final _navigationService = locator<NavigationService>();
//   final _eventTrackerService = locator<EventTrackerService>();
//   final _digitalSignAPI = locator<DigitalSignAPI>();

//   NotificationService() {
//     Firebase.initializeApp();
//     _localNotifications = FlutterLocalNotificationsPlugin();
//     _firebaseMessaging = FirebaseMessaging.instance;
//   }

//   Future<void> initialize() async {
//     final NotificationAppLaunchDetails? appLaunchDetails =
//         await _localNotifications.getNotificationAppLaunchDetails();

//     final initializationSettings = _getPlatformSettings();
//     await _localNotifications.initialize(
//       initializationSettings,
//       onSelectNotification: _handleNotificationTap,
//     );

//     _createNotificationChannel();

//     _fcmToken = await _firebaseMessaging.getToken();

//     _firebaseMessaging.onTokenRefresh.listen((event) {
//       _fcmToken = event;
//     });

//     developer.log('firebaseId: $_fcmToken', name: 'FCM TOKEN FIREBASE ID');

//     _sharedPrefs.set(SharedPreferenceKeys.firebaseId, _fcmToken);

//     if (Platform.isIOS) {
//       final hasPermission = await requestIOSPermissions();

//       if (hasPermission) {
//         await _fcmInitialization();
//       }
//     } else {
//       await _fcmInitialization();
//     }

//     _hasLaunched = appLaunchDetails!.didNotificationLaunchApp;

//     if (_hasLaunched) {
//       if (appLaunchDetails.payload != null) {
//         _payLoad = appLaunchDetails.payload!;
//       }
//     }

//     return;
//   }

//   Future<bool> requestIOSPermissions() async {
//     final platformImplementation =
//         _localNotifications.resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>();

//     bool permission = false;

//     if (platformImplementation != null) {
//       permission = (await platformImplementation.requestPermissions(
//         alert: true,
//         badge: true,
//         sound: true,
//       ))!;
//     }

//     return permission;
//   }

//   Future _showAndroidNotification(notif.NotificationModel payload) async {
//     final vibrationPattern = Int64List(4);
//     vibrationPattern[0] = 0;
//     vibrationPattern[1] = 200;
//     vibrationPattern[2] = 200;
//     vibrationPattern[3] = 200;

//     final androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       _notificationId.toString(),
//       notificationChannel,
//       icon: 'app_icon',
//       color: CustomColor.primaryBlue,
//       vibrationPattern: vibrationPattern,
//       importance: Importance.max,
//       priority: Priority.max,
//       styleInformation: BigTextStyleInformation(
//         payload.notificationBody!,
//         contentTitle: payload.notificationTitle,
//       ),
//     );

//     const iOSPlatformChannelSpecifics = IOSNotificationDetails();
//     final platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics,
//     );

//     refreshBerandaViewModelTransactionList(payload);

//     if (Platform.isAndroid) {
//       await _localNotifications.show(
//         int.parse(payload.notificationId!),
//         payload.notificationTitle,
//         payload.notificationBody,
//         platformChannelSpecifics,
//         payload: payload.toString(),
//       );
//     }
//   }

//   Future _handleEkycResultNotification(NotificationModel payload) async {
//     final blockEkycNotification =
//         _sharedPrefs.get(SharedPreferenceKeys.blockEkycNotification);

//     if (blockEkycNotification == null) {
//       LocatorHelper.unregThenRegBerandaViewModel();
//       LocatorHelper.unregThenRegAkunViewModel();

//       mappingEKYCStatus(EKYCCheckModel(
//         status: payload.notificationData?['status'],
//         faceMatchScore: payload.notificationData?['faceMatchScore'],
//         sourceFrom: payload.notificationData?['sourceFrom'],
//         refId: payload.notificationData?['refId'],
//         validationError: payload.notificationData?['validationError'],
//         rejectedCount: payload.notificationData?['rejectedCount'],
//         timeRemaining: payload.notificationData?['timeRemaining'],
//         vidaStatus: payload.notificationData?['vidaStatus'],
//         msg: payload.notificationData?['msg'],
//       ));

//       await _showAndroidNotification(payload);
//     }
//   }

//   Future _handleDigiSignStatusNotification(
//     notif.NotificationModel payload,
//   ) async {
//     final isSign = payload.notificationData?['isSign'] as bool;

//     if (isSign) {
//       final sourceFrom = payload.notificationData?['sourceFrom'] as String;
//       if (sourceFrom == 'link_cif') {
//         final res = await registerAPI.convertSakuCIF();
//         res.fold(
//           (error) {
//             snackBarService.showCustomSnackBar(
//               message: error.msg!,
//               variant: SnackBarType.error,
//               duration: const Duration(seconds: 2),
//             );
//           },
//           (success) {
//             _navigationService.navigateTo(Routes.successCIFView);
//           },
//         );
//       } else {
//         _navigationService
//             .navigateTo(Routes.registrationSuccessBukaRekeningView);
//       }

//       await _showAndroidNotification(payload);
//     }
//   }

//   Future _handleDigiSignUserConfirmNotification(
//     notif.NotificationModel payload,
//   ) async {
//     _sharedPrefs.set(
//       SharedPreferenceKeys.sourceFromDigitalSignature,
//       payload.notificationData?['sourceFrom'],
//     );

//     if (payload.notificationData?['status'] == 'USER_EXISTS_VERIFIED') {
//       final res = await _digitalSignAPI.uploadDigitalSignature(
//         sourceFrom: payload.notificationData?['sourceFrom'],
//       );

//       await _showAndroidNotification(payload);

//       res.fold((l) => null, (response) async {
//         if (response.generalModel?.code != null) {
//           if (response.url != '') {
//             if (payload.notificationData?['sourceFrom'] == 'link_cif') {
//               final res = await registerAPI.convertSakuCIF();
//               res.fold(
//                 (error) {
//                   snackBarService.showCustomSnackBar(
//                     message: error.msg!,
//                     variant: SnackBarType.error,
//                     duration: const Duration(seconds: 2),
//                   );
//                 },
//                 (success) {
//                   _navigationService.navigateTo(Routes.successCIFView);
//                 },
//               );
//             } else {
//               final skorMath =
//                   _sharedPrefs.get(SharedPreferenceKeys.skorEkycMath);
//               if (skorMath > 8.5) {
//                 _navigationService.navigateTo(
//                   Routes.digitalSignView,
//                   arguments: DigitalSignViewArguments(
//                     url: response.url,
//                   ),
//                 );
//               } else if (skorMath >= 7 && skorMath <= 8.5) {
//                 _navigationService.navigateTo(
//                   Routes.eKycResultView,
//                   arguments: EKYCArguments.manualApprove(Get.context!),
//                 );
//               }
//             }
//           }
//         } else {
//           _navigationService.back();
//         }
//       });
//     }
//   }

//   Future _handleAccountLogoutNotification(
//     NotificationModel payload,
//   ) async {
//     final msg = payload.notificationData?['data']['msg'];
//     developer.log('$msg', name: 'account_logout_notification');

//     await _showAndroidNotification(payload);

//     _eventTrackerService.trackCurrentPage('bsMasukPerangkatLain');
//     await locator<BottomSheetService>().showCustomSheet(
//       variant: BottomSheetType.base,
//       imageUrl: ImageConstants.loggedIn,
//       title: 'Perangkat lain masuk ke akunmu',
//       description:
//           'Atur ulang password jika bukan kamu yang melakukannya. Akun dikeluarkan otomatis dari Raya biar makin aman.',
//       mainButtonTitle: 'Oke',
//       isScrollControlled: true,
//     );

//     _sharedPrefs.remove(SharedPreferenceKeys.trackPrevNumber);
//     _eventTrackerService.track('logout');

//     SharedPrefHelper.removeKeys();
//     LocatorHelper.unregThenRegViewModels();

//     _navigationService.clearStackAndShow(Routes.startupView);
//   }

//   Future<void> _showNotification(notif.NotificationModel payload) async {
//     switch (payload.notificationType) {
//       case 'account_register_notification':
//         await _showAndroidNotification(payload);
//         break;

//       case 'account_ekyc_result_notification':
//         await _handleEkycResultNotification(payload);
//         break;

//       case 'account_digital_signature_status_notification':
//         await _handleDigiSignStatusNotification(payload);
//         break;

//       case 'account_digisign_user_confirmation':
//         await _handleDigiSignUserConfirmNotification(payload);
//         break;

//       case 'account_logout_notification':
//         await _handleAccountLogoutNotification(payload);
//         break;

//       case 'general-notification':
//         await _showAndroidNotification(payload);
//         _handleTiketKAITransactionNotification(payload);
//         break;
//     }
//   }

//   notif.NotificationModel convertToNotification(
//     int notificationId,
//     Map<String, dynamic> message,
//   ) {
//     notif.NotificationModel notification;

//     notification = notif.NotificationModel(
//       notificationId: notificationId.toString(),
//       notificationTitle: message['title'],
//       notificationBody: message['body'],
//       notificationType: message['notification_type'],
//       notificationData: isCanBeParsingToJson(message['data'])
//           ? json.decode(message['data'])
//           : {'data': message['data']},
//     );

//     return notification;
//   }

//   bool isCanBeParsingToJson(String messageData) {
//     try {
//       json.decode(messageData) as Map<String, dynamic>;

//       return true;
//     } catch (e) {
//       developer.log(e.toString(), name: 'Gagal Parsing Notifikasi');

//       return false;
//     }
//   }

//   void _createNotificationChannel() async {
//     const androidNotificationChannel = AndroidNotificationChannel(
//       notificationChannelId,
//       notificationChannel,
//     );

//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(androidNotificationChannel);
//   }

//   InitializationSettings _getPlatformSettings() {
//     const initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');

//     const initializationSettingsIOS = IOSInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     return const InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//   }

//   Future _fcmInitialization() async {
//     try {
//       await _firebaseMessaging.setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );

//       FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//         developer.log('onMessageListen: ${message.data}');
//         developer.log('remote $message');

//         final notif.NotificationModel notification =
//             convertToNotification(_notificationId++, message.data);
//         await _showNotification(notification);
//       });

//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//         developer.log('onLaunch: $message');
//         final notif.NotificationModel notification =
//             convertToNotification(_notificationId++, message.data);
//         _hasLaunched = true;
//         _payLoad = notification.toString();
//       });
//     } catch (e) {
//       developer.log(e.toString());
//     }
//   }

//   Future _handleNotificationTap(String? payload) async {
//     if (payload != null) {
//       notif.NotificationModel.fromJson(json.decode(_payLoad.toString()));
//     }
//   }

//   Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     developer.log('Handling a background message');
//     developer.log('onResume: $message');
//   }

//   void checkForLaunchedNotifications() {
//     if (_hasLaunched && _payLoad != null) {
//       notif.NotificationModel.fromJson(json.decode(_payLoad.toString()));
//     }
//   }

//   void refreshBerandaViewModelTransactionList(notif.NotificationModel payload) {
//     _sharedPrefs.set(
//       SharedPreferenceKeys.payloadNotification,
//       jsonEncode(payload.notificationData),
//     );

//     final mapNotification = payload.notificationData;
//     final notification = mapNotification?['transactionLogData'] ?? {};
//     final trxType = notification != null ? notification['TransactionType'] : '';

//     final isTransaction = mapNotification?['abmsg'] != null ||
//         trxType == 'qris' ||
//         trxType == 'bi_fast';

//     if (_navigationService.currentRoute == Routes.mainView && isTransaction) {
//       LocatorHelper.unregThenRegBerandaViewModel();
//       _navigationService.clearStackAndShow(Routes.mainView);
//     }
//     _sharedPrefs.set(
//       SharedPreferenceKeys.notificationTitle,
//       jsonEncode(payload.notificationTitle),
//     );
//   }

//   void _handleTiketKAITransactionNotification(notif.NotificationModel payload) {
//     if (_navigationService.currentRoute == Routes.enrollmentTiketKAIView) {
//       if (payload.notificationTitle == 'Enrollment Failed') {
//         _navigationService.navigateTo(Routes.onboardingTiketKAIView);
//       } else if (payload.notificationTitle == 'Lanjutkan ke Pembayaran ➡️') {
//         _navigationService.navigateTo(
//           Routes.konfirmasiTiketKAIView,
//           arguments: KonfirmasiTiketKAIViewArguments(
//             enrollmentId: payload.notificationData!['data'],
//             kaiConfirmationType: KAIConfirmationType.fromKAIOnboarding,
//           ),
//         );
//       }
//     }
//   }
// }
