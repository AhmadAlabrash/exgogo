import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:xilancer/helper/local_keys.g.dart';

import '../customizations.dart';
import '../main.dart';
import '../services/push_notification_service.dart';
import '../views/conversation_view/conversation_view.dart';
import '../views/my_order_details_view/my_order_details_view.dart';
import '../views/offer_details_view/offer_details_view.dart';
import 'constant_helper.dart';
import 'firebase_messaging_helper.dart';
import 'pusher_helper.dart';

class NotificationHelper {
  StreamSubscription<String?>? streamSubscription;

  notificationAppLaunchChecker(BuildContext context) async {
    print(
        '${notificationDetails?.notificationResponse?.payload}App launch notification details');
    if (notificationDetails?.notificationResponse?.payload != null) {
      final payload = jsonDecode(
          notificationDetails?.notificationResponse?.payload ?? "{}");
      await Future.delayed(const Duration(milliseconds: 10));
      proceedRouting(payload);
      if (payload["type"].toString().contains("order")) {
        print('from app launch');
        // navigatorKey.currentState
        //     ?.pushNamed(OrderDetailsView.routeName,
        //         arguments: payload["id"].toString())
        //     .then((value) => selectedNotificationPayload = null);
      }
      setNotificationDetails(null);
    }
  }

  streamListener(BuildContext context) {
    streamSubscription ??= selectNotificationStream.stream.listen(
      (event) async {
        // if (notificationCount.value > 1) {
        //   notificationCount.value = 0;
        // }
        bool notNavigated = true;
        if (notNavigated) {
          debugPrint(
              '$selectedNotificationPayload App launch notification details');
          final payLoad = jsonDecode(selectedNotificationPayload ?? "{}");
          debugPrint("Notification type is ${payLoad["type"]}".toString());
          proceedRouting(payLoad);
          notNavigated = false;
        }
      },
    );
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  initiateNotification(BuildContext context) async {
    final pnProvider = PushNotificationService();
    if (pnProvider.userToken != null) {
      print('User fire token: ${pnProvider.userToken}');
      return;
    }
    NotificationSettings settings = await messaging.requestPermission(
        alert: false,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: false);
    try {
      if (Platform.isIOS) {
        pnProvider.setUserToken(await messaging.getAPNSToken());
      } else {
        pnProvider.setUserToken(await messaging.getToken());
      }
    } catch (e) {}
    print('User granted permission: ${settings.authorizationStatus}');
    print('User fire token: ${pnProvider.userToken}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final msgId = message.data['id'] is String
          ? int.tryParse(message.data['id'])
          : message.data['id'];

      String title = message.data['title'] ?? "";
      String? description = message.data['body'] ?? "";
      String identity = message.data['identity'] ?? "";
      log(message.data.toString());
      if (message.data['type'] == "Order") {
        title = description ?? "";
        description = "${LocalKeys.orderId}: #$identity";
      }
      if (message.data['type'] == "message") {
        var liveChatData = jsonDecode(message.data["livechat"] ?? "{}");
        try {
          log((liveChatData["freelancer"]).toString());
          title = liveChatData["freelancer"]?["first_name"]?.toString() ?? "";
          debugPrint("title added".toString());
          description =
              jsonDecode(message.data['body']?.toString() ?? "{}")?["message"]
                  ?.toString();
          debugPrint("message added".toString());
        } catch (e) {
          log((liveChatData is Map).toString());
          log(e.toString());
        }
      }
      log(message.data.toString());
      // notificationCount.value += 1;
      debugPrint("notification data is".toString());
      debugPrint(message.data.toString());
      selectedNotificationPayload = jsonEncode(message.data);
      NotificationHelper().triggerNotification(
          id: msgId ?? 1,
          body: description ?? message.data['body'],
          title: title ?? message.data["title"],
          payload: message.data);

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    if (Platform.isIOS) {
      final deviceToken = await messaging.getAPNSToken();
    } else {
      final deviceToken = await messaging.getToken();
    }
    messaging.subscribeToTopic('all');
  }

  triggerNotification(
      {required int id,
      required String title,
      required String body,
      payload,
      String? channelName}) {
    // flutterLocalNotificationsPlugin.cancelAll();
    debugPrint(payload.toString());
    flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            '$id',
            channelName ?? 'channelName',
            priority: Priority.max,
            importance: Importance.max,
            visibility: NotificationVisibility.public,
          ),
        ),
        payload: jsonEncode(payload));
  }
}

