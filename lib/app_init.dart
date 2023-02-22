import 'dart:async';

import 'package:musulmonlarqorgoni/models/menu.dart';
import 'package:musulmonlarqorgoni/screens/category.dart';
import 'package:musulmonlarqorgoni/screens/home.dart';
import 'package:musulmonlarqorgoni/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:musulmonlarqorgoni/widgets/custom_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/global.dart';
import 'models/category.dart';
import 'models/view.dart';
import 'screens/detail.dart';
import 'screens/view.dart';

class AppInit extends StatefulWidget {
  final Function onNext;

  AppInit({this.onNext});

  @override
  _AppInitState createState() => _AppInitState();
}

class _AppInitState extends State<AppInit> {
  final StreamController<bool> _streamInit = StreamController<bool>();

  bool isLoggedIn = false;
  int lastcategory = 0;
  int lastsearch = 0;
  int lastdetail = 0;
  int lastfollow = 0;
  int lastview = 0;

  Future<bool> checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = prefs.getBool('seen') ?? false;
    return _seen;
  }

  Future loadInitData() async {
    bool isFirstSeen = false;
    try {
      isFirstSeen = await checkFirstSeen();
    } catch (e, trace) {
      print(e.toString());
      print(trace.toString());
    }
    if (!_streamInit.isClosed) {
      _streamInit.add(isFirstSeen);
    }
  }

  setLast() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lastview = prefs.getInt('lastview') ?? 0;
    lastdetail = prefs.getInt('lastdetail') ?? 0;
    lastfollow = prefs.getInt('lastfollow') ?? 0;
    lastsearch = prefs.getInt('lastsearch') ?? 0;
    lastcategory = prefs.getInt('lastcategory') ?? 0;
  }

  Widget onNextScreen(bool isFirstSeen) {
    setLast();
    if (!isFirstSeen) {
      //if (onBoardingData.isNotEmpty) return OnBoardScreen();
    }

    if (lastdetail != 0) {
      for (var i = 0; i < categoryList.length; i++) {
        final jsonData = Category.fromJson(categoryList[i]);
        if (lastdetail == jsonData.id)
          return DetailScreen(
            category: jsonData,
          );
      }
    }

    if (lastview != 0) {
      return ViewScreen(item: View.fromJson(viewList[lastview - 1]));
    }

    if (lastfollow != 0) {
      return HomeScreen(index: 1);
    }

    if (lastcategory != 0) {
      for (var i = 0; i < menuList.length; i++) {
        final jsonData = Menu.fromJson(menuList[i]);
        if (lastcategory == jsonData.id) return CategoryScreen(menu: jsonData);
      }
    }

    if (lastsearch != 0) {
      return SearchScreen();
    }

    return widget.onNext();
  }

  @override
  void initState() {
    loadInitData();
    super.initState();
  }

  @override
  void dispose() {
    _streamInit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _streamInit.stream,
      builder: (context, snapshot) {
        var _iFirstSeen = snapshot.data ?? false;

        return CustomSplash(
            imagePath: "assets/images/splash.png",
            home: onNextScreen(_iFirstSeen),
            duration: 3000);
      },
    );
  }
}
