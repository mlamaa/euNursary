import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../Colors.dart';

class FirebaseMessageService {
  static FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  static StreamSubscription iosSubscription;
  // static Map data;
  static Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }

    try {
      print('notification pressed');
    } catch (e) {
      print('onSelectNotification throws and exception $e');
    }
  }

  static Future<void> _showBigTextNotification(
      String payload, String title, String body) async {
    print('_showBigTextNotification');
    var rng = new Random();
    var notifId = rng.nextInt(100);
    var bigTextStyleInformation = BigTextStyleInformation(body,
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: '', //['notification']['body'],
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '12',
      'garderieeu',
      '',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      styleInformation: bigTextStyleInformation,
      color: HexColor("38386C"),
      enableVibration: true,
      enableLights: true,
      playSound: true,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin
        .show(notifId, title, body, platformChannelSpecifics, payload: payload);
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    print("myBackgroundMessageHandler: $message");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    return Future.value(true);
  }

  static initialize() async {
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    // if (Platform.isIOS) {
    //   iosSubscription =
    //       _firebaseMessaging.onIosSettingsRegistered.listen((data) {
    //     // save the token  OR subscribe to a topic here
    //   });
    //   _firebaseMessaging
    //       .requestNotificationPermissions(IosNotificationSettings());
    // }

    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // data = message['data']
        _showBigTextNotification(
            '',
            (message['notification'] ?? {})['title'] ?? '',
            (message['notification'] ?? {})['body'] ?? '');
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // _navigateToItemDetail(message);
      },
    );
  }

  static final String _serverToken =
      'AAAAEoRLsBU:APA91bFXo635i3aQa4eiuS7jXstC6x_sz05LIua3JiB-xGvInywCFDuZOPxqZupNn9eIjb5ijc5PdKD7LE154jLEjJDYnL62SfKgIbbbqxrGAufcA7jKuUr-Mxf-PXmC9sVtBRon41oF';
  // static FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static Future<void> subscribeTOAdmin() async {
    await _firebaseMessaging.subscribeToTopic('admin');
    print('subscribed to admin');
  }

  static Future<Map<String, dynamic>> sendMessageToGroup(
    String topic,
    String title,
    String body,
    Map data,
  ) async {
    try {
      await _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false),
      );

      Firestore _firebase = Firestore.instance;
      _firebase.collection('notification').document('tokens').get().then(
          (tokens) => tokens == null
              ? null
              : _firebase.collection('notification').document(topic).get().then(
                  (group) => group?.data?.keys
                      ?.map((userId) => userId != null &&
                              (tokens.data?.containsKey(userId) ?? false)
                          ? http.post(
                              'https://fcm.googleapis.com/fcm/send',
                              headers: <String, String>{
                                'Content-Type': 'application/json',
                                'Authorization': 'key=$_serverToken',
                              },
                              body: jsonEncode(
                                <String, dynamic>{
                                  'notification': <String, dynamic>{
                                    'body': body,
                                    'title': title
                                  },
                                  'data': data
                                    ..addAll(<String, dynamic>{
                                      'click_action':
                                          'FLUTTER_NOTIFICATION_CLICK',
                                    }),
                                  'priority': 'high',
                                  'to': tokens[userId],
                                },
                              ),
                            )
                          : null)
                      ?.toList()));

      final Completer<Map<String, dynamic>> completer =
          Completer<Map<String, dynamic>>();

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          completer.complete(message);
        },
      );
      return completer.future;
    } catch (e) {
      print("sendAndRetrieveMessage throws an exception $e");
      return null;
    }
  }
}
