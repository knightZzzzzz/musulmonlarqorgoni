import 'package:musulmonlarqorgoni/models/uistate.dart';
import 'package:musulmonlarqorgoni/models/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewScreen extends StatefulWidget {
  final View item;

  ViewScreen({this.item});

  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var ui;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    setLast();
  }

  setLast() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastdetail', 0);
    prefs.setInt('lastfollow', 0);
    prefs.setInt('lastactive', 0);
    prefs.setInt('lastsearch', 0);
    prefs.setInt('lastcategory', 0);
    prefs.setInt('lastview', widget.item.id);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ui = Provider.of<UiState>(context);
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
                    icon: Icon(Icons.arrow_back_ios, color: Colors.yellow),
                    onPressed: () {
                      final bool canPop =
                          ModalRoute.of(context)?.canPop ?? false;
                      if (canPop)
                        Navigator.of(context).pop();
                      else
                        Navigator.of(context).pushNamed('/home');
                    }),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                title: Text(widget.item.name),
                actions: <Widget>[
                  IconButton(
                      icon: Image.asset("assets/images/font_size.png",
                          width: 24, height: 24),
                      onPressed: () {
                        showDialogFontSize(context);
                      })
                ]),
            body: SingleChildScrollView(
                child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(
                        top: 8.0, right: 16.0, bottom: 48.0, left: 16.0),
                    child: HtmlWidget(widget.item.text,
                        textStyle: TextStyle(
                            fontSize: ui.fontSizeText,
                            color: Colors.white))))));
  }

  showDialogFontSize(BuildContext context) {
    showDialog(
        context: context,
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
