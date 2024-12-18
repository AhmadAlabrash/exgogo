import 'package:flutter/material.dart';

import '../../data/network/network_api_services.dart';
import '../../helper/app_urls.dart';
import '../../helper/constant_helper.dart';
import '../../helper/local_keys.g.dart';
import '../../models/country_model.dart';

class CountryDropdownService with ChangeNotifier {
  bool countryLoading = false;
  String countrySearchText = '';

  List<Country?> countryDropdownList = [];

  bool nextPageLoading = false;

  String? nextPage;

  bool nexLoadingFailed = false;

  setCountrySearchValue(value) {
    if (value == countrySearchText) {
      return;
    }
    countrySearchText = value;
  }

  resetList() {
    if (countrySearchText.isEmpty && countryDropdownList.isNotEmpty) {
      return;
    }
    countrySearchText = '';
    countryDropdownList = [];
    getCountries();
  }

  void getCountries() async {
    countryLoading = true;
    nextPage = null;
    notifyListeners();
    final url = "${AppUrls.countryUrl}?country=$countrySearchText";
    final responseData = await NetworkApiServices()
        .getApi(url, LocalKeys.country, headers: commonAuthHeader);

    if (responseData != null) {
      final tempData = CountryModel.fromJson(responseData);
      countryDropdownList = tempData.countries ?? [];
      nextPage = tempData.nextPage;

      notifyListeners();
    } else {}

    countryLoading = false;
    notifyListeners();
  }

  fetchNextPage() async {
    if (nextPageLoading || nextPage == null) return;
    nextPageLoading = true;
    final responseData = await NetworkApiServices()
        .getApi(nextPage!, LocalKeys.country, headers: commonAuthHeader);

    if (responseData != null) {
      final tempData = CountryModel.fromJson(responseData);
      nextPage = tempData.nextPage;
      tempData.countries?.forEach((s) {
        countryDropdownList.add(s);
      });
      nextPage = tempData.nextPage;
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
