// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:garderieeu/Colors.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';


// class NotificationHandler {

//   static final NotificationHandler _singleton =
//   new NotificationHandler._internal();
//   static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   final FirebaseMessaging _fcm = FirebaseMessaging();
//   StreamSubscription iosSubscription;
//   BuildContext myAppBuildContext;
//   int nextMoveTupe = 0;



//   factory NotificationHandler() {
//     return _singleton;
//   }
//   NotificationHandler._internal();

//   static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//     print("myBackgroundMessageHandler: $message");
//     return true;
// //    _showBigPictureNotification(message);
//     // Or do other work.

//   }


//   Future<String> onMessageFunction(Map<String, dynamic> message) async{

//     print("onMessage: $message");

//     try {
//      if (message['data']['GCM_COMMAND_CODE_KEY'].toString() == '54') {//appointment added
//         // appointmentTextTitle = 'A new appointment was added to you by ' + message['data']['USER_CODE_KEY'] + ' at ' +  message['data']['date_added'] ;
//         // appointmentTextBody = message['data']['appointment_comment'] == null ? 'commect' : message['data']['appointment_comment'];
//         _showBigTextNotification('','appointmentTextTitle','appointmentTextBody');
//         nextMoveTupe = 3;
//       }else{
//         _showBigTextNotification('','','');
//       }
//     }
//     catch(e){
//       print('onMessageFunction throws and exception');
//       print(e);
//     }
//     return '';
//   }

 

 
  

//   Future<void> onDidReceiveLocalNotification(
//       int id, String title, String body, String payload) async {
//     // display a dialog with the notification details, tap ok to go to another page
//   }


// }

