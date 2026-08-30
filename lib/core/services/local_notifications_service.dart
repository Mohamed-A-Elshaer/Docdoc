import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class LocalNotificationsService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
  StreamController();
  static onTap(NotificationResponse notificationResponse) {
    // log(notificationResponse.id!.toString());
    // log(notificationResponse.payload!.toString());
    streamController.add(notificationResponse);
    // Navigator.push(context, route);
  }

  static Future<void> init() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  //basic Notification
  static void showBasicNotification(RemoteMessage message) async {
    final http.Response image = await http.get(Uri.parse(message.notification?.android?.imageUrl??''));
    BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(
      ByteArrayAndroidBitmap.fromBase64String(base64Encode(image.bodyBytes)),
      largeIcon: ByteArrayAndroidBitmap.fromBase64String(base64Encode(image.bodyBytes)),
    );
    AndroidNotificationDetails android = AndroidNotificationDetails(
      'channel_id', 
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      styleInformation: bigPictureStyleInformation,
      sound: const RawResourceAndroidNotificationSound('elevenlabs_positive_chime_for_accepted_user_input'),
    );
    NotificationDetails details = NotificationDetails(
      android: android,
    );
    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: details,
    );
  }
}