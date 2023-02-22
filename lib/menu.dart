import 'dart:io';

import 'package:musulmonlarqorgoni/common/global.dart';
import 'package:musulmonlarqorgoni/models/menu.dart';
import 'package:musulmonlarqorgoni/screens/category.dart';
import 'package:musulmonlarqorgoni/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuBar extends StatefulWidget {
  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  List<Menu> items = [];

  @override
  initState() {
    for (var i = 0; i < menuList.length; i++) {
      items.add(Menu.fromJson(menuList[i]));
    }
    super.initState();
  }

  Widget drawerItem(Menu item) {
    return Container(
        height: 44.0,
        child: ListTile(
            leading:
                Image.asset('assets/images/star.png', height: 32, width: 32),
            title: Transform.translate(
                offset: Offset(-12.0, 0.0),
                child: Text(item.name,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500))),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          CategoryScreen(menu: item)));
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(2, 63, 61, 0.7),
            image: DecorationImage(
                image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
        child: SingleChildScrollView(
            child: Column(children: [
          Container(
              height: 44.0,
              child: ListTile(
                  title: Transform.translate(
                      offset: Offset(-12.0, 0.0),
                      child: Text('Мавзулар',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500))),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("/home");
                  })),
          Container(
              height: 44.0,
              child: ListTile(
                  leading: Image.asset('assets/images/star.png',
                      height: 32, width: 32),
                  title: Transform.translate(
                      offset: Offset(-12.0, 0.0),
                      child: Text('Мундарижа',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500))),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("/home");
                  })),
          Column(
              children: List.generate(items.length, (index) {
            return drawerItem(items[index]);
          })),
          Container(
              height: 44.0,
              child: ListTile(
                  leading: Icon(Icons.bookmark, size: 32, color: Colors.yellow),
                  title: Transform.translate(
                      offset: Offset(-12.0, 0.0),
                      child: Text("Танланганлар",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500))),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HomeScreen(index: 1)));
                  })),
          Container(
              height: 44.0,
              child: ListTile(
                  leading:
                      Icon(Icons.rate_review, size: 32, color: Colors.yellow),
                  title: Transform.translate(
                      offset: Offset(-12.0, 0.0),
                      child: Text("Изоҳ қолдириш",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500))),
                  onTap: () async {
                    //Navigator.of(context).pushReplacementNamed("/home");
                    var url = 'http://bit.ly/musulmonlarqurgoni';
                    if (Platform.isIOS) {
                      url = 'https://apple.co/2tcSzh2';
                    }
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  })),
          Container(
              height: 44.0,
              margin: EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                  leading:
                      Icon(Icons.person_add, size: 32, color: Colors.yellow),
                  title: Transform.translate(
                      offset: Offset(-12.0, 0.0),
                      child: Text("Дўстларингизга тавсия қилинг",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500))),
                  onTap: () {
                    String text =
                        "Мен МУСУЛМОН ҚЎРҒОНИ (дуо ва зикрлар) мобил иловасидан фойдаланаябман.\nСиз излаб юрган  дуоларни осон излаб топиш, аудиоларни эшитиш ва ўз яқинларингизга улашиш имкони мавжуд. Юклаб олинг ва ўз дўстларигнизга ҳам улашинг!";
                    text +=
                        '\nGoogle Play: ' + 'http://bit.ly/musulmonlarqurgoni';
                    text += '\nApp Store: ' + 'https://apple.co/2tcSzh2';
                    Share.share(text);
                  }))
        ])));
  }
}
