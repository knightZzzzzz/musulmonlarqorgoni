import 'package:flutter/material.dart';

Widget kLoadingAppWidget(context) => Center(
        child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow[100]),
      strokeWidth: 2.0,
      backgroundColor: Colors.black,
    ));

Widget kLoadingWidget(context) => Center(
    child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow[100]),
        strokeWidth: 2.0,
        backgroundColor: Colors.yellow[500]));
