import 'package:flutter/material.dart';

class AppModel with ChangeNotifier {
  bool isLoading = true;
  String message;

  Future<void> loadAppConfig() async {
    try {
      //ApiService().setAppConfig(serverConfig['url'], serverConfig['token']);
      isLoading = false;
      notifyListeners();
    } catch (err) {
      message = err.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}

class App {
  Map<String, dynamic> appConfig;
  App(this.appConfig);
}
