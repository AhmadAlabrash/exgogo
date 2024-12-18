import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/services/app_string_service.dart';
import '../services/dynamics/dynamics_service.dart';

late DynamicsService dProvider;
late AppStringService asProvider;
SharedPreferences? sPref;

var _conversationId;

get conversationId => _conversationId;
setConversationId(id) {
  _conversationId = id;
}

var _orderId;

get orderId => _orderId;
setOrderId(id) {
  _orderId = id;
}

String get getToken {
  return sPref?.getString("token") ?? "";
}

setToken(token) {
  sPref?.setString("token", token ?? "");
}

get commonAuthHeader => {'Authorization': 'Bearer $getToken'};
get acceptJsonHeader => {'Accept': 'application/json'};
get acceptJsonAuthHeader =>
    {'Accept': 'application/json', 'Authorization': 'Bearer $getToken'};

coreInit(BuildContext context) async {
  dProvider = Provider.of<DynamicsService>(context, listen: false);
  asProvider = Provider.of<AppStringService>(context, listen: false);
  sPref ??= await SharedPreferences.getInstance();
}
