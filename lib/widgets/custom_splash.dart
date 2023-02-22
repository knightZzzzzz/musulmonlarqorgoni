import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget _home;
int _duration;
String _imagePath;

class CustomSplash extends StatefulWidget {
  CustomSplash({int duration, Widget home, String imagePath}) {
    _home = home;
    _duration = duration;
    _imagePath = imagePath;
  }

  @override
  _CustomSplashState createState() => _CustomSplashState();
}

class _CustomSplashState extends State<CustomSplash>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    if (_duration < 1000) _duration = 2000;
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _controller.forward();
    _controller.addListener(animationControllerListner);
    super.initState();
  }

  void animationControllerListner() {
    if (_controller.status == AnimationStatus.completed) {
      Future.delayed(Duration(milliseconds: _duration)).then((value) {
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (BuildContext context) => _home));
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(_imagePath), fit: BoxFit.cover)));
  }
}
