import 'package:musulmonlarqorgoni/common/global.dart';
import 'package:musulmonlarqorgoni/common/tools.dart';
import 'package:musulmonlarqorgoni/menu.dart';
import 'package:musulmonlarqorgoni/models/category.dart';
import 'package:musulmonlarqorgoni/screens/detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _searchQueryController = TextEditingController();

  String searchQuery = "";
  List<Category> categories = [];
  List<Category> suggestionList = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < categoryList.length; i++) {
      final jsonData = Category.fromJson(categoryList[i]);
      categories.add(jsonData);
    }
    setLast();
    suggestionList = categories;
    _controller = AnimationController(vsync: this);
  }

  setLast() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastview', 0);
    prefs.setInt('lastfollow', 0);
    prefs.setInt('lastdetail', 0);
    prefs.setInt('lastactive', 0);
    prefs.setInt('lastsearch', 1);
    prefs.setInt('lastcategory', 0);
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
                title: Container(
                    height: 44.0,
                    margin: EdgeInsets.all(0.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    decoration: BoxDecoration(
                        color: HexColor("#024840"),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: TextField(
                        controller: _searchQueryController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Қидирув",
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                        onChanged: (query) => updateSearchQuery(query))),
                actions: <Widget>[Container(width: 48)]),
            body: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SingleChildScrollView(
                    child: Column(children: [
                  for (var i = 0; i < suggestionList.length; i++)
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DetailScreen(
                                        category: suggestionList[i],
                                      )));
                        },
                        child: getCard(i + 1, suggestionList[i]))
                ]))),
            drawer: Drawer(child: MenuBar())));
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      suggestionList = newQuery.isEmpty
          ? categories
          : categories
              .where((p) =>
                  p.name.contains(RegExp(newQuery, caseSensitive: false)))
              .toList();
    });
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
}
