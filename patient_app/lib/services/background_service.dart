import 'dart:async';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:gehealth_care/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<void> onNotificationCreatedMethod(
//     ReceivedNotification receivedNotification) async {
//   debugPrint("onNotificationCreatedMethod");
// }
//
// Future<void> onNotificationDisplayedMethod(
//     ReceivedNotification receivedNotification) async {
//   debugPrint("onNotificationDisplayedMethod");
// }
//
// Future<void> onDismissActionReceivedMethod(
//     ReceivedNotification receivedNotification) async {
//   debugPrint("onDismissActionReceivedMethod");
// }
//
// Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
//   if (receivedAction.actionType == ActionType.SilentAction ||
//       receivedAction.actionType == ActionType.SilentBackgroundAction) {
//     debugPrint("onActionReceivedMethod");
//     final payload = receivedAction.payload ?? {};
//     if (payload['navigate'] == "true") {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       int currentValue = prefs.getInt("counter") ?? 0;
//       int incrementedValue = currentValue + 1;
//       await prefs.setInt("counter", incrementedValue);
//     }
//   }
// }

@pragma("vm:entry-point")
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  await NotificationService.initializeNotifications();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // await AwesomeNotifications().setListeners(
  //   onActionReceivedMethod: onActionReceivedMethod,
  //   onDismissActionReceivedMethod: onDismissActionReceivedMethod,
  //   onNotificationCreatedMethod: onNotificationCreatedMethod,
  //   onNotificationDisplayedMethod: onNotificationDisplayedMethod,
  // );

  Timer.periodic(
    const Duration(seconds: 10),
    (timer) async {
      await NotificationService.showNotification(
        title: "Title of Notification",
        body: "Scheduled Notifications",
        payload: {
          "navigate": "true",
        },
        actionButtons: [
          NotificationActionButton(
            key: "ACTION_BUTTON",
            label: "Check it out",
            actionType: ActionType.SilentAction,
            color: Colors.green,
          ),
        ],
      );
    },
  );
}

class BackgroundService {
  Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
        autoStartOnBoot: true,
        initialNotificationContent: "Background service running",
        initialNotificationTitle: "Background service",
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onBackground: null,
        onForeground: onStart,
      ),
    );
  }
}
