import 'package:musulmonlarqorgoni/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'app_init.dart';
import 'models/app.dart';
import 'models/search.dart';
import 'models/uistate.dart';
import 'models/playlist_manager.dart';

import 'screens/home.dart';
import 'common/config.dart';
import 'common/global.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  final _app = AppModel();
  final _search = SearchModel();
  //final _prayTime = PrayTimeModel();

  @override
  void initState() {
    _app.loadAppConfig();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppModel>.value(
        value: _app,
        child: Consumer<AppModel>(builder: (context, value, child) {
          if (value.isLoading) {
            return kLoadingAppWidget(context);
          }
          return MultiProvider(
              providers: [
                Provider<SearchModel>.value(value: _search),
                ChangeNotifierProvider(create: (_) => UiState()),
                ChangeNotifierProvider(create: (_) => PlaylistManager())
              ],
              child: MaterialApp(
                  navigatorKey: navigatorKey,
                  debugShowCheckedModeBanner: false,
                  home: AppInit(
                    onNext: () => HomeScreen(
                      index: 0,
                    ),
                  ),
                  routes: {
                    "/home": (context) => HomeScreen(
                          index: 0,
                        ),
                    "/search": (context) => SearchScreen()
                  }));
        }));
  }
}
