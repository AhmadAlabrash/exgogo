import 'package:flutter/material.dart';

import '../../data/network/network_api_services.dart';
import '../../helper/app_urls.dart';
import '../../helper/constant_helper.dart';
import '../../helper/local_keys.g.dart';
import '../../models/state_model.dart';

class StatesDropdownService with ChangeNotifier {
  bool statesLoading = false;
  String statesSearchText = '';
  var countryId;

  List<States?> statesList = [];

  bool nextPageLoading = false;

  String? nextPage;

  bool nexLoadingFailed = false;

  setStatesSearchValue(value) {
    if (value == statesSearchText) {
      return;
    }
    statesSearchText = value;
  }

  resetList(cId) {
    if (statesSearchText.isEmpty && statesList.isNotEmpty && cId == countryId) {
      return;
    }
    statesSearchText = '';
    countryId = cId;
    statesList = [];
    getStates();
  }

  void getStates() async {
    statesLoading = true;
    nextPage = null;
    notifyListeners();
    final url =
        "${AppUrls.stateUrl}?country_id=$countryId&state=$statesSearchText";
    final responseData = await NetworkApiServices()
        .postApi({}, url, LocalKeys.state, headers: commonAuthHeader);

    if (responseData != null) {
      final tempData = StateModel.fromJson(responseData);
      statesList = tempData.state ?? [];
      nextPage = tempData.nextPage;
      notifyListeners();
    } else {}

    statesLoading = false;
    notifyListeners();
  }

  fetchNextPage() async {
    if (nextPageLoading || nextPage == null) return;
    nextPageLoading = true;
    final responseData = await NetworkApiServices()
        .postApi({}, nextPage!, LocalKeys.state, headers: commonAuthHeader);

    if (responseData != null) {
      final tempData = StateModel.fromJson(responseData);
      tempData.state?.forEach((s) {
        statesList.add(s);
      });
      nextPage = tempData.nextPage;
      notifyListeners();
    } else {
      nexLoadingFailed = true;
      Future.delayed(const Duration(seconds: 1)).then((value) {
        nexLoadingFailed = false;
        notifyListeners();
      });
    }
    nextPageLoading = false;
    notifyListeners();
  }
}