import 'package:flutter/material.dart';
import 'package:xilancer/helper/app_urls.dart';
import 'package:xilancer/helper/constant_helper.dart';
import 'package:xilancer/helper/extension/string_extension.dart';

import '../data/network/network_api_services.dart';

class ModuleListService with ChangeNotifier {
  var _hourlyJobModule = false;
  final _promotionModule = false;
  final _freelancerLevelModule = false;

  bool get hourlyJobModule => _hourlyJobModule;
  bool get promotionModule => _promotionModule;
  bool get freelancerLevelModule => _freelancerLevelModule;

  fetchModuleList() async {
    var url = AppUrls.moduleListUrl;

    final responseData = await NetworkApiServices().getApi(
      url,
      null,
      headers: acceptJsonAuthHeader,
    );

    if (responseData != null) {
      debugPrint(responseData.toString());
      _hourlyJobModule =
          (responseData["module_status"]["HourlyJob"]).toString().parseToBool;
      return true;
    }
  }
}
