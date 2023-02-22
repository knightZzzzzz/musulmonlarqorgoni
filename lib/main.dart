// @dart=2.9
import 'dart:io';
import 'package:musulmonlarqorgoni/common/tools.dart';

import 'app.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Provider.debugCheckInvalidValueType = null;

  HttpClient.enableTimelineLogging = true;

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: HexColor("#003d36"),
      statusBarColor: HexColor("#003d36")));

  runApp(App());
}
