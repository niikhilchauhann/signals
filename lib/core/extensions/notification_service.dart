// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';


// class NotificationService {
//   final FirebaseMessaging messaging = FirebaseMessaging.instance;
//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   // bool _isInitialized = false;

//   // bool get isInitialized => _isInitialized;

//   AndroidNotificationChannel channel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.high,
//   );

//   bool isFlutterLocalNotificationsInitialized = false;

//   // Init Notification
//   Future<void> initNotification() async {
//     await requestNotificationPermissions();
//     // if (!_isInitialized) return;
//     final initAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//     final initIOS = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     final initSettings = InitializationSettings(
//       android: initAndroid,
//       iOS: initIOS,
//     );
//     try {
//       await onTokenRefresh();
//       if (!kIsWeb) {
//         await setupNotificationChannel();
//       }
//       await flutterLocalNotificationsPlugin.initialize(initSettings);
//       await initMessageListeners();
//       // _isInitialized = true;
//     } catch (e) {
//       debugPrint(e.toString());
//       // _isInitialized = false;
//     }
//   }

//   // Update FCM Token
//   Future onTokenRefresh() async {
//     FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user?.uid != null) {
//         try {
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(user!.uid)
//               .set({'fcmToken': token}, SetOptions(merge: true));
//         } catch (e, stack) {
//           debugPrint('FCM token update failed: $e\n$stack');
//         }
//       }
//     });
//   }

//   //Notification Channel
//   Future<void> setupNotificationChannel() async {
//     if (isFlutterLocalNotificationsInitialized) {
//       return;
//     }

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);

//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//     isFlutterLocalNotificationsInitialized = true;
//   }

//   //Notification Details
//   NotificationDetails notificationDetails() {
//     final initAndroidSettings = AndroidNotificationDetails(
//       channel.id,
//       channel.name,
//       importance: Importance.max,
//       priority: Priority.high,
//       channelDescription: channel.description,
//       icon: '@mipmap/ic_launcher',
//     );

//     return NotificationDetails(
//       android: initAndroidSettings,
//       iOS: DarwinNotificationDetails(),
//     );
//   }

//   //Show local notifications
//   void showFlutterNotification(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;

//     final title = notification?.title ?? message.data['title'];
//     final body = notification?.body ?? message.data['body'];

//     if (title == null && body == null) return;

//     return flutterLocalNotificationsPlugin.show(
//       message.hashCode,
//       title,
//       body,
//       notificationDetails(),
//     );
//   }

//   //Send push notifications
//   final HttpsCallable _sendNotification = FirebaseFunctions.instance
//       .httpsCallable('sendNotification');

//   Future<void> sendPushNotification({
//     required String token,
//     required String title,
//     required String body,
//   }) async {
//     if (token.isEmpty) return;
//     try {
//       final result = await _sendNotification.call({
//         'token': token,
//         'title': title,
//         'body': body,
//       });
//       debugPrint("✅ Notification sent: ${result.data}");
//       debugPrint("🎯 Raw token: '$token' (${token.runtimeType})");
//     } catch (e) {
//       debugPrint("Error sending push: $e");
//     }
//   }

//   //Notification permissions
//   Future<void> requestNotificationPermissions() async {
//     NotificationSettings settings = await messaging.requestPermission();
//     final fcmToken = await messaging.getToken();
//     debugPrint('🔑 FCM Token: $fcmToken');

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       debugPrint('✅ User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       debugPrint('⚠️ User granted provisional permission');
//     } else {
//       debugPrint('❌ User declined or has not accepted permission');
//     }
//   }

//   //Message listeners
//   Future initMessageListeners() async {
//     messaging.getInitialMessage().then(handleMessage);
//     FirebaseMessaging.onMessage.listen((message) {
//       // print('FCM message received in foreground');
//       handleMessage(message);
//       showFlutterNotification(message);
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//     // FirebaseMessaging.onBackgroundMessage((message) {
//     //   print('FCM message received');
//     //   handleMessage(message);
//     //   showFlutterNotification(message);
//     //   return Future.value();
//     // });
//   }

//   // Message handler
//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;
//     debugPrint('📩 FCM Message data: ${message.data}');
//     debugPrint(
//       '🔔 FCM Message also contained a notification: ${message.notification?.title} ${message.notification?.body}',
//     );

//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//     navigateToScreen(message);
//   }

//   void navigateToScreen(RemoteMessage message) {
//     final notification = message.notification;
//     if (notification == null) return;

//     final title = notification.title?.toLowerCase() ?? '';
//     final body = notification.body?.toLowerCase() ?? '';

//     // Widget route = AppStructure();

//     // if (title.contains('new coupon')) {
//     //   route = ExploreCouponScreen();
//     // } else if (body.contains('game') || body.contains('slot')) {
//     //   route = RegisterGameScreen();
//     // } else if (title.contains('congratulations')) {
//     //   route = ChatInboxScreen();
//     // }

//     // navigatorKey.currentState?.push(
//     //   CupertinoPageRoute(builder: (context) => route),
//     // );
//   }
// }
