import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../data/network/network_api_services.dart';
import '../helper/app_urls.dart';
import '../helper/constant_helper.dart';

class PushNotificationService {
  String? userToken;

  setUserToken(value) {
    userToken = value;
  }

  updateDeviceToken({bool forceUpdate = false}) async {
    String? localToken = sPref?.getString("device_token") ?? "";

    final String? uToken;

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      uToken = await messaging.getAPNSToken();
    } else {
      uToken = await messaging.getToken();
    }

    if (uToken == localToken && !forceUpdate) {
      return;
    }
    setUserToken(userToken);
    sPref?.setString("device_token", userToken ?? uToken ?? "");
    final data = {"token": userToken ?? uToken ?? ""};
    debugPrint(data.toString());
    final responseData = await NetworkApiServices().postApi(
      data,
      AppUrls.fcmTokenUrl,
      null,
      headers: acceptJsonAuthHeader,
    );
    debugPrint(responseData.toString());
    if (responseData != null) {
      sPref?.setString("device_token", userToken ?? uToken ?? "");
    }
  }
}
