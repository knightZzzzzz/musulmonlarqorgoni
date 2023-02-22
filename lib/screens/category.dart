import 'package:musulmonlarqorgoni/common/global.dart';
import 'package:musulmonlarqorgoni/menu.dart';
import 'package:musulmonlarqorgoni/models/category.dart';
import 'package:musulmonlarqorgoni/models/menu.dart';
import 'package:musulmonlarqorgoni/models/uistate.dart';
import 'package:musulmonlarqorgoni/screens/detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryScreen extends StatefulWidget {
  final Menu menu;
  CategoryScreen({this.menu});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var ui;

  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < categoryList.length; i++) {
      final jsonData = Category.fromJson(categoryList[i]);
      if (widget.menu.id == jsonData.menuId) categories.add(jsonData);
    }
    setLast();
    _controller = AnimationController(vsync: this);
    ui = Provider.of<UiState>(context, listen: false);
  }

  setLast() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastview', 0);
    prefs.setInt('lastsearch', 0);
    prefs.setInt('lastfollow', 0);
    prefs.setInt('lastdetail', 0);
    prefs.setInt('lastactive', 0);
    prefs.setInt('lastcategory', widget.menu.id);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                brightness: Brightness.dark,
                leading: IconButton(
                    icon: Image.asset("assets/images/menu.png",
                        width: 24, height: 24),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    }),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                title: Text(widget.menu.name),
                actions: <Widget>[
                  //IconButton(
                  //  icon: Image.asset(
                  //    "assets/images/font_size.png",
                  //    width: 24,
                  //    height: 24
                  //  ),
                  //  onPressed: () {
                  //    showDialogFontSize(context);
                  //  }
                  //)
                ]),
            body: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SingleChildScrollView(
                    child: Column(children: [
                  for (var i = 0; i < categories.length; i++)
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DetailScreen(
                                        category: categories[i],
                                      )));
                        },
                        child: getCard(i + 1, categories[i]))
                ]))),
            drawer: Drawer(child: MenuBar())));
  }

  Widget getCard(index, item) {
    return Container(
        height: 64.0,
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/margin.png", width: 32.0),
              SizedBox(width: 4.0),
              Expanded(child: Text(item.name, maxLines: 2)),
              SizedBox(width: 4.0),
              Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/stars.png'),
                          fit: BoxFit.cover)),
                  child: Center(
                      child: Text(index.toString(),
                          style: TextStyle(fontSize: 12))))
            ]));
  }

  showDialogFontSize(BuildContext _) {
    showDialog(
        context: _,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Container(
                    height: 200,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(children: [
                      Column(children: [
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Arabcha matn o'lchami"),
                                  Text(ui.fontSize.toInt().toString())
                                ])),
                        Slider(
                          min: 0.5,
                          activeColor: Colors.yellow[400],
                          inactiveColor: Colors.yellow[300],
                          value: ui.sliderFontSize,
                          onChanged: (newValue) {
                            setState(() {
                              ui.fontSize = newValue;
                            });
                          },
                        )
                      ]),
                      SizedBox(height: 4.0),
                      Column(children: [
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Matn o'lchami"),
                                  Text(ui.fontSizeText.toInt().toString())
                                ])),
                        Slider(
                            min: 0.5,
                            activeColor: Colors.yellow[400],
                            inactiveColor: Colors.yellow[300],
                            value: ui.sliderFontSizeText,
                            onChanged: (newValue) {
                              setState(() {
                                ui.fontSizeText = newValue;
                              });
                            })
                      ])
                    ])));
          });
        });
  }
}