proceedRouting(Map payLoad) {
  String type = payLoad['type'] ?? "name";
  if (type == "Order") {
    String identity = payLoad['identity'] ?? "";
    if (orderId != null) {
      navigatorKey.currentState?.pop();
    }
    navigatorKey.currentState?.pushNamed(MyOrderDetailsView.routeName,
        arguments: identity.toString());
  }
  if (type == "Offer") {
    String offerId = payLoad['identity'] ?? "";
    if (orderId != null) {
      navigatorKey.currentState?.pop();
    }
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (context) => OfferDetailsView(id: offerId),
    ));
  }
  if (type == "message") {
    var liveChatData = jsonDecode(payLoad["livechat"] ?? "{}");
    // log(message.data.toString());
    try {
      if (conversationId.toString() == liveChatData["id"].toString()) {
        return;
      }
      if (conversationId != null) {
        navigatorKey.currentState?.pop();
      }
      var clientId = liveChatData["client"]?["id"]?.toString() ?? "";
      var freelancer = liveChatData["freelancer"] ?? {};

      navigatorKey.currentState
          ?.pushNamed(ConversationView.routeName, arguments: [
        liveChatData["id"].toString(),
        freelancer["first_name"] + " " + freelancer["last_name"],
        "$userProfilePath/${liveChatData["freelancer"]?["image"]?.toString() ?? ""}",
        freelancer?["id"],
        liveChatData["freelancer_id"]
      ]).then((value) {
        selectedNotificationPayload = null;

        PusherHelper().disConnect();
        setConversationId(null);
      });

      debugPrint("message added".toString());
    } catch (e) {
      log((liveChatData is Map).toString());
      log(e.toString());
    }
  }
}

var safsd = {
  "id": 27,
  "client_id": 1,
  "freelancer_id": 7,
  "admin_id": null,
  "created_at": "2023-09-07T10:41:23.000000Z",
  "updated_at": "2023-09-07T10:41:23.000000Z",
  "freelancer": {
    "id": 7,
    "first_name": "Nazmul",
    "last_name": "Hoque",
    "hourly_rate": 30,
    "experience_level": "junior",
    "email": "tfreelancer@gmail.com",
    "phone": "01713602710",
    "username": "freelancer",
    "image": "1723031735-66b360b7f18c4.jpg",
    "country_id": 1,
    "state_id": 1,
    "city_id": 1,
    "user_type": 2,
    "check_online_status": "2024-10-10T05:54:10.000000Z",
    "check_work_availability": 1,
    "user_active_inactive_status": 1,
    "user_verified_status": 1,
    "is_suspend": 0,
    "terms_condition": 1,
    "about": null,
    "is_email_verified": "1",
    "google_2fa_secret": "SOVLAM7IWRWHZX23",
    "google_2fa_enable_disable_disable": 0,
    "google_id": null,
    "facebook_id": null,
    "github_id": null,
    "apple_id": null,
    "is_pro": "yes",
    "pro_expire_date": "2024-09-08 06:07:54",
    "email_verify_token": "598945",
    "firebase_device_token":
        "cnGQupwPQV2ZXg3ZSo2AaH:APA91bHOXGz9ejIKmA6_bF6CpVgATwbOOKJH1kVQKFPT4xBYLUiBa3iHzXQ4JmyGpyfc9rl2Hro8K56G-vW8xI19mOswlXdreGdljB-5gw6-JzER1MlIxVb_PZVjKxRvFGnEDhOhf614",
    "freeze_withdraw": "freeze",
    "freeze_project": "unfreeze",
    "freeze_job": null,
    "freeze_chat": "unfreeze",
    "freeze_order_create": null,
    "email_verified_at": null,
    "load_from": 1,
    "is_synced": 1,
    "created_at": "2023-01-24T10:58:46.000000Z",
    "updated_at": "2024-10-10T05:54:10.000000Z",
    "deleted_at": null
  },
  "client": {
    "id": 1,
    "first_name": "Test",
    "last_name": "Client",
    "hourly_rate": 20,
    "experience_level": "junior",
    "email": "tclient@gmail.com",
    "phone": "6546463544645",
    "username": "client",
    "image": "1722483823-66ab046f1a1ff.jpg",
    "country_id": 1,
    "state_id": 1,
    "city_id": 1,
    "user_type": 1,
    "check_online_status": "2024-10-10T05:52:26.000000Z",
    "check_work_availability": 1,
    "user_active_inactive_status": 1,
    "user_verified_status": 1,
    "is_suspend": 0,
    "terms_condition": 1,
    "about": null,
    "is_email_verified": "1",
    "google_2fa_secret": "HATKCPGN5WGPJEFU",
    "google_2fa_enable_disable_disable": 0,
    "google_id": null,
    "facebook_id": null,
    "github_id": null,
    "apple_id": null,
    "is_pro": null,
    "pro_expire_date": null,
    "email_verify_token": "969657",
    "firebase_device_token":
        "eyar1gBcQ_2wuVc-jK7rJ1:APA91bHX3WQaIljuOCpPebDiOXX3FSCWo7Q-zeFPxbuFPpz4zRCyoj7_S-Jox83f6W_hshSepbtoiPzF2YiJlt1Y63JIfduBufTYvdWrjR-7mdLBpuvfCOWt6u1SEY2WtNYNdKho73KE",
    "freeze_withdraw": null,
    "freeze_project": null,
    "freeze_job": "unfreeze",
    "freeze_chat": "unfreeze",
    "freeze_order_create": "unfreeze",
    "email_verified_at": null,
    "load_from": 1,
    "is_synced": 1,
    "created_at": "2023-01-23T12:03:28.000000Z",
    "updated_at": "2024-10-10T05:52:26.000000Z",
    "deleted_at": null
  }
};
