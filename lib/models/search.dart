import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchModel extends ChangeNotifier {
  SearchModel() {
    getKeywords();
  }

  List<String> keywords = [];
  bool loading = false;
  String errMsg;

  void searchBy({String name, page}) async {
    try {
      loading = false;
      notifyListeners();
    } catch (err) {
      loading = false;
      errMsg = err.toString();
      notifyListeners();
    }
  }

  void clearKeywords() {
    keywords = [];
    saveKeywords(keywords);
    notifyListeners();
  }

  void saveKeywords(List<String> keywords) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList("recentSearches", keywords);
    } catch (err) {
      print(err);
    }
  }

  getKeywords() async {
    try {
      //SharedPreferences.setMockInitialValues({});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList("recentSearches");
      if (list != null && list.length > 0) {
        keywords = list;
      }
    } catch (err) {
      print(err);
    }
  }

  Map<String, dynamic> toJson(search, limit, offset) {
    return {'search': search, 'limit': limit, 'offset': offset};
  }
}
