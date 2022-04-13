import 'dart:io';


import 'package:agora_video_call/api/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettingsAndroid =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationsPlugin.initialize(
      initializationSettingsAndroid,
      onSelectNotification: (String? route) async {
        if (route != null) {
          Utils.notificationRouter(route, 3);
        }
      },
    );
  }

  static Future<void> display(RemoteMessage message) async {
    print(message.data);
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails("channel_id", "Main",
            color: Color.fromRGBO(252, 165, 3, 1),
            importance: Importance.max,
            priority: Priority.high),
      );
      await _notificationsPlugin.show(id, message.notification?.title,
          message.notification?.body, notificationDetails,
          payload: message.data['route']);
    } catch (e) {
      debugPrint(e.toString());
    }
  }



  // static Future<void> showBigPictureNotificationHiddenLargeIcon(
  //     RemoteMessage message) async {
  //   final String largeIconPath = await downloadAndSaveFile(
  //       message.notification!.android!.imageUrl!, 'largeIcon');
  //   final String bigPicturePath = await downloadAndSaveFile(
  //       message.notification!.android!.imageUrl!, 'bigPicture');
  //   final BigPictureStyleInformation bigPictureStyleInformation =
  //       BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
  //           hideExpandedLargeIcon: true,
  //           contentTitle: 'overridden <b>big</b> content title',
  //           htmlFormatContentTitle: false,
  //           summaryText: 'summary <i>text</i>',
  //           htmlFormatSummaryText: false);
  //   final AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //           'big text channel id', 'big text channel name',
  //           channelDescription: 'big text channel description',
  //           largeIcon: FilePathAndroidBitmap(largeIconPath),
  //           styleInformation: bigPictureStyleInformation);
  //   final NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await _notificationsPlugin.show(1, message.notification!.title,
  //       message.notification!.body, platformChannelSpecifics);
  // }


}